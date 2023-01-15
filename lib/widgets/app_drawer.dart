import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/helpers/custom_route.dart';
import 'package:shop/providers/auth.dart';
import 'package:shop/screens/user_products_screen.dart';

import '../screens/orders_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: Container(
                padding: const EdgeInsets.all(10),
                child: const Text('Hi friends!')),
            automaticallyImplyLeading: false,
          ),
          Container(
            padding: const EdgeInsets.all(10),
            child: ListTile(
              onTap: () {
                Navigator.pushReplacementNamed(context, '/');
              },
              leading: const Icon(Icons.shop),
              title: const Text('Shop'),
            ),
          ),
          const Divider(),
          Container(
            padding: const EdgeInsets.all(10),
            child: ListTile(
              onTap: () {
                Navigator.pushNamed(context, OrdersScreen.routeName);
                // Navigator.of(context).pushReplacement(CustomRoute(builder: (ctx)=>const OrdersScreen() ));
              },
              leading: const Icon(Icons.payment),
              title: const Text('Orders'),
            ),
          ),
          const Divider(),
          Container(
            padding: const EdgeInsets.all(10),
            child: ListTile(
              onTap: () {
                Navigator.pushNamed(context, UserProductsScreen.routeName);
              },
              leading: const Icon(Icons.edit),
              title: const Text('Manage Product'),
            ),
          ),
          const Divider(),
          Container(
            padding: const EdgeInsets.all(10),
            child: ListTile(
              onTap: () async {
                Navigator.of(context).pop();
                await Provider.of<Auth>(context, listen: false).logout();
              },
              leading: const Icon(Icons.exit_to_app),
              title: const Text('Log out'),
            ),
          ),
          const Divider(),
        ],
      ),
    );
  }
}
