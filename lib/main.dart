import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:mini_product_catalog_app/core/router/app_router.dart';
import 'package:mini_product_catalog_app/core/services/dependency_locator.dart';
import 'package:mini_product_catalog_app/features/cart/bloc/cart_bloc.dart';
import 'package:mini_product_catalog_app/features/cart/bloc/cart_event.dart';
import 'package:mini_product_catalog_app/features/cart/domain/entities/cart_entity.dart';
import 'package:mini_product_catalog_app/features/favorites/blocs/favorites_bloc.dart';
import 'package:mini_product_catalog_app/features/favorites/blocs/favourites_event.dart';
import 'package:mini_product_catalog_app/features/favorites/domain/entities/favorites_entity.dart';
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
        BlocProvider(
          create: (context) =>
              CartBloc(getIt<Box<CartItem>>())..add(CartLoading()),
        ),
        BlocProvider(
            create: (context) => FavoriteBloc((getIt<Box<FavoritesEntity>>()))
              ..add(LoadFavorites())),

        // Add other bloc providers as needed
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routerConfig: appRouter,
      ),
    );
  }
}
