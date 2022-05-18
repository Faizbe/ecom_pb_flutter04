import 'package:ecom_pb_flutter04/pages/dashboard_page.dart';
import 'package:ecom_pb_flutter04/pages/launcher_page.dart';
import 'package:ecom_pb_flutter04/pages/login_page.dart';
import 'package:ecom_pb_flutter04/pages/new_product_page.dart';
import 'package:ecom_pb_flutter04/pages/order_details_page.dart';
import 'package:ecom_pb_flutter04/pages/order_list_page.dart';
import 'package:ecom_pb_flutter04/pages/product_details_page.dart';
import 'package:ecom_pb_flutter04/pages/product_list_page.dart';
import 'package:ecom_pb_flutter04/pages/report_page.dart';
import 'package:ecom_pb_flutter04/providers/order_provider.dart';
import 'package:ecom_pb_flutter04/providers/product_provider.dart';
import 'package:ecom_pb_flutter04/providers/user_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ProductProvider()),
        ChangeNotifierProvider(create: (context) => OrderProvider()),
        ChangeNotifierProvider(create: (context) => UserProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: LauncherPage(),
        routes: {
          LauncherPage.routeName : (context) => LauncherPage(),
          LoginPage.routeName : (context) => LoginPage(),
          DashboardPage.routeName : (context) => DashboardPage(),
          NewProductPage.routeName : (context) => NewProductPage(),
          ProductListPage.routeName : (context) => ProductListPage(),
          ProductDetailsPage.routeName : (context) => ProductDetailsPage(),
          OrderListPage.routeName : (context) => OrderListPage(),
          OrderDetailsPage.routeName : (context) => OrderDetailsPage(),
          ReportPage.routeName : (context) => ReportPage(),
        },
      ),
    );
  }
}

