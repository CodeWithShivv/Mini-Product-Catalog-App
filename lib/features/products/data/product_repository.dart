import 'package:mini_product_catalog_app/core/data/local/app_database.dart';
import 'package:mini_product_catalog_app/core/data/local/app_database_constants.dart';
import 'package:mini_product_catalog_app/core/services/firebase_service.dart';
import 'package:mini_product_catalog_app/core/services/connectivity_service.dart';
import 'package:mini_product_catalog_app/core/services/dependency_locator.dart';
import 'package:mini_product_catalog_app/features/products/domain/entities/product.dart';
import 'package:logger/logger.dart';
import 'package:flutter/foundation.dart';

class ProductRepository {
  final FirebaseService firebaseService = getIt<FirebaseService>();
  final AppDatabase appDatabase = getIt<AppDatabase>();
  final ConnectivityService connectivityService = getIt<ConnectivityService>();
  final Logger logger = getIt<Logger>();

  /// Fetch products from Firestore or Hive based on connectivity
  Future<List<Product>> fetchProducts() async {
    bool isOnline = await connectivityService.isConnected();

    if (isOnline) {
      logger.i("Online: Fetching latest products from Firestore...");
      await syncProducts();
    } else {
      logger.w("Offline: Fetching products from local database.");
    }

    return getLocalProducts();
  }

  Future<void> syncProducts() async {
    List<Product> remoteProducts = await firebaseService.fetchProducts();
    if (remoteProducts.isEmpty) return;

    try {
      var box =
          await appDatabase.openBox<Product>(AppDataBaseConstants.productsBox);

      Map<int, Product> productMap =
          await syncProductsWithIsolate(box.toMap(), remoteProducts);

      if (productMap.isNotEmpty) {
        await box.putAll(productMap);
        logger.i(
            "Synchronized ${productMap.length} updated/new products to Hive.");
      } else {
        logger.i("No new updates for products.");
      }
    } catch (e) {
      logger.e("Error syncing products: $e");
    }
  }


  Future<Map<int, Product>> syncProductsWithIsolate(
      Map<dynamic, Product> existingProducts,
      List<Product> remoteProducts) async {
    if (remoteProducts.length > 50) { 
      return await compute(_processProducts,
          {'boxData': existingProducts, 'remoteProducts': remoteProducts});
    }

    return _processProducts(
        {'boxData': existingProducts, 'remoteProducts': remoteProducts});
  }

  Future<List<Product>> getLocalProducts() async {
    return await appDatabase.getAllData(AppDataBaseConstants.productsBox);
  }
}

/// Function that processes products (can be run in an isolate)
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
