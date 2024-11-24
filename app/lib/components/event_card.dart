import 'package:app/services/config_service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:pocketbase/pocketbase.dart';

class EventCard extends StatelessWidget {
  EventCard({super.key, required this.event, this.onTap});

  final RecordModel event;
  final void Function(RecordModel)? onTap;
  final String imageUrl = "${GetIt.instance<ConfigService>()['apiEndpoint']}/api/files/";

  Uri getImageUrl() {
    final isEmpty = event.data['thumbnail'] == null || event.data['thumbnail'] == '';
    return GetIt.instance<PocketBase>().files.getUrl(isEmpty ? event.expand['restaurant_id']!.first : event,
        isEmpty ? event.expand['restaurant_id']?.first.data['thumbnail'] : event.data['thumbnail'],
        thumb: 'small');
  }

  String formatDateTime(String dateTime) {
    // Use this format: Sun Nov 14
    try {
      final date = DateTime.parse(dateTime);
      return DateFormat('EEE MMM d - HH:mm').format(date);
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
                    frameBuilder: (BuildContext context, Widget child, int? frame, bool wasSynchronouslyLoaded) {
                      if (wasSynchronouslyLoaded) {
                        return child;
                      }
                      return AnimatedOpacity(
                        opacity: frame == null ? 0 : 1,
                        duration: const Duration(seconds: 1),
                        curve: Curves.easeOut,
                        child: child,
                      );
                    },
                    errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                      return const Center(
                        child: Icon(Icons.error),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 4, 0, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        formatDateTime(event.data['start']),
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      Text(
                        event.expand['restaurant_id']?.first.data['restaurant_name'] ?? '',
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge!
                            .copyWith(color: Theme.of(context).colorScheme.primaryContainer),
                      ),
                      const Spacer(),
                      Text(event.data['title'], maxLines: 2, overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(
                            Icons.music_note,
                            size: 16,
                          ),
                          Text(event.data['genre']),
                          const SizedBox(width: 12),
                          const Icon(
                            Icons.monetization_on_outlined,
                            size: 16,
                          ),
                          const SizedBox(width: 2),
                          Text(event.data['price'] == 0 ? 'Free' : '${(event.data['price'] / 100).toStringAsFixed(2)}'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
