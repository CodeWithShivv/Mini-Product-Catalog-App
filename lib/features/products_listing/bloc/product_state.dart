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
}

class ProductLoaded extends ProductState {
  final List<Product> products;
  ProductLoaded(this.products);
}
