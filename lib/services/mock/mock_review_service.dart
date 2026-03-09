import 'dart:async';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:kigali_city_service_places/models/review.dart';
import 'package:kigali_city_service_places/services/interfaces/review_service.dart';
import 'package:uuid/uuid.dart';

class MockReviewService implements ReviewService {
  MockReviewService() {
    _init();
  }

  final Uuid _uuid = const Uuid();
  final StreamController<List<Review>> _reviewController =
      StreamController<List<Review>>.broadcast();

  final List<Review> _reviews = <Review>[];
  static const String _storageKey = 'kigali_reviews_data';

  Future<void> _init() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? data = prefs.getString(_storageKey);

    if (data != null && data.isNotEmpty) {
      try {
        final List<dynamic> decoded = jsonDecode(data);
        final List<Review> loaded = decoded
            .map((e) => Review.fromJson(e as Map<String, dynamic>))
            .toList();
        _reviews.addAll(loaded);
      } catch (e) {
        // Fallback if data is corrupted
        await _save();
      }
    } else {
      await _save();
    }
    _push();
  }

  Future<void> _save() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String encoded = jsonEncode(_reviews.map((e) => e.toJson()).toList());
    await prefs.setString(_storageKey, encoded);
  }

  void _push() {
    _reviewController.add(List<Review>.unmodifiable(_reviews));
  }

  @override
  Stream<List<Review>> watchReviews() async* {
    yield List<Review>.of(_reviews);
    yield* _reviewController.stream;
  }

  @override
  Future<void> submitReview(Review review) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    _reviews.insert(
      0,
      Review(
        id: review.id.isNotEmpty ? review.id : _uuid.v4(),
        listingId: review.listingId,
        listingName: review.listingName,
        rating: review.rating,
        comment: review.comment,
        createdBy: review.createdBy,
        createdByName: review.createdByName,
        timestamp: review.timestamp,
      ),
    );
    await _save();
    _push();
  }

  @override
  Future<void> deleteReview(
    String reviewId, {
    required String requesterUid,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    final int index = _reviews.indexWhere((Review item) => item.id == reviewId);
    if (index < 0) {
      throw Exception('Review not found.');
    }

    if (_reviews[index].createdBy != requesterUid) {
      throw Exception('You can only delete your own review.');
    }

    _reviews.removeAt(index);
    await _save();
    _push();
  }
}
