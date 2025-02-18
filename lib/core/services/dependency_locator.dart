import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:mini_product_catalog_app/core/services/firebase_service.dart';
import 'package:mini_product_catalog_app/core/services/hive_service.dart';

final GetIt getIt = GetIt.instance;

void setupDependencyInjection() {
  getIt
    ..registerLazySingleton<FirebaseService>(() => FirebaseService())
    ..registerLazySingleton<HiveService>(() => HiveService())
    ..registerLazySingleton<Logger>(() => Logger());
}
