import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'product.dart';
import '../models/http_exception.dart';

const productsUrl =
    'https://mobile-shop-flutter-default-rtdb.firebaseio.com/products.json';

class Products with ChangeNotifier{

  List<Product> _items = [];

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((item) => item.isFavorite).toList();
  }

  Product findById(String id){
    return _items.firstWhere((prod) => prod.id == id);
  }

  Future<void> fetchAndSetProducts() async {
    try {
      final response = await http.get(Uri.parse(productsUrl));
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Product> loadedProducts = [];
      if (extractedData == null) {
        return;
      }
      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(Product(
          id: prodId,
          title: prodData['title'],
          description: prodData['description'],
          price: prodData['price'],
          imageUrl: prodData['imageUrl'],
          isFavorite: prodData['isFavorite'],
        ));
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  //with async and await
  Future<void> addProduct(Product product) async {
    final url = Uri.parse(productsUrl);
    try {
      final response = await http.post(
          url,
          body: json.encode({
            'title': product.title,
            'description': product.description,
            'imageUrl': product.imageUrl,
            'price': product.price,
            'isFavorite': product.isFavorite,
          }),
      );
      final newProduct = Product(
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
        id: json.decode(response.body)['name'],
      );

      _items.add(newProduct);
      notifyListeners();

    } catch (e) {
      rethrow;
    }
      
  }

  //with future
 /* Future<void> addProduct(Product product) {
    final url = Uri.parse(
        'https://mobile-shop-flutter-default-rtdb.firebaseio.com/products.json'
    );
    return http.post(
        url,
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'imageUrl': product.imageUrl,
          'price': product.price,
          'isFavorite': product.isFavorite,
        })
    ).then((response) {
      final newProduct = Product(
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
        id: json.decode(response.body)['name'],
      );
      _items.add(newProduct);
      notifyListeners();
    }).catchError((error) {
      throw error;
    });

  }*/

  Future<void> updateProduct(String id, Product newProduct) async{
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if(prodIndex >= 0){
      try{
      final url = Uri.parse(
          'https://mobile-shop-flutter-default-rtdb.firebaseio.com/'
              'products/$id.json');
      await http.patch(url, body: json.encode({
        'title': newProduct.title,
        'description': newProduct.description,
        'imageUrl': newProduct.imageUrl,
        'price': newProduct.price,
      }));
      _items[prodIndex] = newProduct;
      notifyListeners();
      } catch (error){
        print(error);
        rethrow;
      }
    } else {
        print('...');
    }
  }

  Future<void> deleteProduct(String id) async { //optimistic deleting
    final url = Uri.parse(
        'https://mobile-shop-flutter-default-rtdb.firebaseio.com/'
            'products/$id.json');
    final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    Product? existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();
    final response = await http.delete(url);

    if(response.statusCode >= 400){
      _items.insert(existingProductIndex, existingProduct!); //rollback
      notifyListeners();
      throw HttpException('Could not delete product.');
    }
      existingProduct = null;

  }

}