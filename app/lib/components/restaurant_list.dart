import 'package:app/components/restaurant_card.dart';
import 'package:app/components/filter.dart';
import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';

class RestaurantList extends StatefulWidget {
  const RestaurantList({super.key, required this.fetcher, required this.filter, this.onTap});

  final Future<List<RecordModel>> Function(Filter filter) fetcher;
  final Filter filter;

  final void Function(RecordModel)? onTap;

  @override
  State<RestaurantList> createState() => _RestaurantListState();
}

class _RestaurantListState extends State<RestaurantList> {
  late Future<List<RecordModel>> _futureEvents;

  @override
  void initState() {
    super.initState();
    _futureEvents = widget.fetcher(widget.filter);
  }

  Future<void> _refreshEvents() async {
    setState(() {
      _futureEvents = widget.fetcher(widget.filter);
    });
    await _futureEvents;
  }

  @override
  Widget build(BuildContext context) {
    _refreshEvents();
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
                    return RestaurantCard(event: liveEvents[index], onTap: widget.onTap);
                  },
                ),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error loading data: ${snapshot.error}'),
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
