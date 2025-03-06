import 'package:flutter/foundation.dart';
import '../../models/cart_item.dart';
import '../../models/order_item.dart';
import '../../services/orders_service.dart';

class OrdersManager with ChangeNotifier {
  final OrdersService _ordersService = OrdersService();
  List<OrderItem> _orders = [];

  int get orderCount => _orders.length;
  List<OrderItem> get orders => [..._orders];

  Future<void> fetchOrders() async {
    try {
      final fetchedOrders = await _ordersService.fetchOrders();
      _orders = fetchedOrders;
      notifyListeners();
    } catch (error) {
      debugPrint('Error fetching orders: $error');
    }
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final newOrder = OrderItem(
      id: null,
      amount: total,
      products: cartProducts,
      dateTime: DateTime.now(),
    );

    try {
      final addedOrder = await _ordersService.addOrder(newOrder);
      if (addedOrder != null) {
        _orders.insert(0, addedOrder);
        notifyListeners();
      } else {
        debugPrint('Failed to add order via the service.');
      }
    } catch (error) {
      debugPrint('Error adding order: $error');
    }
  }
}
