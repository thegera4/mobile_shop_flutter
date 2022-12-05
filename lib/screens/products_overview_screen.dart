import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/screens/cart_screen.dart';
import '/providers/cart.dart';
import '/providers/products.dart';
import '/widgets/products_grid.dart';
import '/widgets/badge.dart';
import '/widgets/app_drawer.dart';

enum FilteredOptions {
  favorites,
  all,
}

class ProductsOverviewScreen extends StatefulWidget {
  const ProductsOverviewScreen({Key? key}) : super(key: key);

  @override
  State<ProductsOverviewScreen> createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {

  var _showOnlyFavorites = false;
  var _isInit = true;
  var _isLoading = false;

  @override
  void initState() {
    //Provider.of<Products>(context, listen: false).fetchAndSetProducts(); WONT WORK
   /* Future.delayed(Duration.zero).then((_) {
      Provider.of<Products>(context, listen: false).fetchAndSetProducts();
    });*/ //option 1 to fetch data from server
    super.initState();
  }

  @override
  void didChangeDependencies() { //option 2 to fetch data from server
    if(_isInit){
      setState(() {
        _isLoading = true;
      });
      Provider.of<Products>(context).fetchAndSetProducts().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mobile Shop'),
        actions: [
          Consumer<Cart>(
            builder: (ctx, cart, child) => Badge(
              value: cart.itemCount.toString(),
              key: const ValueKey('badge'),
              color: Colors.red,
              child: child!,
            ),
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
              icon: const Icon(Icons.shopping_cart),
            ),
          ),
          PopupMenuButton(
            onSelected: (FilteredOptions selectedValue) {
              setState(() {
                if (selectedValue == FilteredOptions.favorites) {
                  _showOnlyFavorites = true;
                } else {
                  _showOnlyFavorites = false;
                }
              });
            },
            icon: const Icon(Icons.more_vert),
            itemBuilder: (_) => [
              const PopupMenuItem(
                value: FilteredOptions.favorites,
                child: Text('Only Favorites'),
              ),
              const PopupMenuItem(
                value: FilteredOptions.all,
                child: Text('Show All'),
              ),
            ],
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: _isLoading ?
        const Center(child: CircularProgressIndicator(),) :
        ProductsGrid(showFavs: _showOnlyFavorites),
    );
  }
}
