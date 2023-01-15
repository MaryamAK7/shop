import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/widgets/app_drawer.dart';

import '../providers/products_provider.dart';
import '../widgets/cart_icon.dart';
import '../widgets/product_item.dart';

enum FilterOptions {
  favorites,
  all,
}

class ProductOverviewScreen extends StatefulWidget {
  const ProductOverviewScreen({super.key});

  @override
  State<ProductOverviewScreen> createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  bool _showFavs = false;
  bool isLoading = false;

  @override
  void initState() {
    setState(() {
      isLoading = true;
    });
    Provider.of<ProductsProvider>(context, listen: false)
        .getProducts()
        .then((value) {
      setState(() {
        isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<ProductsProvider>(context);
    final products = _showFavs ? productsData.favItems : productsData.items;
  
    return RefreshIndicator(
      onRefresh: () async {
        try {
          await productsData.getProducts();
        } catch (error) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Something went wrong'),
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Shop'),
          actions: [
            PopupMenuButton(
              onSelected: (value) => {
                setState(
                  () {
                    if (value == FilterOptions.favorites) {
                      _showFavs = true;
                    } else {
                      _showFavs = false;
                    }
                  },
                )
              },
              itemBuilder: (_) => const [
                PopupMenuItem(
                  value: FilterOptions.favorites,
                  child: Text('Only Favorites'),
                ),
                PopupMenuItem(
                  value: FilterOptions.all,
                  child: Text('All'),
                ),
              ],
            ),
            const CartIcon(),
          ],
        ),
        drawer: const AppDrawer(),
        body: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : GridView.builder(
                padding: const EdgeInsets.all(10),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 3 / 3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10),
                itemBuilder: (context, index) => ChangeNotifierProvider.value(
                      value: products[index],
                      child:  ProductItem(),
                    ),
                itemCount: products.length),
      ),
    );
  }
}
