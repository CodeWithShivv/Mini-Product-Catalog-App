import 'package:flutter/material.dart';
import 'package:mini_product_catalog_app/features/products_listing/presentation/widgets/skelton_product_card.dart';

class SliverSkeletonProductGrid extends StatelessWidget {
  const SliverSkeletonProductGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.all(8),
      sliver: SliverGrid(
        delegate: SliverChildBuilderDelegate(
          (context, index) => const SkeletonProductCard(),
          childCount: 10,
        ),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 0.8,
        ),
      ),
    );
  }
}
