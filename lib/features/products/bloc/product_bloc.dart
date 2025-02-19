import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_product_catalog_app/features/products/bloc/product_event.dart';
import 'package:mini_product_catalog_app/features/products/bloc/product_state.dart';
import 'package:mini_product_catalog_app/features/products/data/product_repository.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository productRepository;

  ProductBloc({required this.productRepository}) : super(ProductInitial()) {
    on<FetchProducts>(_onFetchProducts);
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
}
