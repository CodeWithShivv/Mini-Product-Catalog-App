import 'package:flutter/material.dart';
import 'package:mini_product_catalog_app/features/products_listing/bloc/product_state.dart';
import 'package:mini_product_catalog_app/features/products_listing/presentation/widgets/product_card.dart';
import 'package:mini_product_catalog_app/features/products_listing/presentation/widgets/skelton_product_grid.dart';

class ProductGrid extends StatelessWidget {
  final ProductState state;
  final List products;
  final bool hasMore;

  const ProductGrid({
    super.key,
    required this.state,
    required this.products,
    required this.hasMore,
  });

  @override
  Widget build(BuildContext context) {
    if (state is ProductLoading) {
      return const SliverSkeletonProductGrid();
    }

    if (products.isEmpty) {
      return const SliverFillRemaining(
        hasScrollBody: false,
        child: Center(
          child: Text(
            "No products available.",
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.all(8),
      sliver: SliverGrid(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            if (index == products.length) {
              return Padding(
                padding: const EdgeInsets.only(top: 40.0),
                child: Center(
                  child: hasMore
                      ? const CircularProgressIndicator()
                      : const Text(
                          "No more products found.",
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                ),
              );
            }
            return ProductCard(product: products[index]);
          },
          childCount: products.length + 1,
        ),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 0.47,
        ),
      ),
    );
  }
}
