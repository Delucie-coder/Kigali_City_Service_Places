import 'dart:async';

import 'package:kigali_city_service_places/models/listing.dart';
import 'package:kigali_city_service_places/services/interfaces/listing_service.dart';
import 'package:uuid/uuid.dart';

class MockListingService implements ListingService {
  MockListingService() {
    _seedDemoData();
    _push();
  }

  final Uuid _uuid = const Uuid();
  final StreamController<List<Listing>> _listingController =
      StreamController<List<Listing>>.broadcast();

  final List<Listing> _listings = <Listing>[];

  @override
  Stream<List<Listing>> watchListings() async* {
    yield List<Listing>.of(_listings);
    yield* _listingController.stream;
  }

  @override
  Future<void> createListing(Listing listing) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    _listings.add(
      listing.copyWith(id: listing.id.isEmpty ? _uuid.v4() : listing.id),
    );
    _push();
  }

  @override
  Future<void> updateListing(
    Listing listing, {
    required String requesterUid,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    final int index = _listings.indexWhere(
      (Listing item) => item.id == listing.id,
    );
    if (index < 0) {
      throw Exception('Listing not found.');
    }

    if (_listings[index].createdBy != requesterUid) {
      throw Exception('You can only edit your own listing.');
    }

    _listings[index] = listing;
    _push();
  }

  @override
  Future<void> deleteListing(
    String listingId, {
    required String requesterUid,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 220));
    final int index = _listings.indexWhere(
      (Listing item) => item.id == listingId,
    );
    if (index < 0) {
      throw Exception('Listing not found.');
    }

    if (_listings[index].createdBy != requesterUid) {
      throw Exception('You can only delete your own listing.');
    }

    _listings.removeAt(index);
    _push();
  }

  void _push() {
    final List<Listing> sorted = List<Listing>.of(_listings)
      ..sort((Listing a, Listing b) => b.timestamp.compareTo(a.timestamp));
    _listingController.add(sorted);
  }

  void _seedDemoData() {
    final DateTime now = DateTime.now();
    _listings.addAll(<Listing>[
      Listing(
        id: _uuid.v4(),
        name: 'Question Coffee Gishushu',
        category: 'Cafe',
        address: 'KG 8 Ave, Kigali',
        contactNumber: '+250 788 000 003',
        description:
            'A specialty coffee shop serving roasted Rwandan coffee in a vibrant garden setting.',
        latitude: -1.9495,
        longitude: 30.1017,
        createdBy: 'system',
        timestamp: now.subtract(const Duration(hours: 1)),
        rating: 4.8,
        imageUrl:
            'https://images.unsplash.com/photo-1554118811-1e0d58224f24?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80',
      ),
      Listing(
        id: _uuid.v4(),
        name: 'King Faisal Hospital',
        category: 'Hospital',
        address: 'KG 544 St, Kigali',
        contactNumber: '+250 788 384 000',
        description:
            'Major referral hospital providing comprehensive medical services and emergency care.',
        latitude: -1.9439,
        longitude: 30.0925,
        createdBy: 'system',
        timestamp: now.subtract(const Duration(hours: 4)),
        rating: 4.2,
        imageUrl:
            'https://images.unsplash.com/photo-1586773860418-d37222d8fce3?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80',
      ),
      Listing(
        id: _uuid.v4(),
        name: 'Kimironko Market',
        category: 'Market',
        address: 'KG 194 St, Kigali',
        contactNumber: '+250 788 000 000',
        description:
            'Bustling covered market with stalls for fresh produce, clothing, fabric, and crafts.',
        latitude: -1.9488,
        longitude: 30.1264,
        createdBy: 'system',
        timestamp: now.subtract(const Duration(minutes: 90)),
        rating: 4.5,
        imageUrl:
            'https://images.unsplash.com/photo-1533900298318-6b8da08a523e?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80',
      ),
      Listing(
        id: _uuid.v4(),
        name: 'Kigali Genocide Memorial',
        category: 'Tourist Attraction',
        address: 'KG 14 Ave, Gisozi, Kigali',
        contactNumber: '+250 788 000 005',
        description:
            'Historical memorial site and museum offering guided visits and exhibitions.',
        latitude: -1.9300,
        longitude: 30.0588,
        createdBy: 'system',
        timestamp: now.subtract(const Duration(minutes: 45)),
        rating: 4.9,
        imageUrl:
            'https://images.unsplash.com/photo-1596386461350-326e9748e426?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80',
      ),
      Listing(
        id: _uuid.v4(),
        name: 'Heaven Restaurant',
        category: 'Restaurant',
        address: 'KN 29 St, Kigali',
        contactNumber: '+250 788 486 581',
        description:
            'Upscale dining with Rwandan and international dishes, plus city views and art.',
        latitude: -1.9560,
        longitude: 30.0630,
        createdBy: 'system',
        timestamp: now.subtract(const Duration(days: 1)),
        rating: 4.6,
        imageUrl:
            'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80',
      ),
      Listing(
        id: _uuid.v4(),
        name: 'Kipharma Pharmacy',
        category: 'Pharmacy',
        address: 'KN 82 St, Kigali',
        contactNumber: '+250 788 303 000',
        description:
            'Well-stocked pharmacy offering medicines and personal care products.',
        latitude: -1.9440,
        longitude: 30.0600,
        createdBy: 'system',
        timestamp: now.subtract(const Duration(minutes: 20)),
        rating: 4.0,
        imageUrl:
            'https://images.unsplash.com/photo-1587854692152-cbe660dbde88?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80',
      ),
      Listing(
        id: _uuid.v4(),
        name: 'Imbuga City Walk',
        category: 'Park',
        address: 'KN 4 Ave, Kigali',
        contactNumber: 'N/A',
        description:
            'Pedestrian-friendly car-free zone in the city center with seating and green spaces.',
        latitude: -1.9441,
        longitude: 30.0619,
        createdBy: 'system',
        timestamp: now.subtract(const Duration(days: 2)),
        rating: 4.7,
        imageUrl:
            'https://images.unsplash.com/photo-1478131143081-80f7f84ca84d?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80',
      ),
    ]);
  }
}
