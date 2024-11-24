import 'package:app/components/filter.dart';
import 'package:app/components/restaurant_card.dart';
import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';

const String pocketBaseUrl = 'http://127.0.0.1:8090/';
final PocketBase pb = PocketBase(pocketBaseUrl);

class RestaurantList extends StatefulWidget {
  const RestaurantList({super.key, required this.fetcher, required this.filter, this.onTap});

  final Future<List<RecordModel>> Function(Filter filter) fetcher;
  final Filter filter;

  final void Function(RecordModel)? onTap;

  @override
  State<RestaurantList> createState() => _RestaurantListState();
}

class _RestaurantListState extends State<RestaurantList> {
  late Future<List<RecordModel>> _futureRestaurants;

  @override
  void initState() {
    super.initState();
    _futureRestaurants = widget.fetcher(widget.filter);
  }

  Future<void> _refreshRestaurants() async {
    setState(() {
      _futureRestaurants = widget.fetcher(widget.filter);
    });
    await _futureRestaurants;
  }

  @override
  Widget build(BuildContext context) {
    _refreshRestaurants();
    return Padding(
      padding: const EdgeInsets.all(12),
      child: FutureBuilder(
        future: _futureRestaurants,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              final List<RecordModel> liveEvents = snapshot.data;
              return RefreshIndicator(
                onRefresh: _refreshRestaurants,
                child: ListView.separated(
                  itemCount: liveEvents.length,
                  separatorBuilder: (BuildContext context, int index) => const SizedBox(height: 24),
                  itemBuilder: (BuildContext context, int index) {
                    return RestaurantCard(restaurant: liveEvents[index], onTap: widget.onTap);
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
