import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:mini_product_catalog_app/core/data/local/app_database.dart';
import 'package:mini_product_catalog_app/core/data/local/app_database_constants.dart';
import 'package:mini_product_catalog_app/core/services/connectivity_service.dart';
import 'package:mini_product_catalog_app/core/services/firebase_service.dart';
import 'package:mini_product_catalog_app/core/services/dependency_locator.dart';
import 'package:mini_product_catalog_app/features/products_listing/domain/entities/product.dart';
import 'package:logger/logger.dart';

class ProductRepository {
  final FirebaseService _firebaseService = getIt<FirebaseService>();
  final AppDatabase _appDatabase = getIt<AppDatabase>();
  final Logger _logger = getIt<Logger>();

  List<Product>? remoteProducts; // Cached remote products

  /// **Fetch products based on availability (online/offline)**
  Future<List<Product>> fetchProducts() async {
    bool isOnline = await getIt<ConnectivityService>().isConnected();
    return isOnline ? await _fetchAndSyncProducts() : await getLocalProducts();
  }

  /// **Fetch products from Firestore**
  Future<List<Product>> fetchRemoteProducts() async {
    try {
      if (remoteProducts?.isNotEmpty ?? false) {
        return remoteProducts!;
      }
      remoteProducts = await _firebaseService.fetchProducts();
      return remoteProducts ?? [];
    } catch (e) {
      _logger.e("Error fetching products from Firestore: $e");
      return [];
    }
  }

  /// **Fetch and sync remote products**
  Future<List<Product>> _fetchAndSyncProducts() async {
    remoteProducts = await fetchRemoteProducts();
    if (remoteProducts?.isEmpty ?? true) return [];

    await syncProducts(remoteProducts!);
    return remoteProducts!;
  }

  /// **Sync remote products with local storage**
  Future<void> syncProducts(List<Product> remoteProducts) async {
    try {
      var box =
          await _appDatabase.openBox<Product>(AppDataBaseConstants.productsBox);
      Map<int, Product> updatedProducts =
          await _syncProductsWithIsolate(box.toMap(), remoteProducts);

      if (updatedProducts.isNotEmpty) {
        await box.putAll(updatedProducts);
        _logger
            .i("Synchronized ${updatedProducts.length} updated/new products.");
      }
    } catch (e) {
      _logger.e("Error syncing products: $e");
    }
  }

  /// **Sync products using an isolate for performance**
  Future<Map<int, Product>> _syncProductsWithIsolate(
      Map<dynamic, Product> existingProducts,
      List<Product> remoteProducts) async {
    return remoteProducts.length > 20
        ? await compute(processProductsForSync,
            {'boxData': existingProducts, 'remoteProducts': remoteProducts})
        : processProductsForSync(
            {'boxData': existingProducts, 'remoteProducts': remoteProducts});
  }

  Future<List<Product>> getLocalProducts() async {
    return await _appDatabase.getAllData(AppDataBaseConstants.productsBox);
  }
}

/// **Helper function that processes products for sync (can run in an isolate)**
Map<int, Product> processProductsForSync(Map<String, dynamic> data) {
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
