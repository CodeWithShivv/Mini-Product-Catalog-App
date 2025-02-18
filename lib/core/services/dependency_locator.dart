import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:mini_product_catalog_app/core/data/local/app_database.dart';
import 'package:mini_product_catalog_app/core/router/app_router.dart';
import 'package:mini_product_catalog_app/core/services/firebase_service.dart';
import 'package:mini_product_catalog_app/features/products/data/product_repository.dart';

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
    ..registerLazySingleton<ProductRepository>(() => ProductRepository());

  logger.i("Dependency Injection setup completed successfully.");
}
