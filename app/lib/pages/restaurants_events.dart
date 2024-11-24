import 'package:app/components/event_list.dart';
import 'package:app/components/filter.dart';
import 'package:app/pages/event_details.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:pocketbase/pocketbase.dart';

class RestaurantEventsPage extends StatefulWidget {
  const RestaurantEventsPage({super.key, required this.restaurantId, required this.restaurantName});

  final String restaurantId;
  final String restaurantName;

  @override
  State<RestaurantEventsPage> createState() => _RestaurantEventsPageState();
}

class _RestaurantEventsPageState extends State<RestaurantEventsPage> {
  Future<List<RecordModel>> getLiveEvents(Filter? filter) async {
    final liveEvents = await GetIt.instance<PocketBase>()
        .collection('live_events')
        .getList(perPage: 1000, expand: "restaurant_id", sort: "start", filter: 'restaurant_id ~ "${widget.restaurantId}"');
    return liveEvents.items;
  }

  @override
  Widget build(BuildContext context) {
    getLiveEvents(null);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.restaurantName),
      ),
      body: EventList(
        fetcher: getLiveEvents,
        onTap: (event) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EventDetailsPage(event: event),
            ),
          );
        },
      ),
    );
  }
}
