import 'package:flutter/material.dart';
import 'package:flutter_yebelo/model/product.dart';

class CartScreen extends StatelessWidget {
  final List<Product> cart;

  const CartScreen({super.key, required this.cart});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping Cart'),
      ),
      body: ListView.builder(
        itemCount: cart.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(cart[index].name),
            subtitle: Text('Quantity: ${cart[index].quantity}'),
          );
        },
      ),
    );
  }
}
