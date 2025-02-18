import 'package:firebase_core/firebase_core.dart';
import 'package:logger/logger.dart';
import 'package:mini_product_catalog_app/core/services/dependency_locator.dart';
import 'package:mini_product_catalog_app/firebase_options.dart';

class FirebaseService {
  final Logger _logger = getIt<Logger>();

  Future<void> initialize() async {
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      _logger.i("Firebase initialized successfully.");
    } catch (e) {
      _logger.e("Error initializing Firebase: $e");
      rethrow;
    }
  }
}
