import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_product_catalog_app/features/cart/bloc/cart_bloc.dart';
import 'package:mini_product_catalog_app/features/cart/bloc/cart_event.dart';
import 'package:mini_product_catalog_app/features/cart/bloc/cart_state.dart';
import 'package:mini_product_catalog_app/features/cart/domain/entities/cart_entity.dart';
import 'package:mini_product_catalog_app/features/cart/presentation/widgets/empty_cart.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: IconButton(
              icon: const Icon(Icons.delete_forever),
              onPressed: () {
                context.read<CartBloc>().add(ClearCart());
              },
            ),
          ),
        ],
      ),
      body: BlocSelector<CartBloc, CartState, List<CartItem>>(
        selector: (state) {
          if (state is CartLoaded) {
            return state.cartItems;
          }
          return [];
        },
        builder: (context, cartItems) {
          if (cartItems.isEmpty) {
            return const EmptyCart();
          }

          return ListView.builder(
            itemCount: cartItems.length,
            itemBuilder: (context, index) {
              final item = cartItems[index];

              return Dismissible(
                key: Key(item.id.toString()), // Unique key
                direction: DismissDirection.endToStart, // Swipe left to delete
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                onDismissed: (_) {
                  context.read<CartBloc>().add(RemoveFromCart(item));
                },
                child: Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: ListTile(
                    leading: CachedNetworkImage(
                      imageUrl: item.image,
                      width: 50,
                      height: 50,
                      fit: BoxFit.fill,
                    ),
                    title: Text(
                      item.title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      '₹${item.price.toStringAsFixed(2)} x ${item.quantity}',
                      style: const TextStyle(color: Colors.green),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.remove_shopping_cart,
                          color: Colors.red),
                      onPressed: () {
                        context.read<CartBloc>().add(RemoveFromCart(item));
                      },
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state is CartLoaded) {
            return BottomAppBar(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Total:",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "\₹${state.totalPrice.toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
