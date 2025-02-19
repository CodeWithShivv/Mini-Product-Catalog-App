import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_product_catalog_app/features/products_listing/bloc/product_bloc.dart';
import 'package:mini_product_catalog_app/features/products_listing/bloc/product_event.dart';
import 'package:mini_product_catalog_app/features/products_listing/bloc/product_state.dart';
import 'package:mini_product_catalog_app/core/services/dependency_locator.dart';
import 'package:mini_product_catalog_app/features/products_listing/presentation/widgets/product_card.dart';
import 'package:mini_product_catalog_app/features/products_listing/presentation/widgets/skelton_product_grid.dart';


class ProductsListingScreen extends StatelessWidget {
  const ProductsListingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ProductBloc(productRepository: getIt(), connectivityService: getIt())
            ..add(FetchProducts()),
      child: Scaffold(
        appBar: AppBar(title: const Text("Products")),
        body: BlocBuilder<ProductBloc, ProductState>(
          builder: (context, state) {
            return CustomScrollView(
              slivers: [
                if (state is ProductLoading)
                  const SliverSkeletonProductGrid()
                else if (state is ProductLoaded)
                  // Product Loaded
                  SliverPadding(
                    padding: const EdgeInsets.all(8),
                    sliver: SliverGrid(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) =>
                            ProductCard(product: state.products[index]),
                        childCount: state.products.length,
                      ),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                        childAspectRatio: 0.8,
                      ),
                    ),
                  )
                else if (state is ProductError)
                  SliverFillRemaining(
                    child: Center(child: Text(state.message)),
                  )
                else
                  const SliverFillRemaining(
                    child: Center(child: Text("No products available.")),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
