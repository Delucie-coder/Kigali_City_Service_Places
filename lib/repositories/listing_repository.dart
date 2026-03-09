import 'package:kigali_city_service_places/models/listing.dart';
import 'package:kigali_city_service_places/services/interfaces/listing_service.dart';

class ListingRepository {
  ListingRepository({required ListingService listingService})
    : _listingService = listingService;

  final ListingService _listingService;

  Stream<List<Listing>> watchListings() => _listingService.watchListings();

  Future<void> createListing(Listing listing) =>
      _listingService.createListing(listing);

  Future<void> updateListing(Listing listing, {required String requesterUid}) {
    return _listingService.updateListing(listing, requesterUid: requesterUid);
  }

  Future<void> deleteListing(String listingId, {required String requesterUid}) {
    return _listingService.deleteListing(listingId, requesterUid: requesterUid);
  }
}
