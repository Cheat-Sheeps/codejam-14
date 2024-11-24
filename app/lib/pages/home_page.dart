import 'package:app/components/filter.dart';
import 'package:app/components/search_bar.dart';
import 'package:app/pages/discover.dart';
import 'package:app/pages/for_you.dart';
import 'package:app/pages/login_page.dart';
import 'package:app/pages/my_tickets.dart';
import 'package:app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:pocketbase/pocketbase.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, this.initOnTicketPage = false});

  final bool initOnTicketPage;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  Filter _filter = Filter();

  String get _title {
    switch (_selectedIndex) {
      case 0:
        return 'Events For You';
      case 1:
        return 'Discover Live Music Restaurants';
      case 2:
        return 'Tickets';
    }
    return '';
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void onQueryUpdated(String query) {
    setState(() {
      _filter = Filter(query, _filter.matchesDate);
    });
  }

  @override
  void initState() {
    super.initState();
    if (widget.initOnTicketPage) {
      _selectedIndex = 2;
    }
  }

  void _logout() {
    GetIt.instance.get<AuthService>().clearToken();
    GetIt.instance.get<PocketBase>().authStore.clear();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginPage()));
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_title, style: Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold)),
        centerTitle: false,
        surfaceTintColor: Colors.transparent,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
        bottom: _selectedIndex != 2 ? PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: SearchBarWidget(onQueryUpdated: onQueryUpdated),
        ) : null,
      ),
      body: <Widget>[
        ForYouPage(filter: _filter),
        DiscoverPage(filter: _filter),
        const MyTicketsPage(),
      ].elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'For You',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore_outlined),
            label: 'Discover',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_activity_outlined),
            label: 'Tickets',
          ),
        ],
      ),
    );
  }
}
