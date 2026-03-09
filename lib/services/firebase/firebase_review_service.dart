import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kigali_city_service_places/models/review.dart';
import 'package:kigali_city_service_places/services/interfaces/review_service.dart';

class FirebaseReviewService implements ReviewService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Stream<List<Review>> watchReviews() {
    return _firestore
        .collection('reviews')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((QuerySnapshot<Map<String, dynamic>> snapshot) {
          return snapshot.docs.map((
            QueryDocumentSnapshot<Map<String, dynamic>> doc,
          ) {
            final Map<String, dynamic> data = doc.data();
            data['id'] = doc.id;
            return Review.fromJson(data);
          }).toList();
        });
  }

  @override
  Future<void> submitReview(Review review) async {
    await _firestore
        .collection('reviews')
        .doc(review.id)
        .set(review.toJson()..['timestamp'] = FieldValue.serverTimestamp());
  }

  @override
  Future<void> deleteReview(
    String reviewId, {
    required String requesterUid,
  }) async {
    await _firestore.collection('reviews').doc(reviewId).delete();
  }
}
