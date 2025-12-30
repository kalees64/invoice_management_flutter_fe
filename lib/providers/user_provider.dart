import 'package:flutter/material.dart';
import 'package:invoice_management_flutter_fe/models/user_model.dart';
import 'package:invoice_management_flutter_fe/services/user_service.dart';
import 'package:invoice_management_flutter_fe/store/user/user_repository.dart';

class UserProvider extends ChangeNotifier {
  List<UserModel> _users = [];

  List<UserModel> get users => _users;

  void getUsers() async {
    final res = await UserRepository(UserService()).getUsers();
    _users = res;
    notifyListeners();
  }

  void getUser(String id) async {
    final res = await UserRepository(UserService()).getUser(id);
    _users = [res];
    notifyListeners();
  }

  void addUser(UserModel user) async {
    await UserRepository(UserService()).createUser(user.toJson());
    getUsers();
  }

  void updateUser(UserModel user) async {
    await UserRepository(UserService()).updateUser(user.id!, user.toJson());
    getUsers();
  }

  void deleteUser(String id) async {
    await UserRepository(UserService()).deleteUser(id);
    getUsers();
  }
}
