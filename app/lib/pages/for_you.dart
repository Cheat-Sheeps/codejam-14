import 'package:app/components/event_list.dart';
import 'package:app/pages/event_details.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:pocketbase/pocketbase.dart';

Future<List<RecordModel>> getLiveEvents(String? query) async {
  final liveEvents = await GetIt.instance<PocketBase>().collection('live_events').getList(perPage: 100, expand: "restaurant_id");
  return liveEvents.items; 
}

class ForYouPage extends StatefulWidget {
  const ForYouPage({super.key, this.query});
  
  final String? query;

  @override
  State<ForYouPage> createState() => _ForYouPageState();
}

class _ForYouPageState extends State<ForYouPage> {
  @override
  Widget build(BuildContext context) {
    return EventList(
      fetcher: () => getLiveEvents(widget.query),
      onTap: (event) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EventDetailsPage(event: event),
          ),
        );
      },
    );
  }
}
