import 'package:hive/hive.dart';
import 'package:mini_product_catalog_app/core/data/local/app_database_constants.dart';
import 'package:mini_product_catalog_app/features/cart/domain/entities/cart_entity.dart';
import 'package:mini_product_catalog_app/features/favorites/domain/entities/favorites_entity.dart';
import 'package:path_provider/path_provider.dart';
import 'package:mini_product_catalog_app/features/products_listing/domain/entities/product.dart';
import 'package:mini_product_catalog_app/core/services/dependency_locator.dart';
import 'package:logger/logger.dart';

class AppDatabase {
  final Logger logger = getIt<Logger>();

  Future<void> initialize() async {
    try {
      final appDocumentDirectory = await getApplicationDocumentsDirectory();
      Hive.init(appDocumentDirectory.path);

      Hive
        ..registerAdapter(ProductAdapter())
        ..registerAdapter(RatingAdapter())
        ..registerAdapter(CartItemAdapter())
        ..registerAdapter(FavoritesEntityAdapter());

      logger.i("Hive initialized successfully.");
    } catch (e) {
      logger.e("Error initializing Hive: $e");
      rethrow;
    }
  }

  Future<Box<T>> openBox<T>(String boxName) async {
    try {
      if (!Hive.isBoxOpen(boxName)) {
        return await Hive.openBox<T>(boxName);
      }
      return Hive.box<T>(boxName);
    } catch (e) {
      logger.e("Error opening box $boxName: $e");
      rethrow;
    }
  }

  Future<void> saveData<T>(String boxName, String key, T data) async {
    try {
      var box = await Hive.openBox<T>(boxName);
      await box.put(key, data);
    } catch (e) {
      logger.e("Error saving data in $boxName: $e");
    }
  }

  Future<T?> getData<T>(String boxName, String key) async {
    try {
      var box = await Hive.openBox<T>(boxName);
      return box.get(key);
    } catch (e) {
      logger.e("Error retrieving data from $boxName: $e");
      return null;
    }
  }

  Future<List<T>> getAllData<T>(String boxName) async {
    try {
      var box = await Hive.openBox<T>(boxName);
      return box.values.toList();
    } catch (e) {
      logger.e("Error getting all data from $boxName: $e");
      return [];
    }
  }

  /// **Get paginated data from local storage**
  Future<List<T>> getPaginatedData<T>(
      String boxName, int offset, int limit) async {
    try {
      var box = await Hive.openBox<T>(boxName);
      List<T> allData = box.values.toList();

      if (offset >= allData.length) {
        return [];
      }

      return allData.skip(offset).take(limit).toList();
    } catch (e) {
      logger.e("Error fetching paginated data from $boxName: $e");
      return [];
    }
  }

  Future<void> deleteData(String boxName, String key) async {
    try {
      var box = await Hive.openBox(boxName);
      await box.delete(key);
    } catch (e) {
      logger.e("Error deleting data from $boxName: $e");
    }
  }

  Future<void> clearBox(String boxName) async {
    try {
      var box = await Hive.openBox(boxName);
      await box.clear();
    } catch (e) {
      logger.e("Error clearing box $boxName: $e");
    }
  }
}
