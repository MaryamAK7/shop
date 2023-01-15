import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/order.dart';

import '../providers/cart.dart' show Cart;
import '../widgets/cart_item.dart';

class CartScreen extends StatelessWidget {
  static String routeName = '/cart';

  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total'),
                    const Spacer(),
                    Chip(
                      label: Text(
                        '\$${cart.totalAmount}',
                        style: TextStyle(
                            color:
                                Theme.of(context).textTheme.headline6?.color),
                      ),
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                    ),
                    const OrderButton(),
                  ]),
            ),
          ),
          Expanded(
              child: ListView.builder(
            itemBuilder: ((context, index) => CartItemCard(
                cart.items.values.toList()[index],
                cart.items.keys.toList()[index])),
            itemCount: cart.items.length,
          ))
        ],
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({super.key});

  @override
  State<OrderButton> createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return TextButton(
      onPressed: (cart.items.isEmpty|| _isLoading )? null :  () async {
        setState(() {
          _isLoading = true;
        });
        try {
          await Provider.of<Order>(context, listen: false)
              .addOrder(cart.items.values.toList(), cart.totalAmount);
          cart.clear();
          setState(() {
            _isLoading = false;
          });
        } catch (error) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Something went wrong.'),
          ));
          setState(() {
            _isLoading = false;
          });
        }
      },
      child: _isLoading
          ? const CircularProgressIndicator()
          : const Text('ORDER NOW'),
    );
  }
}
