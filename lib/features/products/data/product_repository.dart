import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mini_product_catalog_app/core/data/local/app_database.dart';
import 'package:mini_product_catalog_app/core/data/local/app_database_constants.dart';
import 'package:mini_product_catalog_app/core/services/firebase_service.dart';
import 'package:mini_product_catalog_app/features/products/domain/entities/product.dart';
import 'package:mini_product_catalog_app/core/services/dependency_locator.dart';
import 'package:logger/logger.dart';

class ProductRepository {
  final FirebaseService firebaseService = getIt<FirebaseService>();
  final AppDatabase appDatabase = getIt<AppDatabase>();
  final Logger logger = getIt<Logger>();

  /// Fetch products from Firestore
  Future<List<Product>> fetchProducts() async {
    try {
      QuerySnapshot snapshot = await firebaseService.firestore
          .collection(AppDataBaseConstants.productsBox)
          .get();

      List<Product> products = snapshot.docs.map((doc) {
        return Product.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();

      logger.i("Fetched ${products.length} products from Firestore.");
      return products;
    } catch (e) {
      logger.e("Error fetching products: $e");
      return [];
    }
  }

  Future<void> syncProducts() async {
    try {
      bool isProductsAvailable =
          await firebaseService.isProductsUpdateAvailable();

      if (isProductsAvailable) {
        List<Product> remoteProducts = await fetchProducts();

        if (remoteProducts.isNotEmpty) {
          var box = await appDatabase
              .openBox<Product>(AppDataBaseConstants.productsBox);

          await box.clear();

          // Convert products to a Map for batch insertion
          Map<String, Product> productMap = {
            for (var product in remoteProducts) product.id.toString(): product,
          };

          await box.putAll(productMap);
          logger.i("Synchronized ${remoteProducts.length} products to Hive.");
        }
      } 
    } catch (e) {
      logger.e("Error syncing products: $e");
    }
  }


  Future<List<Product>> getProducts() async {
    return await appDatabase.getAllData(AppDataBaseConstants.productsBox);
  }
}
