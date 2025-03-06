import 'package:flutter/material.dart';
import '../models/order_item.dart';
import 'pocketbase_client.dart';

class OrdersService {
  Future<List<OrderItem>> fetchOrders({bool filteredByUser = false}) async {
    final List<OrderItem> orders = [];
    try {
      final pb = await getPocketbaseInstance();
      final orderModels = await pb.collection('orders').getFullList();
      for (final orderModel in orderModels) {
        orders.add(OrderItem.fromJson(orderModel.toJson()));
      }
      return orders;
    } catch (error) {
      return orders;
    }
  }

  Future<OrderItem?> addOrder(OrderItem order) async {
    try {
      final pb = await getPocketbaseInstance();
      final payload = order.copyWith(id: null).toJson();
      payload.remove('id');
      final orderModel = await pb.collection('orders').create(
            body: payload,
          );
      return order.copyWith(id: orderModel.id);
    } catch (error) {
      debugPrint('OrdersService.addOrder error: $error');
      return null;
    }
  }
}
