import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:kigali_city_service_places/state/auth_provider.dart';

class VerifyEmailScreen extends StatelessWidget {
  const VerifyEmailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthProvider authProvider = context.watch<AuthProvider>();
    final user = authProvider.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify Email'),
        actions: <Widget>[
          TextButton(
            onPressed: authProvider.isLoading
                ? null
                : () => context.read<AuthProvider>().signOut(),
            child: const Text('Logout', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Welcome ${user?.displayName ?? ''}',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 12),
            Text(
              'A verification email has been sent to ${user?.email ?? ''}. '
              'Please verify your email before entering the app.',
            ),
            const SizedBox(height: 24),
            if (authProvider.errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(
                  authProvider.errorMessage!,
                  style: const TextStyle(color: Colors.redAccent),
                ),
              ),
            FilledButton.icon(
              onPressed: authProvider.isLoading
                  ? null
                  : () => context.read<AuthProvider>().sendVerificationEmail(),
              icon: const Icon(Icons.email_outlined),
              label: const Text('Resend Verification Email'),
            ),
            const SizedBox(height: 10),
            FilledButton.tonalIcon(
              onPressed: authProvider.isLoading
                  ? null
                  : () async {
                      await context.read<AuthProvider>().markEmailVerified();
                      if (!context.mounted) {
                        return;
                      }
                      await context.read<AuthProvider>().reloadCurrentUser();
                    },
              icon: const Icon(Icons.verified_user_outlined),
              label: const Text('I Verified My Email'),
            ),
            const SizedBox(height: 10),
            Text(
              'Note: This is currently a local simulation. Once you approve, '
              'we will connect this screen to Firebase email verification.',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: Colors.grey.shade700),
            ),
          ],
        ),
      ),
    );
  }
}
