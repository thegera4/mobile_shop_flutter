import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/screens/products_overview_screen.dart';
import '/screens/product_detail_screen.dart';
import '/screens/cart_screen.dart';
import '/screens/orders_screen.dart';
import '/screens/user_products_screen.dart';
import '/screens/edit_product_screen.dart';
import '/screens/auth_screen.dart';
import '/screens/splash_screen.dart';
import '/providers/products.dart';
import '/providers/cart.dart';
import '/providers/orders.dart';
import '/providers/auth.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider( //use multiple providers
        providers: [
          ChangeNotifierProvider(create: (ctx) => Auth()),
          ChangeNotifierProxyProvider<Auth, Products>(
            create: (ctx) => Products('', '', []),
            update: (ctx, auth, previousProducts) =>
                Products(
                    auth.token ?? '',
                    auth.userId ?? '',
                    previousProducts == null ? [] : previousProducts.items
                ),
          ),
          ChangeNotifierProvider(create: (ctx) => Cart(),),
          ChangeNotifierProxyProvider<Auth, Orders>(
              create: (ctx) => Orders('', '', []),
              update: (ctx, auth, previousOrders) =>
                  Orders(
                      auth.token ?? '',
                      auth.userId ?? '',
                      previousOrders == null ? [] : previousOrders.orders
                  ),
          ),
        ],
      child: Consumer<Auth>(builder: (ctx, auth, child) =>
          MaterialApp(
            title: 'Mobile shop',
            theme: ThemeData(
              colorScheme: ColorScheme
                  .fromSwatch(primarySwatch: Colors.indigo)
                  .copyWith(secondary: Colors.deepOrange),
              fontFamily: 'Lato',
            ),
            home: auth.isAuth ?
            const ProductsOverviewScreen() : FutureBuilder(
              future: auth.tryAutoLogin(),
              builder: (ctx, authResultSnapshot) =>
                  authResultSnapshot.connectionState == ConnectionState.waiting ?
                  const SplashScreen() : const AuthScreen(),
            ),
            routes: {
              ProductDetailScreen.routeName: (ctx) => const ProductDetailScreen(),
              CartScreen.routeName: (ctx) => const CartScreen(),
              OrdersScreen.routeName: (ctx) => const OrdersScreen(),
              UserProductsScreen.routeName: (ctx) => const UserProductsScreen(),
              EditProductScreen.routeName: (ctx) => const EditProductScreen(),
            },
          ),
      )
    );
  }

}

