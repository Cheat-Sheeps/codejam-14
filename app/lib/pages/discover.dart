import 'package:app/components/filter.dart';
import 'package:app/components/restaurant_list.dart';
import 'package:app/pages/restaurants_events.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:pocketbase/pocketbase.dart';

class DiscoverPage extends StatefulWidget {
  const DiscoverPage({super.key, required this.filter});

  final Filter filter;

  @override
  State<DiscoverPage> createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {
  Future<List<RecordModel>> getRestaurants(Filter filter) async {
    final String? filterQuery = filter.containsText.isEmpty ? null : 'restaurant_name ~ "${filter.containsText}"';
    final liveEvents = await GetIt.instance<PocketBase>()
        .collection('restaurant_owners')
        .getList(perPage: 100, expand: "restaurant_id", filter: filterQuery);


    return liveEvents.items;
  }

  @override
  Widget build(BuildContext context) {
    return RestaurantList(
      fetcher: getRestaurants,
      filter: widget.filter,
      onTap: (event) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RestaurantEventsPage(restaurantId: event.id, restaurantName: event.data['restaurant_name'] as String),
          ),
        );
      },
    );
  }
}

