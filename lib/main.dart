import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'ui/screens.dart';
import 'ui/shared/navigation_utils.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => ProductsManager()),
        ChangeNotifierProvider(create: (ctx) => CartManager()),
        ChangeNotifierProvider(create: (ctx) => OrdersManager()),
        ChangeNotifierProvider(create: (ctx) => AuthManager()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: const Color.fromARGB(255, 0, 80, 100),
      secondary: const Color.fromARGB(255, 240, 120, 150),
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

    return Consumer<AuthManager>(
      builder: (ctx, authManager, child) {
        return MaterialApp(
          title: 'MyShop',
          debugShowCheckedModeBanner: false,
          theme: themeData,
          home: authManager.isAuth
              ? const SafeArea(child: ProductsOverviewScreen())
              : FutureBuilder(
                  future: authManager.tryAutoLogin(),
                  builder: (ctx, snapshot) {
                    return snapshot.connectionState == ConnectionState.waiting
                        ? const SafeArea(child: SplashScreen())
                        : const SafeArea(child: AuthScreen());
                  },
                ),
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
                page = SafeArea(
                  child: Consumer<ProductsManager>(
                    builder: (context, productsManager, _) =>
                        ProductDetailScreen(
                      productsManager.findById(productId)!,
                    ),
                  ),
                );
                return createRoute(page);
              case EditProductScreen.routeName:
                final productId = settings.arguments as String?;
                page = SafeArea(
                  child: Consumer<ProductsManager>(
                    builder: (context, productsManager, _) => EditProductScreen(
                      productId != null
                          ? productsManager.findById(productId)
                          : null,
                    ),
                  ),
                );
                return createRoute(page);
              default:
                return null;
            }
            return createRoute(page); // Apply slide transition
          },
        );
      },
    );
  }
}
