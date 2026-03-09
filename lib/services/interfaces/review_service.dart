import 'package:kigali_city_service_places/models/review.dart';

abstract class ReviewService {
  Stream<List<Review>> watchReviews();
  Future<void> submitReview(Review review);
  Future<void> deleteReview(String reviewId, {required String requesterUid});
}
