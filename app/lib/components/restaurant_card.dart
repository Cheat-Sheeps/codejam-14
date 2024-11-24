import 'package:app/services/config_service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:pocketbase/pocketbase.dart';

class RestaurantCard extends StatelessWidget {
  RestaurantCard({super.key, required this.restaurant, this.onTap});

  final RecordModel restaurant;
  final void Function(RecordModel)? onTap;
  final String imageUrl = "${GetIt.instance<ConfigService>()['apiEndpoint']}/api/files/";

  Uri getImageUrl() {
    return GetIt.instance<PocketBase>().files.getUrl(restaurant, restaurant.data['thumbnail']);
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

  RecordModel? findNextEvent() {
    final events = restaurant.expand['live_events_via_restaurant_id'];

    if (events == null || events.isEmpty) {
      return null;
    }

    events.sort((a, b) => a.data['start'].compareTo(b.data['start']));
    final now = DateTime.now();
    return events.firstWhere((event) => DateTime.parse(event.data['start']).isAfter(now));
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent, // Ensures the ripple effect is visible
      child: InkWell(
        onTap: () => onTap?.call(restaurant),
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
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        restaurant.data['city'],
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      Text(
                        restaurant.data['restaurant_name'] ?? '',
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge!
                            .copyWith(color: Theme.of(context).colorScheme.primaryContainer),
                      ),
                      const Spacer(),
                      const Text('Next event:'),
                      Text(
                        findNextEvent()?.data['start'] != null
                            ? formatDateTime(findNextEvent()!.data['start'])
                            : 'No events',
                        style: Theme.of(context).textTheme.titleSmall,
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
