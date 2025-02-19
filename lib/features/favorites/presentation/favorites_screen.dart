import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_product_catalog_app/core/router/app_router.dart';
import 'package:mini_product_catalog_app/features/favorites/blocs/favorites_bloc.dart';
import 'package:mini_product_catalog_app/features/favorites/blocs/favourites_event.dart';
import 'package:mini_product_catalog_app/features/favorites/blocs/favourites_state.dart';
import 'package:mini_product_catalog_app/features/products_listing/presentation/widgets/product_card.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Favorites")),
      body: BlocBuilder<FavoriteBloc, FavoriteState>(
        builder: (context, state) {
          if (state is FavoriteLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is FavoriteLoaded) {
            if (state.favoriteItems.isEmpty) {
              return const Center(child: Text("No favorite products yet."));
            }
            return ListView.builder(
              itemCount: state.favoriteItems.length,
              itemBuilder: (context, index) {
                final item = state.favoriteItems[index];

                return Dismissible(
                  key: Key(item.product.id.toString()),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (_) {
                    context.read<FavoriteBloc>().add(
                          RemoveFromFavorites(item.product.id.toString()),
                        );
                  },
                  child: GestureDetector(
                    onTap: () {
                      appRouter.push('/product-view-screen',
                          extra: item.product);
                    },
                    child: Hero(
                      tag:
                          'product_${item.product.id}', // Unique tag for animation
                      child: Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        child: ListTile(
                          leading: CachedNetworkImage(
                            imageUrl: item.product.image,
                            width: 50,
                            height: 50,
                            fit: BoxFit.fill,
                          ),
                          title: Text(
                            item.product.title,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            '₹${item.product.price.toStringAsFixed(2)}',
                            style: const TextStyle(color: Colors.green),
                          ),
                          trailing: IconButton(
                            icon: const Icon(
                              Icons.favorite,
                              color: Colors.red,
                            ),
                            onPressed: () {
                              context.read<FavoriteBloc>().add(
                                  RemoveFromFavorites(
                                      item.product.id.toString()));
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(child: Text("Something went wrong!"));
          }
        },
      ),
    );
  }
}
