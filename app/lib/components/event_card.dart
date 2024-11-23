import 'package:app/pages/discover.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pocketbase/pocketbase.dart';

class EventCard extends StatelessWidget {
  const EventCard({super.key, required this.event, this.onTap});

  final RecordModel event;
  final void Function(RecordModel)? onTap;
  final String imageUrl = 'http://127.0.0.1:8090/api/files';

  Uri getImageUrl() {
    return pb.files.getUrl(event, event.data['thumbnail']);
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

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent, // Ensures the ripple effect is visible
      child: InkWell(
        onTap: () => onTap?.call(event),
        borderRadius: BorderRadius.circular(8.0), // Matches the image border radius
        child: SizedBox(
          height: 160,
          child: Row(
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: SizedBox(
                  height: 160,
                  width: 160,
                  child: Image.network(
                    getImageUrl().toString(),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      formatDateTime(event.data['start']),
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    Text(
                      event.expand['restaurant_id']?.first.data['restaurant_name'] ?? '',
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(color: Theme.of(context).colorScheme.primaryContainer),
                    ),
                    const Spacer(),
                    Text(event.data['title']),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
