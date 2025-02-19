import 'dart:async';
import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_product_catalog_app/features/products_listing/bloc/product_event.dart';
import 'package:mini_product_catalog_app/features/products_listing/bloc/product_state.dart';
import 'package:mini_product_catalog_app/features/products_listing/data/repositories/product_repository.dart';
import 'package:mini_product_catalog_app/core/services/connectivity_service.dart';
import 'package:mini_product_catalog_app/features/products_listing/domain/entities/product.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository productRepository;
  final ConnectivityService connectivityService;
  StreamSubscription<bool>? _connectivitySubscription;
  Timer? _searchDebounce;
  List<Product> _allProducts = [];

  ProductBloc({
    required this.productRepository,
    required this.connectivityService,
  }) : super(ProductInitial()) {
    on<FetchProducts>(_onFetchProducts);
    on<SearchProducts>(_onSearchProducts);

    _connectivitySubscription =
        connectivityService.connectivityStream.listen((_) {
      add(FetchProducts());
    });
  }

  Future<void> _onFetchProducts(
      FetchProducts event, Emitter<ProductState> emit) async {
    emit(ProductLoading());
    try {
      _allProducts = await productRepository.fetchProducts();
      emit(ProductLoaded(_allProducts));
    } catch (e) {
      emit(ProductError("Failed to load products"));
    }
  }

  Future<void> _onSearchProducts(
      SearchProducts event, Emitter<ProductState> emit) async {
    _searchDebounce?.cancel();
    final completer = Completer<void>();
    _searchDebounce = Timer(const Duration(milliseconds: 400), () async {
      final query = event.query.toLowerCase().trim();

      if (query.isEmpty) {
        emit(ProductLoaded(_allProducts));
      } else {
        try {
          final searchResults = await productRepository.searchProducts(query);
          emit(ProductSearchResults(searchResults));
        } catch (e) {
          emit(ProductError("Search failed"));
        }
      }
      completer.complete();
    });
    await completer.future;
  }

  @override
  Future<void> close() {
    _connectivitySubscription?.cancel();
    _searchDebounce?.cancel();
    return super.close();
  }
}
