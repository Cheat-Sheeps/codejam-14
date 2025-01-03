import 'package:app/components/event_list.dart';
import 'package:app/components/filter.dart';
import 'package:app/pages/event_details.dart';
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
  Future<List<RecordModel>> getLiveEvents(Filter? filter) async {
    final currentDateTime = DateTime.now();
    final baseFilter = 'start >= "${currentDateTime.toIso8601String()}"';
    final String filterQuery = (filter?.containsText.isEmpty ?? false) ? baseFilter : '$baseFilter && title ~ "${filter!.containsText}" || description ~ "${filter.containsText}" || restaurant_id.restaurant_name ~ "${filter.containsText}" || restaurant_id.city ~ "${filter.containsText}" || genre ~ "${filter.containsText}"';
    final liveEvents = await GetIt.instance<PocketBase>()
        .collection('live_events')
        .getList(perPage: 1000, expand: "restaurant_id", sort: "start", filter: filterQuery);
    return liveEvents.items;
  }

  @override
  Widget build(BuildContext context) {
    return EventList(
      fetcher: getLiveEvents,
      filter: widget.filter,
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
