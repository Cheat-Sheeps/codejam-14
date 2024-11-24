import 'package:app/components/ticket_list.dart';
import 'package:app/pages/event_tickets.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:pocketbase/pocketbase.dart';

class MyTicketsPage extends StatefulWidget {
  const MyTicketsPage({super.key});

  @override
  State<MyTicketsPage> createState() => _MyTicketsPageState();
}

class _MyTicketsPageState extends State<MyTicketsPage> {
  Future<List<RecordModel>> getTickets() async {
    final filterQuery = 'user ~ "${GetIt.instance<PocketBase>().authStore.model.id}"';
    final liveEvents = await GetIt.instance<PocketBase>()
        .collection('tickets')
        .getList(perPage: 1000, expand: "event,event.restaurant_id", sort: "event.start", filter: filterQuery);
    return liveEvents.items;
  }

  @override
  Widget build(BuildContext context) {
    return TicketList(
      fetcher: getTickets,
      onTap: (ticket) {
        Navigator.push(context, MaterialPageRoute(builder: (context) => EventTicketsPage(ticketId: ticket.id)));
      },
    );
  }
}
