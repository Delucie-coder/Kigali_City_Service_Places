import 'package:flutter/material.dart';

import 'package:kigali_city_service_places/screens/directory_screen.dart';
import 'package:kigali_city_service_places/screens/bookings_screen.dart';
import 'package:kigali_city_service_places/screens/listing_form_screen.dart';
import 'package:kigali_city_service_places/screens/map_view_screen.dart';
import 'package:kigali_city_service_places/screens/my_listings_screen.dart';
import 'package:kigali_city_service_places/screens/review_screen.dart';
import 'package:kigali_city_service_places/screens/settings_screen.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;

  static const List<String> _titles = <String>[
    'Home',
    'Bookmark',
    'Bookings',
    'Review',
    'Map View',
    'Settings',
  ];

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = <Widget>[
      const DirectoryScreen(),
      const MyListingsScreen(),
      const BookingsScreen(),
      const ReviewScreen(),
      const MapViewScreen(),
      const SettingsScreen(),
    ];

    return Scaffold(
      appBar: AppBar(title: Text(_titles[_index])),
      body: pages[_index],
      floatingActionButton: _index == 0 || _index == 1
          ? FloatingActionButton.extended(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => const ListingFormScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.add),
              label: const Text('Add Listing'),
            )
          : null,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (int value) {
          setState(() {
            _index = value;
          });
        },
        destinations: const <NavigationDestination>[
          NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Home'),
          NavigationDestination(
            icon: Icon(Icons.bookmark_outline),
            label: 'Bookmark',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_month_outlined),
            label: 'Bookings',
          ),
          NavigationDestination(
            icon: Icon(Icons.reviews_outlined),
            label: 'Review',
          ),
          NavigationDestination(
            icon: Icon(Icons.map_outlined),
            label: 'Map View',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
