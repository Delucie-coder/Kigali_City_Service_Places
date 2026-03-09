import 'package:kigali_city_service_places/models/app_user.dart';

abstract class AuthService {
  Stream<AppUser?> authStateChanges();

  Future<AppUser> signUp({
    required String email,
    required String password,
    required String displayName,
  });

  Future<AppUser> signIn({required String email, required String password});

  Future<void> signOut();
  Future<void> sendVerificationEmail();
  Future<void> markEmailVerified();
  Future<AppUser?> reloadCurrentUser();
  Future<void> updateNotificationPreference(bool enabled);
}
