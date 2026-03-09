import 'package:kigali_city_service_places/models/review.dart';
import 'package:kigali_city_service_places/services/interfaces/review_service.dart';

class ReviewRepository {
  ReviewRepository({required ReviewService reviewService})
    : _reviewService = reviewService;

  final ReviewService _reviewService;

  Stream<List<Review>> watchReviews() => _reviewService.watchReviews();

  Future<void> submitReview(Review review) =>
      _reviewService.submitReview(review);

  Future<void> deleteReview(String reviewId, {required String requesterUid}) {
    return _reviewService.deleteReview(reviewId, requesterUid: requesterUid);
  }
}
