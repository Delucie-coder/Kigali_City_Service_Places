import 'package:kigali_city_service_places/models/listing.dart';

abstract class ListingService {
  Stream<List<Listing>> watchListings();

  Future<void> createListing(Listing listing);

  Future<void> updateListing(Listing listing, {required String requesterUid});

  Future<void> deleteListing(String listingId, {required String requesterUid});
}
