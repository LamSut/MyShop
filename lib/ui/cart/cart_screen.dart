import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../orders/orders_manager.dart';
import 'cart_manager.dart';
import 'cart_item_card.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
      ),
      body: FutureBuilder(
        future: context.read<CartManager>().fetchCartItems(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return Consumer<CartManager>(
              builder: (ctx, cart, child) => Column(
                children: <Widget>[
                  CartSummary(
                    cart: cart,
                    onOrderNowPressed: cart.totalAmount <= 0
                        ? null
                        : () async {
                            await context.read<OrdersManager>().addOrder(
                                  cart.items,
                                  cart.totalAmount,
                                );
                            await cart.clearAllItems();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Ordered successfully!'),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          },
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: CartItemList(cart),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}

class CartItemList extends StatelessWidget {
  const CartItemList(this.cart, {super.key});

  final CartManager cart;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: cart.itemCount,
      itemBuilder: (ctx, index) {
        final entry = cart.itemEntries.elementAt(index);
        return CartItemCard(
          productId: entry.key,
          cartItem: entry.value,
        );
      },
    );
  }
}

class CartSummary extends StatelessWidget {
  const CartSummary({
    super.key,
    required this.cart,
    this.onOrderNowPressed,
  });

  final CartManager cart;
  final void Function()? onOrderNowPressed;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(15),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            const Text(
              'Total',
              style: TextStyle(fontSize: 28),
            ),
            const Spacer(),
            Chip(
              label: Text(
                '\$${cart.totalAmount.toStringAsFixed(2)}',
                style: Theme.of(context).primaryTextTheme.titleLarge,
              ),
              backgroundColor: Theme.of(context).colorScheme.primary,
            ),
            TextButton(
              onPressed: onOrderNowPressed,
              style: TextButton.styleFrom(
                textStyle: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              child: const Text('ORDER NOW'),
            ),
          ],
        ),
      ),
    );
  }
}
