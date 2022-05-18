import 'package:ecom_pb_flutter04/auth/auth_service.dart';
import 'package:ecom_pb_flutter04/pages/login_page.dart';
import 'package:ecom_pb_flutter04/pages/new_product_page.dart';
import 'package:ecom_pb_flutter04/pages/order_list_page.dart';
import 'package:ecom_pb_flutter04/pages/product_list_page.dart';
import 'package:ecom_pb_flutter04/providers/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DashboardPage extends StatefulWidget {
  static const String routeName = '/dashboard';

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late ProductProvider _productProvider;

  @override
  void didChangeDependencies() {
    _productProvider = Provider.of<ProductProvider>(context, listen: false);
    _productProvider.getAllCategories();
    _productProvider.getAllProducts();
    _productProvider.getAllPurchases();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              AuthService.logout().then((_) {
                Navigator.pushReplacementNamed(context, LoginPage.routeName);
              });
            },
          )
        ],
      ),
      body: GridView.count(
        padding: const EdgeInsets.all(8),
        crossAxisCount: 2,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
        children: [
          ElevatedButton(
            style: TextButton.styleFrom(
              elevation: 2
            ),
            child: Text('ADD PRODUCT'),
            onPressed: () => Navigator.pushNamed(context, NewProductPage.routeName),
          ),
          ElevatedButton(
            style: TextButton.styleFrom(
                elevation: 2
            ),
            child: Text('VIEW PRODUCT'),
            onPressed: () => Navigator.pushNamed(context, ProductListPage.routeName),
          ),
          ElevatedButton(
            style: TextButton.styleFrom(
                elevation: 2
            ),
            child: Text('CATEGORY'),
            onPressed: () {},
          ),
          ElevatedButton(
            style: TextButton.styleFrom(
                elevation: 2
            ),
            child: Text('VIEW ORDERS'),
            onPressed: () => Navigator.pushNamed(context, OrderListPage.routeName),
          ),
          ElevatedButton(
            style: TextButton.styleFrom(
                elevation: 2
            ),
            child: Text('VIEW REPORTS'),
            onPressed: () {},
          ),
          ElevatedButton(
            style: TextButton.styleFrom(
                elevation: 2
            ),
            child: Text('MANAGE USERS'),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
