import 'package:app/components/restaurant_list.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:pocketbase/pocketbase.dart';

class DiscoverPage extends StatefulWidget {
  const DiscoverPage({super.key});

  @override
  State<DiscoverPage> createState() => _DiscoverPageState();
}

Future<List<RecordModel>> getRestaurants() async {
  final liveEvents = await GetIt.instance<PocketBase>().collection('restaurant_owners').getList(perPage: 100);
  return liveEvents.items;
}

class _DiscoverPageState extends State<DiscoverPage> {
   @override
  Widget build(BuildContext context) {
    return const RestaurantList(fetcher: getRestaurants);
  }
}

