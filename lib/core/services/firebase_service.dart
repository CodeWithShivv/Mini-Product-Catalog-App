import 'dart:developer';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:mini_product_catalog_app/core/services/dependency_locator.dart';
import 'package:mini_product_catalog_app/features/products_listing/domain/entities/product.dart';
import 'package:mini_product_catalog_app/firebase_options.dart';
import 'dart:convert';

class FirebaseService {
  FirebaseService();

  final Logger _logger = getIt<Logger>();
  DocumentSnapshot? _lastDocument; // Track last document for pagination
  static const int pageSize = 10;
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

  /// **Fetch paginated products from Firestore**
  Future<List<Product>> fetchProducts({bool isFirstFetch = false}) async {
    try {
      Query query =
          _firestore.collection('products').orderBy('id').limit(pageSize);

      if (!isFirstFetch && _lastDocument != null) {
        query = query.startAfterDocument(_lastDocument!);
      }

      QuerySnapshot snapshot = await query.get();

      if (snapshot.docs.isNotEmpty) {
        _lastDocument = snapshot.docs.last;
      }

      return snapshot.docs.map((doc) {
        return Product.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      log("Error fetching products: $e");
      return [];
    }
  }

  /// **Reset pagination**
  void resetPagination() {
    _lastDocument = null;
  }

  /// **Search products in Firestore**
  Future<List<Product>> searchProducts(String query) async {
    try {
      String lowerQuery = query.toLowerCase().trim();

      QuerySnapshot snapshot = await _firestore.collection('products').get();
      List<Product> filteredProducts = snapshot.docs
          .map((doc) => Product.fromJson(doc.data() as Map<String, dynamic>))
          .where((product) =>
              product.title.toLowerCase().contains(lowerQuery) ||
              product.description.toLowerCase().contains(lowerQuery))
          .toList();

      _logger.i("Search results: ${filteredProducts.length} products found.");
      return filteredProducts;
    } catch (e) {
      _logger.e("Error searching products: $e");
      return [];
    }
  }

  /// **Upload products from JSON file to Firestore**
  Future<void> uploadProductsFromAssets() async {
    try {
      String jsonString =
          await rootBundle.loadString('assets/data/products.json');
      List<dynamic> jsonData = json.decode(jsonString);
      List<Product> localProducts =
          jsonData.map((item) => Product.fromJson(item)).toList();

      List<Product> remoteProducts = await fetchProducts(isFirstFetch: true);
      Set<int> existingProductIds = remoteProducts.map((p) => p.id).toSet();

      List<Product> newProducts = localProducts
          .where((product) => !existingProductIds.contains(product.id))
          .toList();

      if (newProducts.isNotEmpty) {
        await uploadProducts(newProducts);
        _logger.i("Uploaded ${newProducts.length} new products to Firebase.");
      } else {
        _logger.i("No new products to upload.");
      }
    } catch (e) {
      _logger.e("Error uploading products from assets: $e");
    }
  }

  /// **Upload products to Firestore**
  Future<void> uploadProducts(List<Product> products) async {
    final collection = _firestore.collection('products');
    for (var product in products) {
      await collection
          .doc(product.id.toString())
          .set(product.toJson()..['rating'] = product.rating.toJson());
    }
  }
}
