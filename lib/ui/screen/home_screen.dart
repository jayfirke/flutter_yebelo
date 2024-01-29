import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_yebelo/model/product.dart';
import 'package:flutter_yebelo/ui/screen/cart_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Product> cart = [];
  List<Product> products = [];

  @override
  void initState() {
    super.initState();
    loadProducts();
  }

  Future<void> loadProducts() async {
    try {
      String data = await rootBundle.loadString('assets/products.json');

      if (data.isNotEmpty) {
        List<dynamic> jsonList = json.decode(data);
        products = jsonList.map((json) => Product(
          name: json['p_name'] ?? '',
          id: json['p_id'] ?? 0,
          cost: json['p_cost']?.toDouble() ?? 0.0,
          availability: json['p_availability'] == 1,
          details: json['p_details'] ?? '',
          category: json['p_category'] ?? '',
        )).toList();
      } else {
        print('Error: JSON data is empty.');
      }
    } catch (error) {
      print('Error loading products: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Yebelo Shopping'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                return buildProductCard(products[index]);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CartScreen(cart: cart)),
                );
              },
              child: const Icon(Icons.shopping_cart),
            ),
          )
        ],
      ),
    );
  }

  Widget buildProductCard(Product product) {
    return Card(
      margin: const EdgeInsets.all(10),
      elevation: 5,
      child: ListTile(
        title: Text(product.name),
        subtitle: Text('Category: ${product.category}'),
        trailing: Text('₹ ${product.cost.toString()}'),
        onTap: () {
          showQuantityDialog(product);
        },
      ),
    );
  }

  void showQuantityDialog(Product product) {
    showDialog(
      context: context,
      builder: (context) {
        int quantity = product.quantity;

        return AlertDialog(
          title: const Text('Enter Quantity'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  quantity = int.tryParse(value) ?? 0;
                },
                decoration: const InputDecoration(labelText: 'Quantity'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  product.quantity = quantity;
                  Navigator.pop(context);
                  showConfirmationDialog(product);
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        );
      },
    );
  }

  void showConfirmationDialog(Product product) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirmation'),
          content: Text('Product: ${product.name}\nQuantity: ${product.quantity}'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                addToCart(product);
                Navigator.pop(context);
              },
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  void addToCart(Product product) {
    setState(() {
      cart.add(product);
    });
  }
}