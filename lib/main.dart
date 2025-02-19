import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'ui/screens.dart';
import 'ui/shared/navigation_utils.dart';

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

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => ProductsManager(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => CartManager(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => OrdersManager(),
        ),
      ],
      child: MaterialApp(
        title: 'MyShop',
        debugShowCheckedModeBanner: false,
        theme: themeData,
        home: const ProductsOverviewScreen(),
        onGenerateRoute: (settings) {
          Widget page;

          switch (settings.name) {
            case CartScreen.routeName:
              page = const SafeArea(child: CartScreen());
              break;
            case OrdersScreen.routeName:
              page = const SafeArea(child: OrdersScreen());
              break;
            case UserProductsScreen.routeName:
              page = const SafeArea(child: UserProductsScreen());
              break;
            case ProductDetailScreen.routeName:
              final productId = settings.arguments as String;
              return MaterialPageRoute(
                builder: (ctx) => SafeArea(
                  child: ProductDetailScreen(
                    ctx.read<ProductsManager>().findById(productId)!,
                  ),
                ),
              );
            case EditProductScreen.routeName:
              final productId = settings.arguments as String?;
              return MaterialPageRoute(
                builder: (ctx) => SafeArea(
                  child: EditProductScreen(
                    productId != null
                        ? ctx.read<ProductsManager>().findById(productId)
                        : null,
                  ),
                ),
              );
            default:
              return null;
          }
          return createRoute(page); // Apply slide transition
        },
      ),
    );
  }
}
