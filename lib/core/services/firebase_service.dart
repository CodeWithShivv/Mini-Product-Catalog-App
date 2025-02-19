import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import 'package:mini_product_catalog_app/core/services/dependency_locator.dart';
import 'package:mini_product_catalog_app/features/products/domain/entities/product.dart';
import 'package:mini_product_catalog_app/firebase_options.dart';

class FirebaseService {
  FirebaseService();

  final Logger _logger = getIt<Logger>();
  late final FirebaseFirestore _firestore;

  Future<void> initialize() async {
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      _firestore = FirebaseFirestore.instance;

      _logger.i("Firebase initialized successfully.");
    } catch (e) {
      _logger.e("Error initializing Firebase: $e");
      rethrow;
    }
  }

  FirebaseFirestore get firestore => _firestore;

  Future<List<Product>> fetchProducts() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('products').get();
      List<Product> products = snapshot.docs.map((doc) {
        return Product.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();

      _logger.i("Fetched ${products.length} products.");
      return products;
    } catch (e) {
      _logger.e("Error fetching products: $e");
      return [];
    }
  }
}
