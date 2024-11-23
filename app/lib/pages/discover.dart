import 'package:app/components/event_list.dart';
import 'package:app/services/config_service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:pocketbase/pocketbase.dart';

class DiscoverPage extends StatefulWidget {
  const DiscoverPage({super.key});

  @override
  State<DiscoverPage> createState() => _DiscoverPageState();
}

Future<List<RecordModel>> getLiveEvents() async {
  final liveEvents = await GetIt.instance<PocketBase>().collection('live_events').getList(perPage: 100, expand: "restaurant_id");
  return liveEvents.items;
}

class _DiscoverPageState extends State<DiscoverPage> {
   @override
  Widget build(BuildContext context) {
    return const EventList(fetcher: getLiveEvents);
  }
}

