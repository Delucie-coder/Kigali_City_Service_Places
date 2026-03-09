import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:kigali_city_service_places/state/auth_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthProvider authProvider = context.watch<AuthProvider>();
    final user = authProvider.currentUser;

    if (user == null) {
      return const Center(child: Text('No authenticated user found.'));
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                user.displayName,
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 6),
              Text(user.email),
              const SizedBox(height: 6),
              Text(
                'UID: ${user.uid}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SwitchListTile.adaptive(
          contentPadding: const EdgeInsets.symmetric(horizontal: 8),
          title: const Text('Location-based notifications'),
          subtitle: const Text(
            'Simulated locally until Firebase Cloud Messaging setup',
          ),
          value: user.notificationsEnabled,
          onChanged: (bool value) {
            context.read<AuthProvider>().setNotificationPreference(value);
          },
        ),
        const SizedBox(height: 8),
        FilledButton.tonalIcon(
          onPressed: authProvider.isLoading
              ? null
              : () => context.read<AuthProvider>().signOut(),
          icon: const Icon(Icons.logout),
          label: const Text('Logout'),
        ),
      ],
    );
  }
}
