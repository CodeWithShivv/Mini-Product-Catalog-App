import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mini_product_catalog_app/features/home/presentation/home_screen.dart';
import 'package:mini_product_catalog_app/features/splash/presentation/splash_screen.dart';

class AppRouter {
  // Create GoRouter instance
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      // Splash Screen Route
      GoRoute(
        path: '/',
        builder: (context, state) => SplashScreen(),
      ),
      // Home Screen Route
      GoRoute(
        path: '/home',
        builder: (context, state) => HomeScreen(),
      ),
    ],
    errorBuilder: (context, state) {
      return Scaffold(
        body: Center(
          child: Text('Page not found'),
        ),
      );
    },
  );
}
