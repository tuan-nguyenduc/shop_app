
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';
import '../widgets/product_item.dart';
import '../providers/product.dart';
import '../widgets/products_grid.dart';

enum FilterOption {
  Favorites,
  All,
}
class ProductOverViewScreen extends StatefulWidget {
  @override
  State<ProductOverViewScreen> createState() => _ProductOverViewScreenState();
}

class _ProductOverViewScreenState extends State<ProductOverViewScreen> {
  var _showFavoriteOnly = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MyShop'),
        actions: [
          PopupMenuButton(
            onSelected: (FilterOption selectedValue) {
              setState(() {
                if(selectedValue == FilterOption.Favorites) {
                _showFavoriteOnly = true;
              } else {
                _showFavoriteOnly = false;
              }
              });
              
            },
            icon: Icon(
              Icons.more_vert,
            ),
            itemBuilder: (_) => [
              PopupMenuItem(child: Text('Only Favorites'), value: FilterOption.Favorites),
              PopupMenuItem(child: Text('Show All'), value: FilterOption.All),
            ],
          ),
        ],
      ),
      body: ProductsGrid(_showFavoriteOnly),
    );
  }
}
