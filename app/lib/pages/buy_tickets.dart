import 'dart:convert';

import 'package:app/pages/home_page.dart';
import 'package:app/services/config_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart' as stripe;
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:http/http.dart' as http;

class BuyTicketsPage extends StatefulWidget {
  const BuyTicketsPage({super.key, required this.event});

  final RecordModel event;

  @override
  State<BuyTicketsPage> createState() => _BuyTicketsPageState();
}

class _BuyTicketsPageState extends State<BuyTicketsPage> {
  final String imageUrl = "${GetIt.instance<ConfigService>()['apiEndpoint']}/api/files/";
  bool _isLoading = false;

  Uri getImageUrl() {
    final isEmpty = widget.event.data['thumbnail'] == null || widget.event.data['thumbnail'] == '';
    return GetIt.instance<PocketBase>().files.getUrl(
        isEmpty ? widget.event.expand['restaurant_id']!.first : widget.event,
        isEmpty ? widget.event.expand['restaurant_id']?.first.data['thumbnail'] : widget.event.data['thumbnail'],
        thumb: 'small');
  }

  String formatDateTime(String dateTime) {
    try {
      final date = DateTime.parse(dateTime);
      return DateFormat('EEE MMM d').format(date);
    } catch (e) {
      return '';
    }
  }

  String formatWeekDay(String dateTime) {
    try {
      final date = DateTime.parse(dateTime);
      return DateFormat('EEE').format(date);
    } catch (e) {
      return '';
    }
  }

  String formatMonth(String dateTime) {
    try {
      final date = DateTime.parse(dateTime);
      return DateFormat('MMM').format(date);
    } catch (e) {
      return '';
    }
  }

  String formatDay(String dateTime) {
    try {
      final date = DateTime.parse(dateTime);
      return DateFormat('d').format(date);
    } catch (e) {
      return '';
    }
  }

  String formatHour(String dateTime) {
    try {
      final date = DateTime.parse(dateTime);
      return DateFormat('HH:mm').format(date);
    } catch (e) {
      return '';
    }
  }

  String formatPrice(int price, int quantity) {
    return price == 0 ? 'Free' : 'CA\$${(price * quantity / 100).toStringAsFixed(2)}';
  }

  int ticketCount = 1;
  Map<String, dynamic>? paymentIntentData;

  void incrementTicket() {
    ticketCount++;
    setState(() {});
  }

  void decrementTicket() {
    if (ticketCount > 1) ticketCount--;
    setState(() {});
  }

  createTickets() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final tickets = await GetIt.instance<PocketBase>().collection('tickets').create(body: {
        'user': GetIt.instance<PocketBase>().authStore.model.id,
        'event': widget.event.id,
        'amount': ticketCount,
      });

      setState(() {
        _isLoading = false;
      });

      return tickets;
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      debugPrint(e.toString());
    }
  }

  displayPaymentSheet() async {
    try {
      await stripe.Stripe.instance.presentPaymentSheet().then(
        (value) async {
          await createTickets();
          Navigator.pushAndRemoveUntil(context,
              MaterialPageRoute(builder: (context) => const HomePage(initOnTicketPage: true)), (route) => false);
        },
        onError: (e) {
          debugPrint('Payment failed: $e');
        },
      );
    } on stripe.StripeException catch (e) {
      debugPrint('Payment failed: ${e.error.localizedMessage}');
    } catch (e) {
      debugPrint('An unexpected error occurred: $e');
    }
  }

  createPaymentIntent(String amount, String currency) async {
    final stripeSecretKey = GetIt.instance<ConfigService>()['stripeSK'];
    try {
      Map<String, dynamic> body = {'amount': amount, 'currency': currency, 'payment_method_types[]': 'card'};
      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        body: body,
        headers: {'Authorization': 'Bearer $stripeSecretKey', 'Content-Type': 'application/x-www-form-urlencoded'},
      );

      return jsonDecode(response.body.toString());
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> makePayment({required String amount, required String currency}) async {
    try {
      paymentIntentData = await createPaymentIntent(amount, currency);
      const gpay = stripe.PaymentSheetGooglePay(
        merchantCountryCode: "US",
        currencyCode: "USD",
        testEnv: true,
      );
      if (paymentIntentData != null) {
        await stripe.Stripe.instance.initPaymentSheet(
          paymentSheetParameters: stripe.SetupPaymentSheetParameters(
            googlePay: gpay,
            merchantDisplayName: 'Adiwele',
            paymentIntentClientSecret: paymentIntentData!['client_secret'],
            customerEphemeralKeySecret: paymentIntentData!['ephemeralKey'],
          ),
        );
        displayPaymentSheet();
      }
    } catch (e, s) {
      debugPrint('exception:$e$s');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.event.expand['restaurant_id']?.first.data['restaurant_name'] ?? '',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: SafeArea(
        child: Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 4,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: AspectRatio(
                              aspectRatio: 1,
                              child: Image.network(
                                getImageUrl().toString(),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(12, 0, 0, 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 6),
                                    Text(
                                      formatWeekDay(widget.event.data['start']),
                                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                                          fontWeight: FontWeight.bold,
                                          height: 1.1,
                                          fontFamily: 'RobotoMono',
                                          color: Theme.of(context).colorScheme.primaryContainer),
                                    ),
                                    Text(
                                      formatDay(widget.event.data['start']),
                                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                                          fontWeight: FontWeight.bold,
                                          height: 1.1,
                                          fontSize: 52,
                                          letterSpacing: 3,
                                          color: Theme.of(context).colorScheme.primaryContainer),
                                    ),
                                    Text(
                                      formatMonth(widget.event.data['start']),
                                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context).colorScheme.primaryContainer),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.music_note,
                                          size: 24,
                                        ),
                                        Text(widget.event.data['genre'],
                                            style: Theme.of(context).textTheme.titleMedium),
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.attach_money,
                                          size: 24,
                                        ),
                                        const SizedBox(width: 2),
                                        Text(
                                            widget.event.data['price'] == 0
                                                ? 'Free'
                                                : '${(widget.event.data['price'] / 100).toStringAsFixed(2)}',
                                            style: Theme.of(context).textTheme.titleMedium),
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.schedule,
                                          size: 24,
                                        ),
                                        const SizedBox(width: 2),
                                        Text(formatHour(widget.event.data['start']),
                                            style: Theme.of(context).textTheme.titleMedium),
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(widget.event.data['title'].toString(),
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.normal)),
                  const SizedBox(height: 12),
                  const Padding(padding: EdgeInsets.symmetric(horizontal: 12), child: Divider()),
                  const SizedBox(height: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(color: Colors.grey.shade300),
                        ),
                        elevation: 0,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "General Admission",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade200,
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: IconButton(
                                          onPressed: () => decrementTicket(),
                                          icon: const Icon(Icons.remove, color: Colors.black),
                                          splashRadius: 20,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        '$ticketCount',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.blue,
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: IconButton(
                                          onPressed: () => incrementTicket(),
                                          icon: const Icon(Icons.add, color: Colors.white),
                                          splashRadius: 20,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Text(
                                    formatPrice(widget.event.data['price'], ticketCount),
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            makePayment(amount: (widget.event.data['price'] * ticketCount).toString(), currency: 'cad');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).colorScheme.onSecondaryContainer,
                          ),
                          child: const Text("Buy Tickets"),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
