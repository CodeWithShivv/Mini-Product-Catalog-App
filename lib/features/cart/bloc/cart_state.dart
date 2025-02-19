import 'package:equatable/equatable.dart';
import 'package:mini_product_catalog_app/features/cart/domain/entities/cart_entity.dart';

abstract class CartState extends Equatable {
  @override
  List<Object?> get props => [];
}

class CartInitial extends CartState {}

class CartLoaded extends CartState {
  final List<CartItem> cartItems;

  CartLoaded(this.cartItems);

  double get totalPrice =>
      cartItems.fold(0, (sum, item) => sum + (item.price * item.quantity));

  @override
  List<Object?> get props => [cartItems, totalPrice];
}
