import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:kigali_city_service_places/app.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    // If running on web without filling the options, this will fail.
    // If running on Android without google-services.json, this might fail or build might fail.
    debugPrint('Firebase initialization error: $e');
  }
  runApp(const KigaliDirectoryApp());
}
