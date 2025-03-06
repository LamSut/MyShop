import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/cart_item.dart';
import '../../models/product.dart';
import '../../services/cart_service.dart';

class CartManager with ChangeNotifier {
  final CartService _cartService = CartService.instance;
  Map<String, CartItem> _items = {};

  int get itemCount => _items.length;
  List<CartItem> get items => _items.values.toList();
  Iterable<MapEntry<String, CartItem>> get itemEntries => _items.entries;
  double get totalAmount => _items.values
      .fold(0.0, (sum, item) => sum + (item.price * item.quantity));

  Future<void> fetchCartItems() async {
    _items = await _cartService.fetchCartItems();
    await _loadCartFromPrefs();
    notifyListeners();
  }

  Future<void> addItem(Product product, int quantity) async {
    if (_items.containsKey(product.id)) {
      final updatedItem = _items[product.id]!
          .copyWith(quantity: _items[product.id]!.quantity + quantity);
      await _cartService.updateCartItem(updatedItem);
      _items[product.id!] = updatedItem;
    } else {
      final newItem = CartItem(
        id: 'c${DateTime.now().toIso8601String()}',
        title: product.title,
        imageUrl: product.imageUrl,
        price: product.price,
        quantity: quantity,
      );
      await _cartService.addCartItem(newItem);
      _items[product.id!] = newItem;
    }
    await _saveCartToPrefs();
    notifyListeners();
  }

  Future<void> removeItem(String productId, int quantity) async {
    if (!_items.containsKey(productId)) return;
    if (_items[productId]!.quantity > quantity) {
      final updatedItem = _items[productId]!
          .copyWith(quantity: _items[productId]!.quantity - quantity);
      await _cartService.updateCartItem(updatedItem);
      _items[productId] = updatedItem;
    } else {
      await _cartService.deleteCartItem(productId);
      _items.remove(productId);
    }
    await _saveCartToPrefs();
    notifyListeners();
  }

  Future<void> clearItem(String productId) async {
    if (_items.containsKey(productId)) {
      await _cartService.deleteCartItem(productId);
      _items.remove(productId);
      await _saveCartToPrefs();
      notifyListeners();
    }
  }

  Future<void> clearAllItems() async {
    await _cartService.clearCart();
    _items = {};
    await _saveCartToPrefs();
    notifyListeners();
  }

  Future<void> _saveCartToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final cartData = _items.map((key, item) => MapEntry(key, item.toJson()));
    await prefs.setString('cart_items', jsonEncode(cartData));
  }

  Future<void> _loadCartFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final cartString = prefs.getString('cart_items');
    if (cartString != null) {
      final Map<String, dynamic> decoded = jsonDecode(cartString);
      _items =
          decoded.map((key, item) => MapEntry(key, CartItem.fromJson(item)));
    }
  }
}
