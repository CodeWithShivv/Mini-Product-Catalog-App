import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:mini_product_catalog_app/core/data/local/app_database.dart';
import 'package:mini_product_catalog_app/core/data/local/app_database_constants.dart';
import 'package:mini_product_catalog_app/core/services/connectivity_service.dart';
import 'package:mini_product_catalog_app/core/services/firebase_service.dart';
import 'package:mini_product_catalog_app/core/services/dependency_locator.dart';
import 'package:mini_product_catalog_app/features/products_listing/domain/entities/product.dart';
import 'package:logger/logger.dart';
import 'package:flutter/foundation.dart';

class ProductRepository {
  final FirebaseService _firebaseService = getIt<FirebaseService>();
  final AppDatabase _appDatabase = getIt<AppDatabase>();
  final Logger _logger = getIt<Logger>();
  List<Product>? remoteProducts; // Cached remote products

  /// Fetch products based on availability (online/offline)
  Future<List<Product>> fetchProducts() async {
    bool isOnline = await getIt<ConnectivityService>().isConnected();

    //Synchronization process between the remote and local databases.
    return isOnline ? await _fetchAndSyncProducts() : await getLocalProducts();
  }

  /// Fetch products from Firestore and sync with local storage
  Future<List<Product>> _fetchAndSyncProducts() async {
    try {
      if (remoteProducts?.isNotEmpty ?? false) {
        return remoteProducts!;
      }

      remoteProducts = await _firebaseService.fetchProducts();
      if (remoteProducts?.isEmpty ?? true) return [];

      var box =
          await _appDatabase.openBox<Product>(AppDataBaseConstants.productsBox);

      Map<int, Product> productMap =
          await _syncProductsWithIsolate(box.toMap(), remoteProducts!);

      if (productMap.isNotEmpty) {
        await box.putAll(productMap);
        _logger.i("Synchronized ${productMap.length} updated/new products.");
      }

      return remoteProducts!;
    } catch (e) {
      _logger.e("Error fetching products: $e");
      return [];
    }
  }

  /// Sync products using an isolate for performance
  Future<Map<int, Product>> _syncProductsWithIsolate(
      Map<dynamic, Product> existingProducts,
      List<Product> remoteProducts) async {
    return remoteProducts.length > 20
        ? await compute(_processProducts,
            {'boxData': existingProducts, 'remoteProducts': remoteProducts})
        : _processProducts(
            {'boxData': existingProducts, 'remoteProducts': remoteProducts});
  }

  /// Get locally stored products from Hive
  Future<List<Product>> getLocalProducts() async {
    return await _appDatabase.getAllData(AppDataBaseConstants.productsBox);
  }
}

/// Function that processes products (can run in an isolate)
Map<int, Product> _processProducts(Map<String, dynamic> data) {
  Map<dynamic, Product> existingProducts =
      data['boxData'] as Map<dynamic, Product>;

  List<Product> remoteProducts = data['remoteProducts'] as List<Product>;

  return {
    for (var product in remoteProducts)
      if (!existingProducts.containsKey(product.id) ||
          existingProducts[product.id] != product)
        product.id: product
  };
}
