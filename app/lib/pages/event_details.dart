import 'package:app/services/config_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:pocketbase/pocketbase.dart';

class EventDetailsPage extends StatefulWidget {
  const EventDetailsPage({super.key, required this.event});

  final RecordModel event;

  @override
  State<EventDetailsPage> createState() => _EventDetailsPageState();
}

class _EventDetailsPageState extends State<EventDetailsPage> {
  final String imageUrl = "${GetIt.instance<ConfigService>()['apiEndpoint']}/api/files/";

  Uri getImageUrl() {
    final isEmpty = widget.event.data['thumbnail'] == null || widget.event.data['thumbnail'] == '';
    return GetIt.instance<PocketBase>().files.getUrl(
        isEmpty ? widget.event.expand['restaurant_id']!.first : widget.event,
        isEmpty ? widget.event.expand['restaurant_id']?.first.data['thumbnail'] : widget.event.data['thumbnail'],
        thumb: 'small');
  }

  String formatDateTime(String dateTime) {
    // Use this format: Sun Nov 14
    try {
      final date = DateTime.parse(dateTime);
      return DateFormat('EEE MMM d').format(date);
    } catch (e) {
      return '';
    }
  }

  String formatWeekDay(String dateTime) {
    // Use this format: Sun
    try {
      final date = DateTime.parse(dateTime);
      return DateFormat('EEE').format(date);
    } catch (e) {
      return '';
    }
  }

  String formatMonth(String dateTime) {
    // Use this format: Nov
    try {
      final date = DateTime.parse(dateTime);
      return DateFormat('MMM').format(date);
    } catch (e) {
      return '';
    }
  }

  String formatDay(String dateTime) {
    // Use this format: 14
    try {
      final date = DateTime.parse(dateTime);
      return DateFormat('d').format(date);
    } catch (e) {
      return '';
    }
  }

  String formatHour(String dateTime) {
    // Use this format: 14
    try {
      final date = DateTime.parse(dateTime);
      return DateFormat('HH:mm').format(date);
    } catch (e) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.event.expand['restaurant_id']?.first.data['restaurant_name'] ?? '',
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
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
                                          Icons.monetization_on_outlined,
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
                  Text(widget.event.data['description']),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: MaterialButton(
            onPressed: () {},
            visualDensity: VisualDensity.comfortable,
            color: Theme.of(context).colorScheme.tertiaryContainer,
            textColor: Theme.of(context).colorScheme.onTertiaryContainer,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Text('Get Tickets', style: TextStyle(color: Colors.white)),
          ),
        ),
      ),
    );
  }
}
