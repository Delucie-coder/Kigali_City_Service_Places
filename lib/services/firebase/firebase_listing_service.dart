import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kigali_city_service_places/models/listing.dart';
import 'package:kigali_city_service_places/services/interfaces/listing_service.dart';

class FirebaseListingService implements ListingService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Stream<List<Listing>> watchListings() {
    return _firestore
        .collection('listings')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((QuerySnapshot<Map<String, dynamic>> snapshot) {
          return snapshot.docs.map((
            QueryDocumentSnapshot<Map<String, dynamic>> doc,
          ) {
            final Map<String, dynamic> data = doc.data();
            data['id'] = doc.id;
            return Listing.fromJson(data);
          }).toList();
        });
  }

  @override
  Future<void> createListing(Listing listing) async {
    // Improve: Use batch or transaction if needed.
    // Using set with merge is safer if ID exists.
    await _firestore
        .collection('listings')
        .doc(listing.id)
        .set(listing.toJson()..['timestamp'] = FieldValue.serverTimestamp());
  }

  @override
  Future<void> updateListing(
    Listing listing, {
    required String requesterUid,
  }) async {
    // Security rules should enforce the requesterUid check
    await _firestore
        .collection('listings')
        .doc(listing.id)
        .update(listing.toJson());
  }

  @override
  Future<void> deleteListing(
    String listingId, {
    required String requesterUid,
  }) async {
    await _firestore.collection('listings').doc(listingId).delete();
  }
}
