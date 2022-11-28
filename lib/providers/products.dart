import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mysql_client/mysql_client.dart';
import 'dart:convert';
import '../mysql.dart';
import 'product.dart';

class Products with ChangeNotifier {
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://cdn.shopify.com/s/files/1/0245/6845/products/Besos_December0055_1024x1024.jpg?v=1421333490',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];

  // var _showFavoriteOnly = false;

  List<Product> get items {
    return [..._items];
  }

  Future<void> fetchAndSetProducts() async {
    var db = Mysql();
    final MySQLConnection conn = await db.getConnection();
    await conn.connect();
    var result = await conn.execute("select * from products");
    final List<Product> loadedProducts = [];
    for (final row in result.rows) {
      var productsMap = row.assoc();
      loadedProducts.add(Product(
        id: productsMap["productID"],
        title: productsMap["productName"],
        description: productsMap["description"],
        price: double.parse(productsMap["price"]!),
        imageUrl: productsMap["imageUrl"],
      ));
      _items = loadedProducts;
      notifyListeners();
    }
    conn.close();
  }

  List<Product> get favoriteItems {
    return _items.where((prodItem) => prodItem.isFavorite!).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  // void showFavoriteOnly() {
  //   _showFavoriteOnly = true;
  //   notifyListeners();
  // }

  // void showAll() {
  //   _showFavoriteOnly = false;
  //   notifyListeners();
  // }

  Future<void> addProduct(Product product) async {
    var db = Mysql();
    final MySQLConnection conn = await db.getConnection();
    await conn.connect();
    final res = await conn.execute(
        "INSERT INTO products (productName, imageUrl, price, description) VALUES (:productName ,:imageUrl , :price, :description)",
        {
          "productName": product.title,
          "imageUrl": product.imageUrl,
          "price": product.price,
          "description": product.description,
        });

    final newProduct = Product(
      title: product.title,
      description: product.description,
      price: product.price,
      imageUrl: product.imageUrl,
      id: res.lastInsertID.toString(),
    );
    _items.add(newProduct);
    notifyListeners();
    conn.close();
  }

  Future<void> updateProduct(String id, Product product) async {
    var db = Mysql();
    final MySQLConnection conn = await db.getConnection();
    await conn.connect();
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      var res = await conn.execute(
        "UPDATE products SET productName = :productName, imageUrl = :imageUrl, price = :price, description = :description WHERE (productID = :productID);",
        {
          "productName": product.title,
          "imageUrl": product.imageUrl,
          "price": product.price,
          "description": product.description,
          "productID": prodIndex + 1,
        },
      );
      _items[prodIndex] = product;
      notifyListeners();
    } else {
      print('Product Not found!');
    }
    conn.close();
  }

  Future<void> deleteProduct(String id) async {
    var db = Mysql();
    final MySQLConnection conn = await db.getConnection();
    await conn.connect();
    final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    var res = await conn.execute("DELETE FROM products WHERE (productID = :productID)",
    {
      "productID": existingProductIndex + 1
    }
    );
    _items.removeAt(existingProductIndex);
    notifyListeners();
    conn.close();
  }
}
