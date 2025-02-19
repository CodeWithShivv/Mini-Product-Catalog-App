import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_product_catalog_app/core/router/app_router.dart';
import 'package:mini_product_catalog_app/features/favorites/blocs/favorites_bloc.dart';
import 'package:mini_product_catalog_app/features/favorites/blocs/favourites_state.dart';

class FavoritesIconWidget extends StatelessWidget {
  const FavoritesIconWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoriteBloc, FavoriteState>(
      builder: (context, state) {
        int favoritesCount = 0;
        if (state is FavoriteLoaded) {
          favoritesCount = state.favoriteItems.length;
        }

        return Stack(
          children: [
            IconButton(
              icon: const Icon(Icons.favorite_border),
              onPressed: () {
                appRouter.push(AppRoutes.favorites);
              },
            ),
            if (favoritesCount > 0)
              Positioned(
                right: 4,
                top: 4,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  constraints:
                      const BoxConstraints(minWidth: 18, minHeight: 18),
                  child: Text(
                    favoritesCount.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
