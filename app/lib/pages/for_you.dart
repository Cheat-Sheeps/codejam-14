import 'package:app/components/event_list.dart';
import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';

Future<List<RecordModel>> getLiveEvents() async {
  final liveEvents = await pb.collection('live_events').getList(perPage: 100, expand: "restaurant_id");
  return liveEvents.items;
}

class ForYouPage extends StatefulWidget {
  const ForYouPage({super.key});
  @override
  State<ForYouPage> createState() => _ForYouPageState();
}

class _ForYouPageState extends State<ForYouPage> {
  @override
  Widget build(BuildContext context) {
    return EventList(
      fetcher: getLiveEvents,
      onTap: (p0) {
        print(p0);
      },
    );
  }
}
