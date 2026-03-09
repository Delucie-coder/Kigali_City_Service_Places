import 'package:kigali_city_service_places/models/app_user.dart';
import 'package:kigali_city_service_places/services/interfaces/auth_service.dart';

class AuthRepository {
  AuthRepository({required AuthService authService})
    : _authService = authService;

  final AuthService _authService;

  Stream<AppUser?> authStateChanges() => _authService.authStateChanges();

  Future<AppUser> signUp({
    required String email,
    required String password,
    required String displayName,
  }) {
    return _authService.signUp(
      email: email,
      password: password,
      displayName: displayName,
    );
  }

  Future<AppUser> signIn({required String email, required String password}) {
    return _authService.signIn(email: email, password: password);
  }

  Future<void> signOut() => _authService.signOut();

  Future<void> sendVerificationEmail() => _authService.sendVerificationEmail();

  Future<void> markEmailVerified() => _authService.markEmailVerified();

  Future<AppUser?> reloadCurrentUser() => _authService.reloadCurrentUser();

  Future<void> updateNotificationPreference(bool enabled) {
    return _authService.updateNotificationPreference(enabled);
  }
}
