import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/order.dart';

import '../widgets/app_drawer.dart';
import '../widgets/order_item.dart';

class OrdersScreen extends StatelessWidget {
  static String routeName = '/orders';

  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Your Orders')),
      drawer: const AppDrawer(),
      body: FutureBuilder(
        future: Provider.of<Order>(context, listen: false).getOrders(),
        builder: ((context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (snapshot.error != null) {
              return const Center(
                child: Text('Something went wrong!'),
              );
            } else {
              return Consumer<Order>(
                builder: (c, order, _) {
                  return Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemBuilder: ((ctx, index) {
                            return OrderItemCard(order.orders[index]);
                          }),
                          itemCount: order.orders.length,
                        ),
                      )
                    ],
                  );
                },
              );
            }
          }
        }),
      ),
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// import '../providers/order.dart'; 
// import '../widgets/order_item.dart';
// import '../widgets/app_drawer.dart';

// class OrdersScreen extends StatelessWidget {
//   static const routeName = '/orders';

//   const OrdersScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     print('building orders');
//     // final orderData = Provider.of<Orders>(context);
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Your Orders'),
//       ),
//       drawer: AppDrawer(),
//       body: FutureBuilder(
//         future: Provider.of<Order>(context, listen: false).getOrders(),
//         builder: (ctx, dataSnapshot) {
//           if (dataSnapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           } else {
//             if (dataSnapshot.error != null) {
//               // ...
//               // Do error handling stuff
//               return Center(
//                 child: Text('An error occurred!'),
//               );
//             } else {
//               return Consumer<Order>(
//                 builder: (ctx, orderData, child) => ListView.builder(
//                       itemCount: orderData.orders.length,
//                       itemBuilder: (ctx, i) => OrderItemCard(orderData.orders[i]),
//                     ),
//               );
//             }
//           }
//         },
//       ),
//     );
//   }
// }
