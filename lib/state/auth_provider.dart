import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:kigali_city_service_places/models/app_user.dart';
import 'package:kigali_city_service_places/repositories/auth_repository.dart';

class AuthProvider extends ChangeNotifier {
  AuthProvider({required AuthRepository authRepository})
    : _authRepository = authRepository {
    _subscription = _authRepository.authStateChanges().listen((AppUser? user) {
      _currentUser = user;
      notifyListeners();
    });
  }

  final AuthRepository _authRepository;
  StreamSubscription<AppUser?>? _subscription;

  AppUser? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  AppUser? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> signUp({
    required String email,
    required String password,
    required String displayName,
  }) async {
    await _guardAny(() {
      return _authRepository.signUp(
        email: email,
        password: password,
        displayName: displayName,
      );
    });
  }

  Future<void> signIn({required String email, required String password}) async {
    await _guardAny(
      () => _authRepository.signIn(email: email, password: password),
    );
  }

  Future<void> signOut() async {
    await _guardVoid(_authRepository.signOut);
  }

  Future<void> sendVerificationEmail() async {
    await _guardVoid(_authRepository.sendVerificationEmail);
  }

  Future<void> markEmailVerified() async {
    await _guardVoid(_authRepository.markEmailVerified);
  }

  Future<void> reloadCurrentUser() async {
    await _guardAny(_authRepository.reloadCurrentUser);
  }

  Future<void> setNotificationPreference(bool enabled) async {
    await _guardVoid(
      () => _authRepository.updateNotificationPreference(enabled),
    );
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  Future<void> _guardVoid(Future<void> Function() action) async {
    _setLoading(true);
    _errorMessage = null;
    try {
      await action();
    } catch (error) {
      _errorMessage = error.toString().replaceFirst('Exception: ', '');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> _guardAny<T>(Future<T> Function() action) async {
    _setLoading(true);
    _errorMessage = null;
    try {
      await action();
    } catch (error) {
      _errorMessage = error.toString().replaceFirst('Exception: ', '');
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
