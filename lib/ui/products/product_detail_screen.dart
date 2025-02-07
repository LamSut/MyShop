import 'package:flutter/material.dart';
import '../../models/product.dart';
import '../cart/cart_screen.dart';
import '../shared/icon_utils.dart';

class ProductDetailScreen extends StatefulWidget {
  static const routeName = '/product_detail';
  const ProductDetailScreen(this.product, {super.key});

  final Product product;

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  bool isInWishlist = false; // Wishlist State
  String selectedSize = 'L'; // Size State
  int quantity = 0; // Quantity State

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Top Bar
      appBar: AppBar(
        title: Text(widget.product.title),
        actions: [
          IconButton(
            // Navigate to Home (ProductsOverviewScreen)
            icon: const Icon(Icons.home),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          // Navigate to Cart (CartScreen)
          ShoppingCartButton(
            onPressed: () {
              // Go to CartScreen
              Navigator.of(context).pushNamed(CartScreen.routeName);
            },
          ),
          // Wishlist Toggle
          IconButton(
            icon: Icon(
              isInWishlist ? Icons.favorite : Icons.favorite_border,
              color:
                  isInWishlist ? Theme.of(context).colorScheme.secondary : null,
            ),
            onPressed: () {
              setState(() {
                isInWishlist = !isInWishlist;
              });
            },
          ),
        ],
      ),
      // Body
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            const SizedBox(height: 30),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 1),
                borderRadius: BorderRadius.circular(30),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Image.network(
                  widget.product.imageUrl,
                  height: 300,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              '\$${widget.product.price}',
              style: const TextStyle(color: Colors.grey, fontSize: 20),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              width: double.infinity,
              child: Text(
                widget.product.description,
                textAlign: TextAlign.center,
                softWrap: true,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            // Quantity & Size
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Size Selector
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 14),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 1),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    children: [
                      const Text(
                        "Size: ",
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(width: 6),
                      DropdownButton<String>(
                        value: selectedSize,
                        items: const [
                          DropdownMenuItem(value: 'S', child: Text('S')),
                          DropdownMenuItem(value: 'M', child: Text('M')),
                          DropdownMenuItem(value: 'L', child: Text('L')),
                          DropdownMenuItem(value: 'XL', child: Text('XL')),
                        ],
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedSize = newValue!;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                // Quantity Selector
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 1),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    children: [
                      const Text(
                        "Quantity: ",
                        style: TextStyle(fontSize: 16),
                      ),
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: () {
                          setState(() {
                            if (quantity > 0) {
                              quantity--;
                            }
                          });
                        },
                      ),
                      Text('$quantity'),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          setState(() {
                            quantity++;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Add to Cart Button
            ElevatedButton.icon(
              onPressed: () {
                print("Add to Cart");
              },
              icon: Icon(
                Icons.shopping_cart,
                size: 30,
                color: Theme.of(context).colorScheme.secondary,
              ),
              label: Text(
                "Add to Cart",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
