import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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
  GoogleMapController? _mapController;
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _mapController?.dispose();
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
      if (!mounted || _mapController == null) {
        return;
      }

      final CameraPosition cameraPosition = CameraPosition(
        target: listing == null
            ? _kigaliCenter
            : LatLng(listing.latitude, listing.longitude),
        zoom: listing == null ? 12 : 14,
      );
      _mapController!.animateCamera(
        CameraUpdate.newCameraPosition(cameraPosition),
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

    final Set<Marker> markers = visibleListings
        .map(
          (Listing listing) => Marker(
            markerId: MarkerId(listing.id),
            position: LatLng(listing.latitude, listing.longitude),
            infoWindow: InfoWindow(title: listing.name),
            onTap: () {
              setState(() {
                _selectedListingId = listing.id;
              });
              _focusCameraOnListing(listing);
            },
          ),
        )
        .toSet();

    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: TextField(
            controller: _searchController,
            onChanged: listingProvider.setSearchQuery,
            decoration: InputDecoration(
              hintText: 'Search by name, category, or address',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: listingProvider.searchQuery.isEmpty
                  ? null
                  : IconButton(
                      tooltip: 'Clear search',
                      onPressed: () {
                        listingProvider.setSearchQuery('');
                      },
                      icon: const Icon(Icons.close),
                    ),
            ),
          ),
        ),
        Expanded(
          child: GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _kigaliCenter,
              zoom: 12,
            ),
            markers: markers,
            onMapCreated: (GoogleMapController controller) {
              _mapController = controller;
              _focusCameraOnListing(active);
            },
          ),
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          color: Colors.white,
          child: active == null
              ? const Text(
                  'No matching places found in Home listings. Try another search.',
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      active.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      active.address,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    FilledButton.tonal(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) =>
                                ListingDetailScreen(listing: active),
                          ),
                        );
                      },
                      child: const Text('Open Details'),
                    ),
                  ],
                ),
        ),
      ],
    );
  }
}
