import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:kigali_city_service_places/core/theme/app_theme.dart';
import 'package:kigali_city_service_places/repositories/auth_repository.dart';
import 'package:kigali_city_service_places/repositories/listing_repository.dart';
import 'package:kigali_city_service_places/screens/auth/auth_gate.dart';
import 'package:kigali_city_service_places/services/mock/mock_auth_service.dart';
import 'package:kigali_city_service_places/services/mock/mock_listing_service.dart';
import 'package:kigali_city_service_places/state/auth_provider.dart';
import 'package:kigali_city_service_places/state/listing_provider.dart';
import 'package:kigali_city_service_places/state/review_provider.dart';

class KigaliDirectoryApp extends StatefulWidget {
  const KigaliDirectoryApp({super.key});

  @override
  State<KigaliDirectoryApp> createState() => _KigaliDirectoryAppState();
}

class _KigaliDirectoryAppState extends State<KigaliDirectoryApp> {
  late final AuthRepository _authRepository;
  late final ListingRepository _listingRepository;

  @override
  void initState() {
    super.initState();
    _authRepository = AuthRepository(authService: MockAuthService());
    _listingRepository = ListingRepository(
      listingService: MockListingService(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(
          create: (_) => AuthProvider(authRepository: _authRepository),
        ),
        ChangeNotifierProxyProvider<AuthProvider, ListingProvider>(
          create: (_) => ListingProvider(listingRepository: _listingRepository),
          update: (_, AuthProvider auth, ListingProvider? listingProvider) {
            final ListingProvider provider =
                listingProvider ??
                ListingProvider(listingRepository: _listingRepository);
            provider.bindUser(auth.currentUser?.uid);
            return provider;
          },
        ),
        ChangeNotifierProxyProvider<AuthProvider, ReviewProvider>(
          create: (_) => ReviewProvider(),
          update: (_, AuthProvider auth, ReviewProvider? reviewProvider) {
            final ReviewProvider provider = reviewProvider ?? ReviewProvider();
            provider.bindUser(
              uid: auth.currentUser?.uid,
              displayName: auth.currentUser?.displayName,
            );
            return provider;
          },
        ),
      ],
      child: MaterialApp(
        title: 'Kigali City Directory',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light(),
        home: const AuthGate(),
      ),
    );
  }
}
