import '../../models/cart_item.dart';
import '../../models/order_item.dart';

class OrdersManager {
  final List<OrderItem> _orders = [
    OrderItem(
      id: 'o1',
      amount: 59.98,
      products: [
        CartItem(
          id: 'ci1',
          title: 'Red Shirt',
          imageUrl:
              'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1718578_1280.jpg',
          price: 29.99,
          quantity: 2,
        ),
      ],
      dateTime: DateTime.now(),
    ),
  ];

  int get orderCount {
    return _orders.length;
  }

  List<OrderItem> get orders {
    return [..._orders];
  }
}
