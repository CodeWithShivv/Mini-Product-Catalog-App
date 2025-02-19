import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_product_catalog_app/features/cart/bloc/cart_bloc.dart';
import 'package:mini_product_catalog_app/features/cart/bloc/cart_event.dart';
import 'package:mini_product_catalog_app/features/cart/domain/entities/cart_entity.dart';
import 'package:mini_product_catalog_app/features/favorites/blocs/favorites_bloc.dart';
import 'package:mini_product_catalog_app/features/favorites/blocs/favourites_event.dart';
import 'package:mini_product_catalog_app/features/favorites/blocs/favourites_state.dart';
import 'package:mini_product_catalog_app/features/favorites/domain/entities/favorites_entity.dart';
import 'package:mini_product_catalog_app/features/products_listing/domain/entities/product.dart';

class ProductViewScreen extends StatelessWidget {
  final Product product;

  const ProductViewScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border),
            onPressed: () {
              context.read<FavoriteBloc>().add(AddToFavorites(FavoritesEntity(
                  id: product.id.toString(), product: product)));

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Added to Favorites")),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Hero(
                tag: 'product_${product.id}', // Unique tag for animation
                child: CachedNetworkImage(
                  imageUrl: product.image,
                  height: 250,
                  width: double.infinity,
                  fit: BoxFit.fill,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              product.title,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              '\$${product.price.toStringAsFixed(2)}',
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.star, color: Colors.amber),
                Text(
                    '${product.rating.rate} (${product.rating.count} reviews)'),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              product.description,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.read<CartBloc>().add(AddToCart(product));
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Added to Cart!")),
          );
        },
        icon: const Icon(Icons.shopping_cart),
        label: const Text("Add to Cart"),
      ),
    );
  }
}
