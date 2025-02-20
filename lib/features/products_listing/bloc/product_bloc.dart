import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_product_catalog_app/features/products_listing/bloc/product_event.dart';
import 'package:mini_product_catalog_app/features/products_listing/bloc/product_state.dart';
import 'package:mini_product_catalog_app/features/products_listing/data/repositories/product_repository.dart';
import 'package:mini_product_catalog_app/features/products_listing/domain/entities/product.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository productRepository;

  Timer? _searchDebounce;
  final List<Product> _allProducts = [];
  bool _isFetchingMore = false;
  bool _hasMore = true;

  ProductBloc({
    required this.productRepository,
  }) : super(ProductInitial()) {
    on<FetchProducts>(_onFetchProducts);
    on<SearchProducts>(_onSearchProducts);
    on<FetchMoreProducts>(_onFetchMoreProducts);
    on<ResetProducts>(_onInitialProductsSet);
  }

  Future<void> _onInitialProductsSet(
      ResetProducts event, Emitter<ProductState> emit) async {
    emit(ProductLoaded(products: _allProducts, hasMore: _hasMore));
  }

  Future<void> _onFetchProducts(
      FetchProducts event, Emitter<ProductState> emit) async {
    emit(ProductLoading());
    try {
      _allProducts.clear();
      _hasMore = true;

      final newProducts =
          await productRepository.fetchProducts(isFirstFetch: true);

      _allProducts.addAll(newProducts);
      _hasMore = newProducts.isNotEmpty;

      emit(ProductLoaded(products: List.from(_allProducts), hasMore: _hasMore));
    } catch (e) {
      emit(ProductError("Failed to load products"));
    }
  }

  Future<void> _onFetchMoreProducts(
      FetchMoreProducts event, Emitter<ProductState> emit) async {
    if (_isFetchingMore || !_hasMore) return;

    _isFetchingMore = true;

    try {
      final newProducts =
          await productRepository.fetchProducts(isFirstFetch: false);

      if (newProducts.isNotEmpty) {
        _allProducts.addAll(newProducts);
      }

      // If the number of new products is less than pageSize (10), we have reached the end
      _hasMore = newProducts.length == 10;

      emit(ProductLoaded(
          products: List.from(_allProducts),
          hasMore: _hasMore,
          isPaginating: false));
    } catch (e) {
      emit(ProductError("Failed to load more products"));
    } finally {
      _isFetchingMore = false;
    }
  }

  Future<void> _onSearchProducts(
      SearchProducts event, Emitter<ProductState> emit) async {
    _searchDebounce?.cancel();
    emit(ProductLoading());
    final completer = Completer<void>();
    _searchDebounce = Timer(const Duration(milliseconds: 500), () async {
      final query = event.query.toLowerCase().trim();

      if (query.isEmpty) {
        emit(ProductLoaded(products: _allProducts, hasMore: _hasMore));
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
}
