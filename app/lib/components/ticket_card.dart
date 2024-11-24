import 'package:app/services/config_service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:pocketbase/pocketbase.dart';

class TicketCard extends StatelessWidget {
  TicketCard({super.key, required this.ticket, this.onTap});

  final RecordModel ticket;
  final void Function(RecordModel)? onTap;
  final String imageUrl = "${GetIt.instance<ConfigService>()['apiEndpoint']}/api/files/";

  Uri getImageUrl() {
    final isEmpty = ticket.expand['event']?.first.data['thumbnail'] == null;
    return GetIt.instance<PocketBase>().files.getUrl(
        isEmpty
            ? ticket.expand['event']!.first.expand['restaurant_id']!.first
            : ticket.expand['event']!.first,
        isEmpty
            ? ticket.expand['restaurant_id']!.first.data['thumbnail']
            : ticket.expand['event']!.first.data['thumbnail'],
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
    final event = ticket.expand['event']!.first;
    final restaurant = event.expand['restaurant_id']!.first;
    return Material(
      color: Colors.transparent, // Ensures the ripple effect is visible
      child: InkWell(
        onTap: () => onTap?.call(ticket),
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
                  padding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        formatDateTime(event.data['start'] ?? ''),
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      Text(
                        restaurant.data['restaurant_name'],
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge!
                            .copyWith(color: Theme.of(context).colorScheme.primaryContainer),
                      ),
                      const SizedBox(height: 4),
                      Text(event.data['title'], maxLines: 2, overflow: TextOverflow.ellipsis),
                      const Spacer(),
                      Row(
                        children: [
                          const Icon(
                            Icons.person,
                            size: 32,
                          ),
                          Text(
                            '${ticket.data['amount']}',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
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
