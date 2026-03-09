import 'package:cloud_firestore/cloud_firestore.dart';

class Listing {
  const Listing({
    required this.id,
    required this.name,
    required this.category,
    required this.address,
    required this.contactNumber,
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.createdBy,
    required this.timestamp,
    this.rating = 0.0,
    this.imageUrl,
  });

  final String id;
  final String name;
  final String category;
  final String address;
  final String contactNumber;
  final String description;
  final double latitude;
  final double longitude;
  final String createdBy;
  final DateTime timestamp;
  final double rating;
  final String? imageUrl;

  Listing copyWith({
    String? id,
    String? name,
    String? category,
    String? address,
    String? contactNumber,
    String? description,
    double? latitude,
    double? longitude,
    String? createdBy,
    DateTime? timestamp,
    double? rating,
    String? imageUrl,
  }) {
    return Listing(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      address: address ?? this.address,
      contactNumber: contactNumber ?? this.contactNumber,
      description: description ?? this.description,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      createdBy: createdBy ?? this.createdBy,
      timestamp: timestamp ?? this.timestamp,
      rating: rating ?? this.rating,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'address': address,
      'contactNumber': contactNumber,
      'description': description,
      'latitude': latitude,
      'longitude': longitude,
      'createdBy': createdBy,
      'timestamp': timestamp.toIso8601String(),
      'rating': rating,
      'imageUrl': imageUrl,
    };
  }

  factory Listing.fromJson(Map<String, dynamic> json) {
    DateTime timestamp;
    if (json['timestamp'] is String) {
      timestamp = DateTime.parse(json['timestamp'] as String);
    } else if (json['timestamp'] is Timestamp) {
      // Handle Firestore Timestamp
      timestamp = (json['timestamp'] as Timestamp).toDate();
    } else {
      timestamp = DateTime.now(); // Fallback
    }

    return Listing(
      id: json['id'] as String,
      name: json['name'] as String,
      category: json['category'] as String,
      address: json['address'] as String,
      contactNumber: json['contactNumber'] as String,
      description: json['description'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      createdBy: json['createdBy'] as String,
      timestamp: timestamp,
      rating: (json['rating'] as num).toDouble(),
      imageUrl: json['imageUrl'] as String?,
    );
  }
}
