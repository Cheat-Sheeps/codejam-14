import 'package:app/components/event_list.dart';
import 'package:app/components/filter.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:pocketbase/pocketbase.dart';

class ForYouPage extends StatefulWidget {
  const ForYouPage({super.key, required this.filter});

  final Filter filter;

  @override
  State<ForYouPage> createState() => _ForYouPageState();
}

class _ForYouPageState extends State<ForYouPage> {
  Future<List<RecordModel>> getLiveEvents(Filter filter) async {
    final String? filterQuery = filter.containsText.isEmpty ? null : 'title ~ "${filter.containsText}"';
    final liveEvents = await GetIt.instance<PocketBase>()
        .collection('live_events')
        .getList(perPage: 10, expand: "restaurant_id", sort: "start", filter: filterQuery, query: {"search": filter.containsText});
    return liveEvents.items;
  }

  @override
  Widget build(BuildContext context) {
    return EventList(
      fetcher: getLiveEvents,
      filter: widget.filter,
      onTap: (p0) {
        print(p0);
      },
    );
  }
}
