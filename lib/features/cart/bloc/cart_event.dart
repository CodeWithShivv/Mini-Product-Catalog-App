// cart_event.dart
import 'package:equatable/equatable.dart';
import 'package:mini_product_catalog_app/features/cart/domain/entities/cart_entity.dart';
import 'package:mini_product_catalog_app/features/products_listing/domain/entities/product.dart';

abstract class CartEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class CartLoading extends CartEvent {}

class AddToCart extends CartEvent {
  final Product product;
  AddToCart(this.product);
}

class RemoveFromCart extends CartEvent {
  final CartItem item;
  RemoveFromCart(this.item);
}

class ClearCart extends CartEvent {}

