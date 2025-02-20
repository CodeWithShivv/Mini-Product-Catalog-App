import 'package:equatable/equatable.dart';
import 'package:mini_product_catalog_app/features/products_listing/domain/entities/product.dart';

abstract class ProductState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class ProductError extends ProductState {
  final String message;

  ProductError(this.message);

  @override
  List<Object?> get props => [message];
}

class ProductSearchResults extends ProductState {
  final List<Product> searchResults;
  ProductSearchResults(this.searchResults);

  @override
  List<Object?> get props => [searchResults];
}

class ProductLoaded extends ProductState {
  final List<Product> products;
  final bool hasMore;
  final bool isPaginating;

  ProductLoaded({
    required this.products,
    this.hasMore = true,
    this.isPaginating = false,
  });

  @override
  List<Object?> get props => [products, hasMore, isPaginating];
}

class ProductPaginating extends ProductState {
  final List<Product> products;
  final bool hasMore;

  ProductPaginating({required this.products, required this.hasMore});
}
