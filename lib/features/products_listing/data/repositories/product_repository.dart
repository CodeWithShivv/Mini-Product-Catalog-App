import 'package:flutter/foundation.dart';
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

  List<Product>? remoteProducts; 

  /// **Fetch products based on availability (online/offline)**
  Future<List<Product>> fetchProducts({int page = 1, int limit = 10}) async {
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

  Future<List<Product>> searchProducts(String query) async {
    bool isOnline = await getIt<ConnectivityService>().isConnected();
    return isOnline
        ? await _firebaseService.searchProducts(query) // Online search
        : await _searchLocalProducts(query); // Offline search
  }

  /// **Search for products locally**
  Future<List<Product>> _searchLocalProducts(String query) async {
    List<Product> localProducts =
        await _appDatabase.getAllData(AppDataBaseConstants.productsBox);

    if (query.isEmpty) return localProducts;

    String lowerQuery = query.toLowerCase().trim();
    return localProducts.where((product) {
      return product.title.toLowerCase().contains(lowerQuery) ||
          product.description.toLowerCase().contains(lowerQuery);
    }).toList();
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
