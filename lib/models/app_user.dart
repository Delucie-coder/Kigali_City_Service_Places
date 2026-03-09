import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  const AppUser({
    required this.uid,
    required this.email,
    required this.displayName,
    required this.emailVerified,
    required this.notificationsEnabled,
    required this.createdAt,
  });

  final String uid;
  final String email;
  final String displayName;
  final bool emailVerified;
  final bool notificationsEnabled;
  final DateTime createdAt;

  AppUser copyWith({
    String? uid,
    String? email,
    String? displayName,
    bool? emailVerified,
    bool? notificationsEnabled,
    DateTime? createdAt,
  }) {
    return AppUser(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      emailVerified: emailVerified ?? this.emailVerified,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'emailVerified': emailVerified,
      'notificationsEnabled': notificationsEnabled,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory AppUser.fromJson(Map<String, dynamic> json) {
    DateTime createdAt;
    if (json['createdAt'] is String) {
      createdAt = DateTime.parse(json['createdAt'] as String);
    } else if (json['createdAt'] is Timestamp) {
      createdAt = (json['createdAt'] as Timestamp).toDate();
    } else {
      createdAt = DateTime.now();
    }

    return AppUser(
      uid: json['uid'] as String,
      email: json['email'] as String,
      displayName: json['displayName'] as String,
      emailVerified: json['emailVerified'] as bool,
      notificationsEnabled: json['notificationsEnabled'] as bool,
      createdAt: createdAt,
    );
  }
}
