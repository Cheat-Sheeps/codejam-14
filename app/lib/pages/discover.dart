import 'package:app/components/event_list.dart';
import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';

final PocketBase pb = PocketBase('http://127.0.0.1:8090');

class DiscoverPage extends StatefulWidget {
  const DiscoverPage({super.key});

  @override
  State<DiscoverPage> createState() => _DiscoverPageState();
}

Future<List<RecordModel>> getLiveEvents() async {
  final liveEvents = await pb.collection('live_events').getList(perPage: 100, expand: "restaurant_id");
  return liveEvents.items;
}

class _DiscoverPageState extends State<DiscoverPage> {
   @override
  Widget build(BuildContext context) {
    return const EventList(fetcher: getLiveEvents);
  }
}

