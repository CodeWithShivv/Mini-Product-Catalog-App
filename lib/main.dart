import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_product_catalog_app/core/router/app_router.dart';
import 'package:mini_product_catalog_app/core/services/dependency_locator.dart';
import 'package:mini_product_catalog_app/features/splash/bloc/splash_bloc.dart';
import 'package:mini_product_catalog_app/features/splash/bloc/splash_event.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // **Ensure DI setup completes before runApp()**
  await setupDependencyInjection();
  await getIt.allReady(); // Ensures all lazySingletons are ready

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => SplashBloc(
            productRepository: getIt(),
          )..add(AppInitialized()),
        ),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routerConfig: appRouter,
      ),
    );
  }
}
