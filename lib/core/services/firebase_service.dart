import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:logger/logger.dart';
import 'package:mini_product_catalog_app/core/services/dependency_locator.dart';
import 'package:mini_product_catalog_app/firebase_options.dart';

class FirebaseService {
  FirebaseService();

  final Logger _logger = getIt<Logger>();
  late final FirebaseFirestore _firestore;
  late final FirebaseRemoteConfig _remoteConfig;

  Future<void> initialize() async {
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      _firestore = FirebaseFirestore.instance;
      _remoteConfig = FirebaseRemoteConfig.instance;

      // Set default values for remote config
      await _remoteConfig.setDefaults(<String, dynamic>{
        'productsUpdated': true,
      });

      // Fetch latest values
      await _remoteConfig.fetchAndActivate();

      _logger.i("Firebase initialized successfully.");
    } catch (e) {
      _logger.e("Error initializing Firebase: $e");
      rethrow;
    }
  }

  FirebaseFirestore get firestore => _firestore;

  /// Fetches the `productsUpdated` feature flag from Firebase Remote Config
  Future<bool> isProductsUpdateAvailable() async {
    try {
      bool flag = _remoteConfig.getBool('productsUpdated');
      _logger.i("Feature flag 'productsUpdated' fetched: $flag");
      return flag;
    } catch (e) {
      _logger.e("Error fetching productsUpdated flag: $e");
      return false;
    }
  }
}
