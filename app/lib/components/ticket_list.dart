import 'package:app/components/ticket_card.dart';
import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';

class TicketList extends StatefulWidget {
  const TicketList({super.key, required this.fetcher, this.onTap});

  final Future<List<RecordModel>> Function() fetcher;

  final void Function(RecordModel)? onTap;

  @override
  State<TicketList> createState() => _TicketListState();
}

class _TicketListState extends State<TicketList> {
  late Future<List<RecordModel>> _futureTickets;

  @override
  void initState() {
    super.initState();
    _futureTickets = widget.fetcher();
  }

  Future<void> _refreshEvents() async {
    setState(() {
      _futureTickets = widget.fetcher();
    });
    await _futureTickets;
  }

  @override
  Widget build(BuildContext context) {
    _refreshEvents();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: FutureBuilder(
        future: _futureTickets,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              final List<RecordModel> tickets = snapshot.data;

              if (tickets.isEmpty) {
                return const Center(
                  child: Text('No tickets found'),
                );
              }

              return RefreshIndicator(
                onRefresh: _refreshEvents,
                child: ListView.separated(
                  itemCount: tickets.length,
                  separatorBuilder: (BuildContext context, int index) => const SizedBox(height: 24),
                  itemBuilder: (BuildContext context, int index) {
                    return TicketCard(ticket: tickets[index], onTap: widget.onTap);
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
