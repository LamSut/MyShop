import 'package:flutter/material.dart';
import '../cart/cart_manager.dart';

class ShoppingCartButton extends StatelessWidget {
  const ShoppingCartButton({super.key, this.onPressed});
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Badge.count(
        count: CartManager().productCount,
        child: const Icon(Icons.shopping_cart),
      ),
      onPressed: onPressed,
    );
  }
}
