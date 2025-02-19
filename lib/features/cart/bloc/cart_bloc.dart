import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:mini_product_catalog_app/features/cart/domain/entities/cart_entity.dart';
import 'cart_event.dart';
import 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final Box<CartItem> cartBox;

  CartBloc(this.cartBox) : super(CartInitial()) {
    on<CartLoading>(_onLoadCart);
    on<AddToCart>(_onAddToCart);
    on<RemoveFromCart>(_onRemoveFromCart);
    on<ClearCart>(_onClearCart);
  }

  void _onLoadCart(CartLoading event, Emitter<CartState> emit) {
    emit(CartLoaded(cartBox.values.toList()));
  }

  void _onAddToCart(AddToCart event, Emitter<CartState> emit) {
    final product = event.product;
    final cartItem = cartBox.get(product.id);

    if (cartItem != null) {
      final updatedItem = cartItem.copyWith(quantity: cartItem.quantity + 1);
      cartBox.put(product.id, updatedItem);
    } else {
      final newItem = CartItem(
        id: product.id,
        title: product.title,
        price: product.price,
        image: product.image,
        quantity: 1,
      );
      cartBox.put(product.id, newItem);
    }

    emit(CartLoaded(cartBox.values.toList()));
  }

  void _onRemoveFromCart(RemoveFromCart event, Emitter<CartState> emit) {
    final cartItem = cartBox.get(event.item.id);

    if (cartItem != null) {
      if (cartItem.quantity > 1) {
        final updatedItem = cartItem.copyWith(quantity: cartItem.quantity - 1);
        cartBox.put(event.item.id, updatedItem);
      } else {
        cartBox.delete(event.item.id);
      }
    }

    emit(CartLoaded(cartBox.values.toList()));
  }

  void _onClearCart(ClearCart event, Emitter<CartState> emit) {
    cartBox.clear();
    emit(CartLoaded([]));
  }
}
