import 'package:flutter/material.dart';
import 'ui/screens.dart';

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

    final themeData = ThemeData(
      fontFamily: 'Lato',
      colorScheme: colorScheme,
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        shadowColor: colorScheme.shadow,
        elevation: 4,
      ),
      dialogTheme: DialogTheme(
        titleTextStyle: TextStyle(
          color: colorScheme.onSurface,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        contentTextStyle: TextStyle(
          color: colorScheme.onSurface,
          fontSize: 20,
        ),
      ),
    );

    return MaterialApp(
      title: 'MyShop',
      debugShowCheckedModeBanner: false,
      theme: themeData,
      home: const ProductsOverviewScreen(),
      // Routes parameters are often used to declare
// routes without parameters.
      routes: {
        CartScreen.routeName: (ctx) => const SafeArea(
              child: CartScreen(),
            ),
        OrdersScreen.routeName: (ctx) => const SafeArea(
              child: OrdersScreen(),
            ),
        UserProductsScreen.routeName: (ctx) => const SafeArea(
              child: UserProductsScreen(),
            ),
      },
      // onGenerateRoute will be called when the requested route is not found
      // in the routes parameter above. Usually used to pass parameters
      // or customize the transition effect.
      onGenerateRoute: (settings) {
        if (settings.name == ProductDetailScreen.routeName) {
          final productId = settings.arguments as String;
          return MaterialPageRoute(
            settings: settings,
            builder: (ctx) {
              return SafeArea(
                child: ProductDetailScreen(
                  ProductsManager().findById(productId)!,
                ),
              );
            },
          );
        }
        return null;
      },
    );
  }
}
