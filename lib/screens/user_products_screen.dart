import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/screens/edit_product_screen.dart';

import '../providers/products_provider.dart';
import '../widgets/app_drawer.dart';
import '../widgets/user_product_item.dart';

class UserProductsScreen extends StatelessWidget {
  static String routeName = '/userProduct';

  const UserProductsScreen({super.key});

  Future<void> refreshProducts(BuildContext context) async {
    await Provider.of<ProductsProvider>(context, listen: false)
        .getProducts(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your products'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.routeName);
            },
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: FutureBuilder(
        future: refreshProducts(context),
        builder: ((context, snapshot) {
          return snapshot.connectionState == ConnectionState.waiting
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : RefreshIndicator(
                  onRefresh: () => refreshProducts(context),
                  child: Consumer<ProductsProvider>(
                    builder: (context, productData, child) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListView.builder(
                          itemBuilder: ((context, index) {
                            return Column(
                              children: [
                                const SizedBox(height: 20),
                                UserProductItem(productData.items[index]),
                                const Divider()
                              ],
                            );
                          }),
                          itemCount: productData.items.length,
                        ),
                      );
                    },
                  ),
                );
        }),
      ),
      drawer: const AppDrawer(),
    );
  }
}
