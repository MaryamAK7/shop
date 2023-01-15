import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';
import '../screens/cart_screen.dart';
import 'badge.dart';


class CartIcon extends StatelessWidget {
  const CartIcon({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Consumer<Cart>(
          builder: ((_, cartData, ch) => Badge(
                value: cartData.itemCount.toString(),
                child: ch!,
              )),
          child: IconButton(
            onPressed: () {
              Navigator.pushNamed(context, CartScreen.routeName);
            },
            icon: const Icon(Icons.shopping_cart),
          ),
        ),
      ],
    );
  }
}
