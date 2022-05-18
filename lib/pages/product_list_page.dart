import 'package:ecom_pb_flutter04/pages/product_details_page.dart';
import 'package:ecom_pb_flutter04/providers/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductListPage extends StatefulWidget {
  static const String routeName = '/product_list';

  @override
  _ProductListPageState createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  late ProductProvider _productProvider;

  @override
  void didChangeDependencies() {
    _productProvider = Provider.of<ProductProvider>(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product List'),
      ),
      body: ListView.builder(
        itemCount: _productProvider.productList.length,
        itemBuilder: (context, index) {
          final product = _productProvider.productList[index];
          return ListTile(
            onTap: () => Navigator.pushNamed(context, ProductDetailsPage.routeName, arguments: [product.id, product.name]),
            title: Text(product.name!),
            subtitle: Text(product.category!),
            trailing: Text('BDT ${product.price}'),
          );
        },
      ),
    );
  }
}
