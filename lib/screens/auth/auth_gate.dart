import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:kigali_city_service_places/screens/auth/login_screen.dart';
import 'package:kigali_city_service_places/screens/auth/verify_email_screen.dart';
import 'package:kigali_city_service_places/screens/home_shell.dart';
import 'package:kigali_city_service_places/state/auth_provider.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthProvider authProvider = context.watch<AuthProvider>();
    final user = authProvider.currentUser;

    if (authProvider.isLoading && user == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (user == null) {
      return const LoginScreen();
    }

    if (!user.emailVerified) {
      return const VerifyEmailScreen();
    }

    return const HomeShell();
  }
}
