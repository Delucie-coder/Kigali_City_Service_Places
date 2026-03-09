import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

import 'package:kigali_city_service_places/models/review.dart';
import 'package:kigali_city_service_places/repositories/review_repository.dart';

class ReviewProvider extends ChangeNotifier {
  ReviewProvider({required ReviewRepository reviewRepository})
    : _reviewRepository = reviewRepository {
    _subscription = _reviewRepository.watchReviews().listen((
      List<Review> data,
    ) {
      _reviews
        ..clear()
        ..addAll(data);
      notifyListeners();
    });
  }

  final ReviewRepository _reviewRepository;
  StreamSubscription<List<Review>>? _subscription;

  final Uuid _uuid = const Uuid();

  final List<Review> _reviews = <Review>[];

  String? _currentUserId;
  String? _currentUserName;
  bool _isSubmitting = false;
  String? _errorMessage;

  List<Review> get reviews => List<Review>.unmodifiable(_reviews);
  bool get isSubmitting => _isSubmitting;
  String? get errorMessage => _errorMessage;

  void bindUser({String? uid, String? displayName}) {
    _currentUserId = uid;
    _currentUserName = displayName;
    notifyListeners();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  Future<void> submitReview({
    required String listingId,
    required String listingName,
    required int rating,
    required String comment,
  }) async {
    if (_currentUserId == null || _currentUserName == null) {
      _setError('Please login first.');
      return;
    }

    if (rating < 1 || rating > 5) {
      _setError('Rating must be between 1 and 5.');
      return;
    }

    if (comment.trim().length < 5) {
      _setError('Comment must be at least 5 characters.');
      return;
    }

    // Check if user already reviewed this listing (optional, but good)
    final bool alreadyReviewed = _reviews.any(
      (Review r) => r.listingId == listingId && r.createdBy == _currentUserId,
    );
    if (alreadyReviewed) {
      _setError('You have already reviewed this listing.');
      return;
    }

    _isSubmitting = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final Review review = Review(
        id: _uuid.v4(),
        listingId: listingId,
        listingName: listingName,
        rating: rating,
        comment: comment.trim(),
        createdBy: _currentUserId!,
        createdByName: _currentUserName!,
        timestamp: DateTime.now(),
      );

      await _reviewRepository.submitReview(review);

      _isSubmitting = false;
      notifyListeners();
    } catch (e) {
      _isSubmitting = false;
      _setError('Failed to submit review: $e');
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void _setError(String value) {
    _errorMessage = value;
    notifyListeners();
  }
}
