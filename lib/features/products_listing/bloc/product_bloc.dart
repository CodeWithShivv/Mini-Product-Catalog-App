import 'dart:async';
import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_product_catalog_app/features/products_listing/bloc/product_event.dart';
import 'package:mini_product_catalog_app/features/products_listing/bloc/product_state.dart';
import 'package:mini_product_catalog_app/features/products_listing/data/repositories/product_repository.dart';
import 'package:mini_product_catalog_app/core/services/connectivity_service.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository productRepository;
  final ConnectivityService connectivityService;
  late final StreamSubscription<bool> _connectivitySubscription;

  ProductBloc({
    required this.productRepository,
    required this.connectivityService,
  }) : super(ProductInitial()) {
    on<FetchProducts>(_onFetchProducts);

    _connectivitySubscription =
        connectivityService.connectivityStream.listen((value) {
      log("connectivity changes");
      
      add(FetchProducts());
    });
  }

  Future<void> _onFetchProducts(
      FetchProducts event, Emitter<ProductState> emit) async {
    emit(ProductLoading());
    try {
      final products = await productRepository.fetchProducts();
      emit(ProductLoaded(products));
    } catch (e) {
      emit(ProductError("Failed to load products"));
    }
  }

  @override
  Future<void> close() {
    _connectivitySubscription.cancel();
    return super.close();
  }
}
