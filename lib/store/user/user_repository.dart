import 'package:invoice_management_flutter_fe/models/user_model.dart';
import 'package:invoice_management_flutter_fe/services/user_service.dart';

class UserRepository {
  UserService userService;

  UserRepository(this.userService);

  Future<List<UserModel>> getUsers() async {
    final res = await userService.getUsers();
    return (res.data as List).map((e) => UserModel.fromJson(e)).toList();
  }

  Future<UserModel> getUser(String id) async {
    final res = await userService.getUser(id);
    return UserModel.fromJson(res.data);
  }

  Future<UserModel> createUser(Map<String, dynamic> data) async {
    final res = await userService.createUser(data);
    return UserModel.fromJson(res.data);
  }

  Future<UserModel> updateUser(String id, Map<String, dynamic> data) async {
    final res = await userService.updateUser(id, data);
    return UserModel.fromJson(res.data);
  }

  Future<void> deleteUser(String id) async {
    await userService.deleteUser(id);
  }
}
