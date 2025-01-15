import 'package:flutter/material.dart';
// import 'ui/products/products_manager.dart';
// import 'ui/products/product_detail_screen.dart';
import 'ui/products/products_overview_screen.dart';
// import 'ui/products/user_products_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: Color.fromARGB(255, 0, 120, 140),
      secondary: Color.fromARGB(255, 255, 100, 140),
      surface: Colors.white,
      surfaceTint: Colors.grey[200],
    );

    return MaterialApp(
      title: 'MyShop',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Lato',
        colorScheme: colorScheme,
        appBarTheme: AppBarTheme(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          shadowColor: colorScheme.shadow,
          elevation: 4,
        ),
      ),
      // Set Homepage to ProductDetailScreen
      home: SafeArea(
        child: ProductsOverviewScreen(),
      ),
    );
  }
}
