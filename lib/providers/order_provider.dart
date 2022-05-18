

import 'package:flutter/foundation.dart';

import '../db/db_helper.dart';
import '../models/cart_model.dart';
import '../models/order_constants_model.dart';
import '../models/order_model.dart';

class OrderProvider with ChangeNotifier {
  OrderConstantsModel orderConstantsModel = OrderConstantsModel();
  List<OrderModel> orderList = [];
  List<CartModel> orderDetailsList = [];

  void getOrderConstants() async {
    DBHelper.fetchOrderConstants().listen((event) {
      if(event.exists) {
        orderConstantsModel = OrderConstantsModel.fromMap(event.data()!);
        notifyListeners();
      }
    });
  }

  void getOrderDetails(String orderId) async {
    DBHelper.fetchAllOrderDetails(orderId).listen((event) {
      orderDetailsList = List.generate(event.docs.length, (index) => CartModel.fromMap(event.docs[index].data()));
      notifyListeners();
    });
  }

  void getOrders() async {
    DBHelper.fetchAllOrders().listen((event) {
      orderList = List.generate(event.docs.length, (index) => OrderModel.fromMap(event.docs[index].data()));
      notifyListeners();
    });
  }

  void getUserOrders(String userId) async {
    DBHelper.fetchAllOrdersByUser(userId).listen((event) {
      orderList = List.generate(event.docs.length, (index) => OrderModel.fromMap(event.docs[index].data()));
      notifyListeners();
    });
  }
}