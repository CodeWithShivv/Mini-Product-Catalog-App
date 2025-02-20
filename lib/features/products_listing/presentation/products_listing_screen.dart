import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_product_catalog_app/core/widgets/lottie_loader.dart';
import 'package:mini_product_catalog_app/features/cart/presentation/widgets/cart_widget.dart';
import 'package:mini_product_catalog_app/features/connectivity/bloc/connectivity_bloc.dart';
import 'package:mini_product_catalog_app/features/connectivity/bloc/connectivity_state.dart';
import 'package:mini_product_catalog_app/features/favorites/presentation/widgets/favorites_icon.dart';
import 'package:mini_product_catalog_app/features/products_listing/bloc/product_bloc.dart';
import 'package:mini_product_catalog_app/features/products_listing/bloc/product_event.dart';
import 'package:mini_product_catalog_app/features/products_listing/bloc/product_state.dart';
import 'package:mini_product_catalog_app/core/services/dependency_locator.dart';
import 'package:mini_product_catalog_app/features/products_listing/presentation/widgets/product_search_bar.dart';
import 'package:mini_product_catalog_app/features/products_listing/presentation/widgets/products_grid.dart';

class ProductsListingScreen extends StatelessWidget {
  const ProductsListingScreen({super.key});
  static final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProductBloc(
        productRepository: getIt(),
      )..add(FetchProducts()),
      child: BlocListener<ConnectivityBloc, ConnectivityState>(
        listener: (BuildContext context, state) {
          if (state is ConnectivityUpdated) {
            // It will sync the products from app db
            context.read<ProductBloc>().add(FetchProducts());

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.isConnected
                      ? "Back online!"
                      : "No internet connection Working Offline",
                ),
                backgroundColor: state.isConnected ? Colors.green : Colors.red,
              ),
            );
          }
        },
        child: Scaffold(
          appBar: _buildAppBar(),
          body: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: BlocConsumer<ProductBloc, ProductState>(
              listener: (context, state) {
                if (state is ProductError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.message)),
                  );
                }
              },
              builder: (context, state) {
                final products = _getProductList(state);
                final hasMore = state is ProductLoaded ? state.hasMore : false;

                return NotificationListener<ScrollNotification>(
                  onNotification: (scrollInfo) =>
                      _handleScroll(context, scrollInfo, state),
                  child: CustomMaterialIndicator(
                    onRefresh: () async =>
                        context.read<ProductBloc>().add(FetchProducts()),
                    backgroundColor: Colors.white,
                    indicatorBuilder: (_, __) => LottieLoader(),
                    child: CustomScrollView(
                      slivers: [
                        _buildSliverAppBar(),
                        ProductGrid(
                            state: state, products: products, hasMore: hasMore)
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text("Products"),
      actions: const [CartWidget(), FavoritesIconWidget()],
    );
  }

  List _getProductList(ProductState state) {
    if (state is ProductSearchResults) {
      return state.searchResults;
    } else if (state is ProductLoaded || state is ProductPaginating) {
      return (state as dynamic).products;
    }
    return [];
  }

  bool _handleScroll(
      BuildContext context, ScrollNotification scrollInfo, ProductState state) {
    if (scrollInfo.metrics.pixels >= scrollInfo.metrics.maxScrollExtent * 0.9 &&
        state is ProductLoaded &&
        state.hasMore) {
      context.read<ProductBloc>().add(FetchMoreProducts());
    }
    return false;
  }

  SliverAppBar _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 70.0,
      pinned: true,
      flexibleSpace: const FlexibleSpaceBar(
        title: Text('Products', style: TextStyle(color: Colors.white)),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(40.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14),
          child: ProductSearchBar(controller: controller),
        ),
      ),
    );
  }
}
