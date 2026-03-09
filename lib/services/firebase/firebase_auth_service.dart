import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kigali_city_service_places/models/app_user.dart';
import 'package:kigali_city_service_places/services/interfaces/auth_service.dart';

class FirebaseAuthService implements AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<AppUser?>? _userStream;

  @override
  Stream<AppUser?> authStateChanges() {
    _userStream ??= _firebaseAuth.authStateChanges().asyncMap((
      User? user,
    ) async {
      if (user == null) {
        return null;
      }

      // Try to fetch custom user data from Firestore
      final DocumentSnapshot<Map<String, dynamic>> snapshot = await _firestore
          .collection('users')
          .doc(user.uid)
          .get();

      if (snapshot.exists) {
        return _appUserFromSnapshot(snapshot);
      } else {
        // Fallback or create if missing? Usually create on sign-up.
        // For now return basic info
        return AppUser(
          uid: user.uid,
          email: user.email ?? '',
          displayName: user.displayName ?? '',
          emailVerified: user.emailVerified,
          notificationsEnabled: false, // Default
          createdAt: user.metadata.creationTime ?? DateTime.now(), // Estimate
        );
      }
    });
    return _userStream!;
  }

  AppUser _appUserFromSnapshot(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final Map<String, dynamic> data = snapshot.data()!;
    // Handle Timestamp or String for createdAt
    DateTime createdAt;
    if (data['createdAt'] is Timestamp) {
      createdAt = (data['createdAt'] as Timestamp).toDate();
    } else if (data['createdAt'] is String) {
      createdAt = DateTime.parse(data['createdAt'] as String);
    } else {
      createdAt = DateTime.now();
    }

    return AppUser(
      uid: snapshot.id,
      email: data['email'] as String? ?? '',
      displayName: data['displayName'] as String? ?? '',
      emailVerified: data['emailVerified'] as bool? ?? false,
      notificationsEnabled: data['notificationsEnabled'] as bool? ?? false,
      createdAt: createdAt,
    );
  }

  @override
  Future<AppUser> signUp({
    required String email,
    required String password,
    required String displayName,
  }) async {
    final UserCredential credential = await _firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password);
    final User user = credential.user!;

    await user.updateDisplayName(displayName);

    final AppUser newUser = AppUser(
      uid: user.uid,
      email: email,
      displayName: displayName,
      emailVerified: user.emailVerified,
      notificationsEnabled: false,
      createdAt: DateTime.now(),
    );

    // Save to Firestore
    await _firestore
        .collection('users')
        .doc(user.uid)
        .set(newUser.toJson()..['createdAt'] = FieldValue.serverTimestamp());

    return newUser;
  }

  @override
  Future<AppUser> signIn({
    required String email,
    required String password,
  }) async {
    final UserCredential credential = await _firebaseAuth
        .signInWithEmailAndPassword(email: email, password: password);
    final User user = credential.user!;

    // Fetch full profile
    final DocumentSnapshot<Map<String, dynamic>> snapshot = await _firestore
        .collection('users')
        .doc(user.uid)
        .get();

    if (snapshot.exists) {
      return _appUserFromSnapshot(snapshot);
    }

    return AppUser(
      uid: user.uid,
      email: user.email ?? '',
      displayName: user.displayName ?? '',
      emailVerified: user.emailVerified,
      notificationsEnabled: false,
      createdAt: user.metadata.creationTime ?? DateTime.now(),
    );
  }

  @override
  Future<void> signOut() {
    return _firebaseAuth.signOut();
  }

  @override
  Future<void> sendVerificationEmail() async {
    final User? user = _firebaseAuth.currentUser;
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
    }
  }

  @override
  Future<void> markEmailVerified() async {
    // This is usually done by clicking the link.
    // But we can reload the user to check status.
    final User? user = _firebaseAuth.currentUser;
    if (user != null) {
      await user.reload();
      // Update firestore if needed
      if (user.emailVerified) {
        await _firestore.collection('users').doc(user.uid).update({
          'emailVerified': true,
        });
      }
    }
  }

  @override
  Future<AppUser?> reloadCurrentUser() async {
    final User? user = _firebaseAuth.currentUser;
    if (user == null) return null;

    await user.reload();
    final DocumentSnapshot<Map<String, dynamic>> snapshot = await _firestore
        .collection('users')
        .doc(user.uid)
        .get();

    if (snapshot.exists) {
      return _appUserFromSnapshot(snapshot);
    }
    return null; // Should ideally return the basic user
  }

  @override
  Future<void> updateNotificationPreference(bool enabled) async {
    final User? user = _firebaseAuth.currentUser;
    if (user == null) return;

    await _firestore.collection('users').doc(user.uid).update({
      'notificationsEnabled': enabled,
    });
  }
}
