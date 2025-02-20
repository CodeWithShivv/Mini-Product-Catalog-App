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

  final List<Product> _cachedProducts = [];
  bool _hasMore = true;

  final List<Product> _cachedLocalProducts = [];
  bool _localHasMore = true;

  /// **Fetch products with pagination**
  Future<List<Product>> fetchProducts({bool isFirstFetch = false}) async {
    bool isOnline = await getIt<ConnectivityService>().isConnected();
    return isOnline
        ? await _fetchAndSyncProducts(isFirstFetch)
        : await getLocalProducts(isFirstFetch);
  }

  /// **Fetch and sync remote products (handles pagination)**
  Future<List<Product>> _fetchAndSyncProducts(bool isFirstFetch) async {
    if (isFirstFetch) {
      _cachedProducts.clear();
      _firebaseService.resetPagination();
      _hasMore = true;
    }

    if (!_hasMore) return _cachedProducts;

    List<Product> newProducts =
        await _firebaseService.fetchProducts(isFirstFetch: isFirstFetch);

    if (newProducts.isEmpty) {
      _hasMore = false;
    } else {
      _cachedProducts.addAll(newProducts);
      await syncProducts(newProducts);
    }

    return List.from(_cachedProducts);
  }

  /// **Fetch local products with pagination**
  Future<List<Product>> getLocalProducts([bool isFirstFetch = false]) async {
    if (isFirstFetch) {
      _cachedLocalProducts.clear();
      _localHasMore = true;
    }

    if (!_localHasMore) return _cachedLocalProducts;

    List<Product> newProducts = await _appDatabase.getPaginatedData(
      AppDataBaseConstants.productsBox,
      _cachedLocalProducts.length, // Offset
      10, // Limit (fetch 10 at a time)
    );

    if (newProducts.isEmpty) {
      _localHasMore = false;
    } else {
      _cachedLocalProducts.addAll(newProducts);
    }

    return List.from(_cachedLocalProducts);
  }

  /// **Search Products**
  Future<List<Product>> searchProducts(String query) async {
    bool isOnline = await getIt<ConnectivityService>().isConnected();

    if (isOnline) {
      return await _firebaseService.searchProducts(query);
    } else {
      var box =
          await _appDatabase.openBox<Product>(AppDataBaseConstants.productsBox);
      List<Product> allLocalProducts = box.values.toList();

      return allLocalProducts
          .where((product) =>
              product.title.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
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
            .i("Synchronized \${updatedProducts.length} updated/new products.");
      }
    } catch (e) {
      _logger.e("Error syncing products: \$e");
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

  void resetPagination() {
    _firebaseService.resetPagination();
    _cachedProducts.clear();
    _hasMore = true;

    _cachedLocalProducts.clear();
    _localHasMore = true;
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
