import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mini_product_catalog_app/features/cart/presentation/cart_screen.dart';
import 'package:mini_product_catalog_app/features/products_listing/presentation/products_listing_screen.dart';
import 'package:mini_product_catalog_app/features/products_view/presentation/products_view.dart';
import 'package:mini_product_catalog_app/features/splash/presentation/splash_screen.dart';
import 'package:mini_product_catalog_app/features/products_listing/domain/entities/product.dart';
import 'package:mini_product_catalog_app/features/favorites/presentation/favorites_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => SplashScreen(),
    ),
    GoRoute(
      path: '/products-listing-screen',
      builder: (context, state) => ProductsListingScreen(),
    ),
    GoRoute(
      path: '/product-view-screen',
      builder: (context, state) {
        final product = state.extra as Product;
        return ProductViewScreen(product: product);
      },
    ),
    GoRoute(
      path: '/cart-screen',
      builder: (context, state) => CartScreen(),
    ),
    GoRoute(
      path: '/favorites-screen',
      builder: (context, state) => FavoritesScreen(),
    ),
  ],
  errorBuilder: (context, state) {
    return const Scaffold(
      body: Center(
        child: Text('Page not found'),
      ),
    );
  },
);
