import 'dart:math';

import 'package:app/components/filter.dart';
import 'package:app/components/login_widget.dart';
import 'package:app/components/search_bar.dart';
import 'package:app/pages/discover.dart';
import 'package:app/pages/for_you.dart';
import 'package:app/pages/login_page.dart';
import 'package:app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:pocketbase/pocketbase.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: SearchBarWidget(onQueryUpdated: onQueryUpdated),
        ),
      ),
      body: <Widget>[
        ForYouPage(filter: _filter),
        DiscoverPage(filter: _filter),
        const Text('Tickets'),
      ].elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'For You',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            label: 'Discover',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event),
            label: 'Tickets',
          ),
        ],
      ),
    );
  }
}
