import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/helpers/custom_route.dart';
import 'package:shop/providers/auth.dart';
import 'package:shop/providers/order.dart';
import 'package:shop/screens/auth_screen.dart';
import 'package:shop/screens/cart_screen.dart';
import 'package:shop/screens/edit_product_screen.dart';
import 'package:shop/screens/orders_screen.dart';
import 'package:shop/screens/splash_screen.dart';
import 'package:shop/screens/user_products_screen.dart';
import './providers/cart.dart';
import './providers/products_provider.dart';
import './screens/products_overview_screen.dart';

import './screens/product_details_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider.value(
            value: Auth(),
          ),
          ChangeNotifierProxyProvider<Auth, ProductsProvider>(
            create: (context) => ProductsProvider('','', []),
            update: (context, auth, previous) {
              return ProductsProvider(
                  auth.token,auth.userId, previous == null ? [] : previous.items);
            },
          ),
          ChangeNotifierProvider.value(
            value: Cart(),
          ),
          ChangeNotifierProxyProvider<Auth, Order>(
            create: (context) => Order('','', []),
            update: (context, auth, previous) {
              return Order(
                  auth.token, auth.userId, previous == null ? [] : previous.orders);
            },
          ),
        ],
        child: Consumer<Auth>(
          builder: (context, auth, child) {
            return MaterialApp(
                title: 'Flutter Demo',
                theme: ThemeData(
                  primaryColor: const Color.fromRGBO(96, 125, 139, 1),
                  colorScheme:
                      ColorScheme.fromSwatch(primarySwatch: Colors.blueGrey)
                          .copyWith(
                              secondary: const Color.fromRGBO(76, 175, 80, 1)),
                  fontFamily: 'Lato',
                  textTheme: Theme.of(context).textTheme.copyWith(
                      headline6: Theme.of(context)
                          .textTheme
                          .headline6
                          ?.copyWith(color: Colors.white)),
                   pageTransitionsTheme: PageTransitionsTheme(builders: {
                    TargetPlatform.android: CustomRouteTransitionBuilder(),
                    TargetPlatform.iOS: CustomRouteTransitionBuilder(),
                   })
                ),
                home:
                    auth.isAuth ? const ProductOverviewScreen() :
                    FutureBuilder(future: auth.tryAutoLogIn(),builder: ((context, snapshot) {
                      return snapshot.connectionState == ConnectionState.waiting ? const SplashScreen() : 
                     AuthScreen();
                    }),),
                    
                routes: {
                  ProductDetails.routeName: (context) => const ProductDetails(),
                  CartScreen.routeName: (context) => const CartScreen(),
                  OrdersScreen.routeName: (context) => const OrdersScreen(),
                  UserProductsScreen.routeName: (context) =>
                      const UserProductsScreen(),
                  EditProductScreen.routeName: (context) =>
                      const EditProductScreen(),
                });
          },
        ));
  }
}
