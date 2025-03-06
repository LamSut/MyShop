import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'cart/cart_manager.dart';
import 'products/products_overview_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    await Provider.of<CartManager>(context, listen: false).fetchCartItems();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const ProductsOverviewScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: const Center(
        child: Text(
          'Loading...',
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
      ),
    );
  }
}
