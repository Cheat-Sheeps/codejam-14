import 'package:app/components/event_card.dart';
import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';

class EventList extends StatefulWidget {
  const EventList({super.key, required this.fetcher, this.onTap});

  final Future<List<RecordModel>> Function() fetcher;

  final void Function(RecordModel)? onTap;

  @override
  State<EventList> createState() => _EventListState();
}

class _EventListState extends State<EventList> {
  late Future<List<RecordModel>> _futureEvents;

  @override
  void initState() {
    super.initState();
    _futureEvents = widget.fetcher();
  }

  Future<void> _refreshEvents() async {
    setState(() {
      _futureEvents = widget.fetcher();
    });
    await _futureEvents;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: FutureBuilder(
        future: _futureEvents,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              final List<RecordModel> liveEvents = snapshot.data;
              return RefreshIndicator(
                onRefresh: _refreshEvents,
                child: ListView.separated(
                  itemCount: liveEvents.length,
                  separatorBuilder: (BuildContext context, int index) => const SizedBox(height: 24),
                  itemBuilder: (BuildContext context, int index) {
                    return EventCard(event: liveEvents[index], onTap: widget.onTap);
                  },
                ),
              );
            } else if (snapshot.hasError) {
              return const Center(
                child: Text('Error loading data'),
              );
            }
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}