import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products_provider.dart'; 
import '../providers/cart.dart';
import '../providers/product.dart';

class ProductDetails extends StatelessWidget {
  static String routeName = '/product-details';
  const ProductDetails({super.key});

  @override
  Widget build(BuildContext context) {
    String productId = ModalRoute.of(context)?.settings.arguments as String;
    Product product = Provider.of<ProductsProvider>(context, listen: false)
        .findById(productId);

    return Scaffold(
 
      body: CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 350,
          pinned: true,
          title: Text(product.title) ,
          flexibleSpace: FlexibleSpaceBar( 
            background: Hero(
                tag: productId,
                child: Image.network(product.imageUrl, fit: BoxFit.fill)),
          ),
        ),
        SliverList(
          delegate: SliverChildListDelegate([
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 0),
              child: Text(
                product.title,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color: Colors.black),
              ),
            ),
            Container(
               alignment: Alignment.center,
              width: double.infinity,
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 0),
              child: Text(
                product.description,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 24, color: Colors.blueGrey),
              ),
            ),
            Container(
               alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              child: Text(
                'Only for \$${product.price}!',
                style: const TextStyle(fontSize: 24, color: Colors.green),
              ),
            ),
            Container(
              width: 200,
              alignment: Alignment.center,
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.all(50),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 10)),
                  onPressed: () {
                    Provider.of<Cart>(context, listen: false)
                        .addItem(productId, product.title, product.price);
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Item added to cart!'),
                        duration: const Duration(seconds: 2),
                        action: SnackBarAction(
                          label: 'UNDO',
                          onPressed: () {
                            Provider.of<Cart>(context, listen: false)
                                .removeSingleItem(productId);
                          },
                        ),
                      ),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        'Add to Cart',
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Icon(Icons.shopping_cart),
                    ],
                  )),
            ),
            const SizedBox(height: 800,)
          ]),
        )
      ],
    ));
  }
}
