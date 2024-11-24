import 'package:app/components/ticket_card.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:qr_flutter/qr_flutter.dart';

class EventTicketsPage extends StatefulWidget {
  const EventTicketsPage({super.key, required this.ticketId});

  final String ticketId;

  @override
  State<EventTicketsPage> createState() => _EventTicketsPageState();
}

class _EventTicketsPageState extends State<EventTicketsPage> {
  Future<RecordModel> getTicket() async {
    final ticket = await GetIt.instance<PocketBase>()
        .collection('tickets')
        .getOne(widget.ticketId, expand: "event,event.restaurant_id");
    return ticket;
  }

  _randomQrData() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  _buildContent(RecordModel ticket) {
    return Row(
      children: [
        Expanded(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: TicketCard(ticket: ticket, onTap: null)),
              const SizedBox(height: 24),
              Expanded(
                child: Center(
                  child: Swiper(
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    side: BorderSide(color: Colors.grey.shade300),
                                  ),
                                  elevation: 0,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text('Ticket ${index + 1} of ${ticket.data['amount']}', style: Theme.of(context).textTheme.titleLarge),
                                      const SizedBox(height: 24),
                                      Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 24),
                                        child: QrImageView(data: ticket.id + _randomQrData(), version: 4,)),
                                    ],
                                  )),
                            ),
                          ),
                          const SizedBox(height: 42),
                        ],
                      );
                    },
                    itemCount: ticket.data['amount'],
                    pagination: SwiperPagination(
                      builder: DotSwiperPaginationBuilder(
                        color: Theme.of(context).colorScheme.onSurface,
                        activeColor: Theme.of(context).colorScheme.primaryContainer,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tickets'),
        
      ),
      body: SafeArea(
        child: FutureBuilder(
          future: getTicket(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                final RecordModel ticket = snapshot.data;
        
                return _buildContent(ticket);
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error loading data: ${snapshot.error}'),
                );
              }
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}
