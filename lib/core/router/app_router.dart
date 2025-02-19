import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mini_product_catalog_app/features/products_listing/presentation/products_listing_screen.dart';
import 'package:mini_product_catalog_app/features/splash/presentation/splash_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    // Splash Screen Route
    GoRoute(
      path: '/',
      builder: (context, state) => SplashScreen(),
    ),

    GoRoute(
        path: '/products-screen',
        builder: (context, state) => ProductsListingScreen())
  ],
  errorBuilder: (context, state) {
    return Scaffold(
      body: Center(
        child: Text('Page not found'),
      ),
    );
  },
);
