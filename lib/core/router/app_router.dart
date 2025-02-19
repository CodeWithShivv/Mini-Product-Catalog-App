import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mini_product_catalog_app/features/cart/presentation/cart_screen.dart';
import 'package:mini_product_catalog_app/features/products_listing/presentation/products_listing_screen.dart';
import 'package:mini_product_catalog_app/features/products_view/presentation/products_view.dart';
import 'package:mini_product_catalog_app/features/splash/presentation/splash_screen.dart';
import 'package:mini_product_catalog_app/features/products_listing/domain/entities/product.dart';
import 'package:mini_product_catalog_app/features/favorites/presentation/favorites_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String productsListing = '/products-listing-screen';
  static const String productDetail = '/product-view-screen';
  static const String cart = '/cart-screen';
  static const String favorites = '/favorites-screen';
}

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.splash,
  routes: [
    GoRoute(
      path: AppRoutes.splash,
      builder: (context, state) => SplashScreen(),
    ),
    GoRoute(
      path: AppRoutes.productsListing,
      builder: (context, state) => ProductsListingScreen(),
    ),
    GoRoute(
      path: AppRoutes.productDetail,
      builder: (context, state) {
        final product = state.extra as Product?;
        if (product == null) {
          return const Scaffold(
            body: Center(child: Text('Invalid Product Data')),
          );
        }
        return ProductViewScreen(product: product);
      },
    ),
    GoRoute(
      path: AppRoutes.cart,
      builder: (context, state) => CartScreen(),
    ),
    GoRoute(
      path: AppRoutes.favorites,
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
