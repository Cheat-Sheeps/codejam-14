import 'package:app/services/config_service.dart';
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
    return GetIt.instance<PocketBase>().files.getUrl(widget.event, widget.event.data['thumbnail'] ?? widget.event.expand['restaurant_id']?.first.data['thumbnail']);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
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
              Row(
                children: [
                  Expanded(
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
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(12, 0, 64, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Event',
                            style: Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            formatWeekDay(widget.event.data['start']),
                            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                                fontWeight: FontWeight.bold,
                                fontFamily: 'RobotoMono',
                                color: Theme.of(context).colorScheme.primaryContainer),
                          ),
                          Text(
                            formatDay(widget.event.data['start']),
                            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 52,
                                color: Theme.of(context).colorScheme.primaryContainer),
                          ),
                          Text(
                            formatMonth(widget.event.data['start']),
                            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                                fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primaryContainer),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              // Text(widget.event.data['description']),
              const SizedBox(height: 24),
              Text(widget.event.data['title'].toString().toUpperCase(),
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.normal)),
              Expanded(child: Text(widget.event.data['description'])),
            ],
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
