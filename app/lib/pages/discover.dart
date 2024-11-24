import 'package:app/components/event_list.dart';
import 'package:app/components/filter.dart';
import 'package:app/components/search_bar.dart';
import 'package:app/services/config_service.dart';
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
  Future<List<RecordModel>> getLiveEvents(Filter filter) async {
    String query = "";

    // TODO date
    final liveEvents = await GetIt.instance<PocketBase>()
        .collection('live_events')
        .getList(perPage: 100, expand: "restaurant_id");

    List<RecordModel> items = [];
    for (var record in liveEvents.items) {
      String? x = record.expand['restaurant_id']?[0].data["restaurant_name"];
      if (x != null && x.toLowerCase().contains(filter.containsText.toLowerCase()))
      {
        items.add(record);
      }
    }

    return items;
  }

  @override
  Widget build(BuildContext context) {
    return EventList(
      fetcher: getLiveEvents,
      filter: widget.filter
    );
  }
}

