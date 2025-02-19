import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_product_catalog_app/core/router/app_router.dart';
import 'package:mini_product_catalog_app/core/widgets/lottie_loader.dart';
import 'package:mini_product_catalog_app/features/cart/presentation/widgets/cart_widget.dart';
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
        appBar: AppBar(
          title: const Text("Products"),
          actions: [
            CartWidget(),
            IconButton(
              icon: const Icon(Icons.favorite_border),
              onPressed: () {
                appRouter.push('/favorites-screen');
              },
            ),
          ],
        ),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: BlocConsumer<ProductBloc, ProductState>(
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

              return CustomMaterialIndicator(
                onRefresh: () async {
                  context.read<ProductBloc>().add(FetchProducts());
                },
                backgroundColor: Colors.white,
                indicatorBuilder: (context, controller) {
                  return LottieLoader();
                },
                child: CustomScrollView(
                  slivers: [
                    _buildSliverAppBar(),
                    _buildProductGrid(state, products),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  SliverAppBar _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 70.0,
      pinned: true,
      flexibleSpace: Container(
        decoration: BoxDecoration(),
        child: FlexibleSpaceBar(
          title: const Text('Products', style: TextStyle(color: Colors.white)),
        ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(40.0),
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
            childAspectRatio: 0.47,
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
