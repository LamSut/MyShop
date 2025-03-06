import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'orders_manager.dart';
import 'order_item_card.dart';
import '../shared/app_drawer.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders';
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Orders'),
      ),
      drawer: const AppDrawer(),
      body: FutureBuilder(
        future:
            Provider.of<OrdersManager>(context, listen: false).fetchOrders(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error loading orders.'));
          } else {
            return Consumer<OrdersManager>(
              builder: (ctx, ordersManager, child) {
                if (ordersManager.orderCount == 0) {
                  return const Center(child: Text('No orders found.'));
                }
                return ListView.builder(
                  itemCount: ordersManager.orderCount,
                  itemBuilder: (ctx, i) =>
                      OrderItemCard(ordersManager.orders[i]),
                );
              },
            );
          }
        },
      ),
    );
  }
}
