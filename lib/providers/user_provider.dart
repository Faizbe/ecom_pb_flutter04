
import 'package:flutter/foundation.dart';

import '../db/db_helper.dart';
import '../models/user_model.dart';

class UserProvider extends ChangeNotifier {
  List<UserModel> userList = [];
  void getAllUsers() {
    DBHelper.fetchAllUsers().listen((event) {
      userList = List.generate(event.docs.length, (index) => UserModel.fromMap(event.docs[index].data()));
      notifyListeners();
    });
  }
}