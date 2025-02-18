import 'package:flutter/material.dart';
import 'package:mini_product_catalog_app/core/router/app_router.dart';
import 'package:mini_product_catalog_app/core/services/dependency_locator.dart';
import 'package:mini_product_catalog_app/core/services/firebase_service.dart';
import 'package:mini_product_catalog_app/core/services/hive_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Setup Dependency Injection
    setupDependencyInjection();
    await getIt.allReady();

    getIt<FirebaseService>().initialize();
    getIt<HiveService>().initHive();
  } catch (e) {
    return;
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: AppRouter.router,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        scaffoldBackgroundColor: Colors.white,
      ),
    );
  }
}
