import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product.dart';
import '../providers/products_provider.dart';
import '../screens/edit_product_screen.dart';

class UserProductItem extends StatelessWidget {
  final Product product;

  const UserProductItem(this.product, {super.key});

  @override
  Widget build(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    return ListTile(
      leading: CircleAvatar(backgroundImage: NetworkImage(product.imageUrl)),
      title: Text(product.title),
      trailing: SizedBox(
        width: 100,
        child: Row(
          children: [
            IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(EditProductScreen.routeName,
                      arguments: product.id);
                },
                icon: Icon(Icons.edit, color: Theme.of(context).primaryColor)),
            IconButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: ((ctx) {
                        return AlertDialog(
                          title: const Text('Are you sure?',
                              style: TextStyle(color: Colors.black)),
                          content: const Text(
                              'Are you sure you want to delete this product?'),
                          actions: [
                            TextButton(
                              child: const Text('No'),
                              onPressed: () {
                                Navigator.of(ctx).pop(false);
                              },
                            ),
                            TextButton(
                              child: const Text('Yes'),
                              onPressed: () async {
                                Navigator.of(ctx).pop(true);
                                try {
                                  await Provider.of<ProductsProvider>(context,
                                          listen: false)
                                      .deleteProduct(product.id!);
                                } catch (error) {
                                  scaffold.showSnackBar(
                                      const SnackBar(
                                          content: Text('Deleting failed')));
                                }
                              },
                            ),
                          ],
                        );
                      }));
                },
                icon: Icon(Icons.delete, color: Theme.of(context).errorColor))
          ],
        ),
      ),
    );
  }
}
