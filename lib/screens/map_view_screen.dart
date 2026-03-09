import 'package:flutter/material.dart' hide Icon;
import 'package:flutter/material.dart' as material;
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

import 'package:kigali_city_service_places/models/listing.dart';
import 'package:kigali_city_service_places/screens/listing_detail_screen.dart';
import 'package:kigali_city_service_places/state/listing_provider.dart';

class MapViewScreen extends StatefulWidget {
  const MapViewScreen({super.key});

  @override
  State<MapViewScreen> createState() => _MapViewScreenState();
}

class _MapViewScreenState extends State<MapViewScreen> {
  static const LatLng _kigaliCenter = LatLng(-1.9441, 30.0619);

  String? _selectedListingId;
  String? _lastCameraTargetKey;
  final MapController _mapController = MapController();
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _mapController.dispose();
    super.dispose();
  }

  void _syncSearchField(String query) {
    if (_searchController.text == query) {
      return;
    }
    _searchController.value = TextEditingValue(
      text: query,
      selection: TextSelection.collapsed(offset: query.length),
    );
  }

  void _focusCameraOnListing(Listing? listing) {
    final String targetKey = listing?.id ?? 'kigali';
    if (_lastCameraTargetKey == targetKey) {
      return;
    }
    _lastCameraTargetKey = targetKey;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      _mapController.move(
        listing == null
            ? _kigaliCenter
            : LatLng(listing.latitude, listing.longitude),
        listing == null ? 12 : 14,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final ListingProvider listingProvider = context.watch<ListingProvider>();
    final List<Listing> listings = listingProvider.allListings;
    final List<Listing> visibleListings = listingProvider.filteredListings;
    _syncSearchField(listingProvider.searchQuery);

    if (listings.isEmpty) {
      return const Center(child: Text('No listings available for map view.'));
    }

    final Listing? active = visibleListings.isEmpty
        ? null
        : visibleListings.firstWhere(
            (Listing listing) => listing.id == _selectedListingId,
            orElse: () => visibleListings.first,
          );

    _focusCameraOnListing(active);

    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: TextField(
            controller: _searchController,
            onChanged: listingProvider.setSearchQuery,
            decoration: InputDecoration(
              hintText: 'Search by name, category, or address',
              prefixIcon: const material.Icon(Icons.search),
              suffixIcon: listingProvider.searchQuery.isEmpty
                  ? null
                  : IconButton(
                      tooltip: 'Clear search',
                      onPressed: () {
                        listingProvider.setSearchQuery('');
                        _searchController.clear();
                      },
                      icon: const material.Icon(Icons.clear, size: 20),
                    ),
            ),
          ),
        ),
        if (listingProvider.errorMessage != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              listingProvider.errorMessage!,
              style: const TextStyle(color: Colors.redAccent),
            ),
          ),
        Expanded(
          child: FlutterMap(
            mapController: _mapController,
            options: MapOptions(initialCenter: _kigaliCenter, initialZoom: 12),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.app',
              ),
              MarkerLayer(
                markers: visibleListings.map((listing) {
                  final bool isSelected = _selectedListingId == listing.id;
                  return Marker(
                    point: LatLng(listing.latitude, listing.longitude),
                    width: 60,
                    height: 60,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedListingId = listing.id;
                        });
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(listing.name),
                            action: SnackBarAction(
                              label: 'Details',
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute<void>(
                                    builder: (_) =>
                                        ListingDetailScreen(listing: listing),
                                  ),
                                );
                              },
                            ),
                            duration: const Duration(seconds: 4),
                          ),
                        );
                      },
                      child: material.Icon(
                        Icons.location_on,
                        color: isSelected
                            ? Colors.red
                            : Colors.red.withAlpha((0.7 * 255).round()),
                        size: isSelected ? 40 : 35,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
