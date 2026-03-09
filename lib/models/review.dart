class Review {
  const Review({
    required this.id,
    required this.listingId,
    required this.listingName,
    required this.rating,
    required this.comment,
    required this.createdBy,
    required this.createdByName,
    required this.timestamp,
  });

  final String id;
  final String listingId;
  final String listingName;
  final int rating;
  final String comment;
  final String createdBy;
  final String createdByName;
  final DateTime timestamp;
}
