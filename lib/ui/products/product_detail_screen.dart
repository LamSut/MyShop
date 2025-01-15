import 'package:flutter/material.dart';
import '../../models/product.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen(this.product, {super.key});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Top Bar
      appBar: AppBar(
        title: Text(product.title),
        // Wishlist
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border),
            onPressed: () {
              print("Add to Wishlist");
            },
          ),
        ],
      ),
      // Body
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 300,
              width: double.infinity,
              child: Image.network(product.imageUrl, fit: BoxFit.cover),
            ),
            const SizedBox(height: 18),
            Text(
              '\$${product.price}',
              style: const TextStyle(color: Colors.grey, fontSize: 20),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              width: double.infinity,
              child: Text(
                product.description,
                textAlign: TextAlign.center,
                softWrap: true,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            const SizedBox(height: 30),
            // Quantity & Size
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 1),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    children: [
                      const Text("Size:   "),
                      DropdownButton<String>(
                        value: 'L', // Default
                        items: const [
                          DropdownMenuItem(value: 'S', child: Text('S')),
                          DropdownMenuItem(value: 'M', child: Text('M')),
                          DropdownMenuItem(value: 'L', child: Text('L')),
                          DropdownMenuItem(value: 'XL', child: Text('XL')),
                        ],
                        onChanged: (String? newValue) {
                          print("Selected Size: $newValue");
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                // Quantity
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 1),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    children: [
                      const Text("Quantity: "),
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: () {
                          print("Reduce quantity");
                        },
                      ),
                      const Text('0'),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          print("Increase quantity");
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Add to Cart
            ElevatedButton.icon(
              onPressed: () {
                print("Add to Cart");
              },
              icon: const Icon(Icons.shopping_cart),
              label: const Text("Add to Cart"),
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
