import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:logger/logger.dart';
import 'package:mini_product_catalog_app/core/data/local/app_database.dart';
import 'package:mini_product_catalog_app/core/data/local/app_database_constants.dart';
import 'package:mini_product_catalog_app/core/router/app_router.dart';
import 'package:mini_product_catalog_app/core/services/connectivity_service.dart';
import 'package:mini_product_catalog_app/core/services/firebase_service.dart';
import 'package:mini_product_catalog_app/features/cart/domain/entities/cart_entity.dart'
    show CartItem;
import 'package:mini_product_catalog_app/features/favorites/domain/entities/favorites_entity.dart';
import 'package:mini_product_catalog_app/features/products_listing/data/repositories/product_repository.dart';

final GetIt getIt = GetIt.instance;

Future<void> setupDependencyInjection() async {
  final logger = Logger();
  getIt.registerLazySingleton<Logger>(() => logger);

  // Register Firebase and Hive instances
  final firebaseService = FirebaseService();
  final appDatabase = AppDatabase();

  await Future.wait([
    firebaseService.initialize(),
    appDatabase.initialize(),
  ]);

  getIt
    ..registerLazySingleton<FirebaseService>(() => firebaseService)
    ..registerLazySingleton<AppDatabase>(() => appDatabase)
    ..registerLazySingleton<ProductRepository>(() => ProductRepository())
    ..registerLazySingleton(() => ConnectivityService())
    ..registerSingleton<Box<CartItem>>(
        await appDatabase.openBox<CartItem>(AppDataBaseConstants.cart))
    ..registerSingleton<Box<FavoritesEntity>>(await appDatabase
        .openBox<FavoritesEntity>(AppDataBaseConstants.favoritesBox));

  logger.i("Dependency Injection setup completed successfully.");
}
