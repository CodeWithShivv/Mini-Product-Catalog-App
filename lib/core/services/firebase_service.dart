import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:mini_product_catalog_app/core/services/dependency_locator.dart';
import 'package:mini_product_catalog_app/features/products_listing/domain/entities/product.dart';
import 'package:mini_product_catalog_app/firebase_options.dart';
import 'package:logger/logger.dart';
import 'dart:convert';

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

  /// Upload products from `assets/products.json` to Firestore (if not already uploaded)
  Future<void> uploadProductsFromAssets() async {
    try {
      // Load JSON from assets
      String jsonString =
          await rootBundle.loadString('assets/data/products.json');
      ;
      List<dynamic> jsonData = json.decode(jsonString);

      // Convert JSON data to Product objects
      List<Product> localProducts =
          jsonData.map((item) => Product.fromJson(item)).toList();

      // Fetch existing products from Firebase
      List<Product> remoteProducts = await fetchProducts();
      Set<int> existingProductIds = remoteProducts.map((p) => p.id).toSet();

      // Filter only new products (not present in Firebase)
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

  Future<void> uploadProducts(List<Product> products) async {
    final collection = FirebaseFirestore.instance.collection('products');
    for (var product in products) {
      await collection
          .doc(product.id.toString())
          .set(product.toJson()..['rating'] = product.rating.toJson());
    }
  }
}
