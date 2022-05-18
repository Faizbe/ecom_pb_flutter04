
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../auth/auth_service.dart';
import '../providers/order_provider.dart';
import '../utils/helper_functions.dart';
import 'order_details_page.dart';

class OrderListPage extends StatefulWidget {
  static const String routeName = '/user_orders';

  const OrderListPage({Key? key}) : super(key: key);

  @override
  _OrderListPageState createState() => _OrderListPageState();
}

class _OrderListPageState extends State<OrderListPage> {
  late OrderProvider _orderProvider;

  @override
  void didChangeDependencies() {
    _orderProvider = Provider.of<OrderProvider>(context);
    _orderProvider.getOrders();
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Orders'),
      ),
      body: ListView.builder(
        itemCount: _orderProvider.orderList.length,
        itemBuilder: (context, index) {
          final order = _orderProvider.orderList[index];
          return ListTile(
            onTap: () => Navigator.pushNamed(context, OrderDetailsPage.routeName, arguments: order.orderId),
            title: Text(getFormattedDate(order.timestamp.millisecondsSinceEpoch, 'dd/MM/yyyy hh:mm a')),
            trailing: Text(order.orderStatus),
          );
        },
      ),
    );
  }
}
