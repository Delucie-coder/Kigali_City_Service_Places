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

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'] as String,
      listingId: json['listingId'] as String,
      listingName: json['listingName'] as String,
      rating: json['rating'] as int,
      comment: json['comment'] as String,
      createdBy: json['createdBy'] as String,
      createdByName: json['createdByName'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'listingId': listingId,
      'listingName': listingName,
      'rating': rating,
      'comment': comment,
      'createdBy': createdBy,
      'createdByName': createdByName,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  final String id;
  final String listingId;
  final String listingName;
  final int rating;
  final String comment;
  final String createdBy;
  final String createdByName;
  final DateTime timestamp;
}
