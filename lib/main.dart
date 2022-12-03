import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/screens/products_overview_screen.dart';
import '/screens/product_detail_screen.dart';
import './providers/products.dart';
import './providers/cart.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider( //use multiple providers
        providers: [
          ChangeNotifierProvider(
            create: (ctx) => Products(), //avoid bugs and efficiency
          ),
          ChangeNotifierProvider(
            create: (ctx) => Cart(),
          ),
        ],
      child: MaterialApp(
        title: 'Mobile shop',
        theme: ThemeData(
          colorScheme: ColorScheme
              .fromSwatch(primarySwatch: Colors.indigo)
              .copyWith(secondary: Colors.deepOrange),
          fontFamily: 'Lato',
        ),
        home: const ProductsOverviewScreen(),
        routes: {
          ProductDetailScreen.routeName: (ctx) => const ProductDetailScreen(),
        },
      ),
    );
  }

}

