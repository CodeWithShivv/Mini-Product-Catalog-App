import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_product_catalog_app/features/products_listing/bloc/product_bloc.dart';
import 'package:mini_product_catalog_app/features/products_listing/bloc/product_event.dart';
import 'package:mini_product_catalog_app/features/products_listing/bloc/product_state.dart';
import 'package:mini_product_catalog_app/core/services/dependency_locator.dart';
import 'package:mini_product_catalog_app/features/products_listing/presentation/widgets/product_card.dart';
import 'package:mini_product_catalog_app/features/products_listing/presentation/widgets/product_search_bar.dart';
import 'package:mini_product_catalog_app/features/products_listing/presentation/widgets/skelton_product_grid.dart';

class ProductsListingScreen extends StatelessWidget {
  const ProductsListingScreen({super.key});
  static final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProductBloc(
        productRepository: getIt(),
        connectivityService: getIt(),
      )..add(FetchProducts()),
      child: Scaffold(
        appBar: AppBar(title: const Text("Products")),
        body: BlocConsumer<ProductBloc, ProductState>(
          listener: (context, state) {
            if (state is ProductError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          builder: (context, state) {
            final products = state is ProductSearchResults
                ? state.searchResults
                : state is ProductLoaded
                    ? state.products
                    : [];

            return CustomScrollView(
              slivers: [
                _buildSliverAppBar(),
                _buildProductGrid(state, products),
              ],
            );
          },
        ),
      ),
    );
  }

  SliverAppBar _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 100.0,
      pinned: true,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.green],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: FlexibleSpaceBar(
          title: const Text('Products', style: TextStyle(color: Colors.white)),
          background: Container(), // Empty container for additional background
        ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(40.0), // Height for search bar
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14),
          child: ProductSearchBar(controller: controller),
        ),
      ),
    );
  }

  Widget _buildProductGrid(ProductState state, List products) {
    if (state is ProductLoading) {
      return const SliverSkeletonProductGrid();
    } else if (products.isNotEmpty) {
      return SliverPadding(
        padding: const EdgeInsets.all(8),
        sliver: SliverGrid(
          delegate: SliverChildBuilderDelegate(
            (context, index) => ProductCard(product: products[index]),
            childCount: products.length,
          ),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 0.8,
          ),
        ),
      );
    } else {
      return const SliverFillRemaining(
        child: Center(child: Text("No products available.")),
      );
    }
  }
}
