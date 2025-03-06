import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'products_grid.dart';
import 'products_manager.dart';
import '../cart/cart_manager.dart';
import '../cart/cart_screen.dart';
import '../shared/app_drawer.dart';
import '../shared/icon_utils.dart';

enum FilterOptions { favorites, all }

class ProductsOverviewScreen extends StatefulWidget {
  const ProductsOverviewScreen({super.key});

  @override
  State<ProductsOverviewScreen> createState() => ProductsOverviewScreenState();
}

class ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var _currentFilter = FilterOptions.all;
  late Future<void> _fetchData;

  @override
  void initState() {
    super.initState();
    _fetchData = _initializeData();
  }

  Future<void> _initializeData() async {
    await Future.wait([
      context.read<ProductsManager>().fetchProducts(),
      context.read<CartManager>().fetchCartItems(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MyShop'),
        actions: <Widget>[
          ProductFilterMenu(
            currentFilter: _currentFilter,
            onFilterSelected: (filter) {
              setState(() {
                _currentFilter = filter;
              });
            },
          ),
          ShoppingCartButton(
            onPressed: () {
              Navigator.of(context).pushNamed(CartScreen.routeName);
            },
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: FutureBuilder(
        future: _fetchData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return ProductsGrid(_currentFilter == FilterOptions.favorites);
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}

class ProductFilterMenu extends StatelessWidget {
  const ProductFilterMenu({
    super.key,
    this.currentFilter,
    this.onFilterSelected,
  });

  final FilterOptions? currentFilter;
  final void Function(FilterOptions selectedValue)? onFilterSelected;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      initialValue: currentFilter,
      onSelected: onFilterSelected,
      icon: const Icon(Icons.more_vert),
      itemBuilder: (ctx) => [
        const PopupMenuItem(
          value: FilterOptions.favorites,
          child: Text('Only Favorites'),
        ),
        const PopupMenuItem(
          value: FilterOptions.all,
          child: Text('Show All'),
        ),
      ],
    );
  }
}
