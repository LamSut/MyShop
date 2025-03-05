import 'package:flutter/foundation.dart';
import '../../models/product.dart';
import '../../services/products_service.dart';

class ProductsManager with ChangeNotifier {
  final ProductsService _productsService = ProductsService();
  List<Product> _items = [];

  int get itemCount {
    return _items.length;
  }

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((item) => item.isFavorite).toList();
  }

  Product? findById(String id) {
    try {
      return _items.firstWhere((item) => item.id == id);
    } catch (error) {
      return null;
    }
  }

  Future<void> fetchProducts() async {
    _items = await _productsService.fetchProducts();
    notifyListeners();
  }

  Future<void> fetchUserProducts() async {
    _items = await _productsService.fetchProducts(
      filteredByUser: true,
    );
    notifyListeners();
  }

  Future<void> addProduct(Product product) async {
    final newProduct = await _productsService.addProduct(product);
    if (newProduct != null) {
      _items.add(newProduct);
      notifyListeners();
    }
  }

  Future<void> updateProduct(Product product) async {
    final index = _items.indexWhere((item) => item.id == product.id);
    if (index >= 0) {
      _items[index] = product;
      notifyListeners();
    }
  }

  void deleteProduct(String id) {
    final index = _items.indexWhere((item) => item.id == id);
    _items.removeAt(index);
    notifyListeners();
  }
}
