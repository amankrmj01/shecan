import '../../models/user/user_model.dart';

abstract class UserDataSource {
  Future<List<UserModel>> getUserData();

  Future<bool> addNewUser(UserModel newUser);

  Future<bool> checkEmailExists(String email);
}

class LocalUserDataSource implements UserDataSource {
  static const List<Map<String, dynamic>> _mockData = [
    {
      'name': 'Jessica Lee',
      'score': 15200,
      'email': 'jessica.lee@email.com',
      'password': '1234#Abc',
    },
    {
      'name': 'Michael Chen',
      'score': 12500,
      'email': 'michael.chen@email.com',
      'password': '1234#Abc',
    },
    {
      'name': 'David Rodriguez',
      'score': 9800,
      'email': 'david.rodriguez@email.com',
      'password': '1234#Abc',
    },
    {
      'name': 'Alex ',
      'score': 5000,
      'email': 'alex@email.com',
      'password': '1234#Abc',
    },
    {
      'name': 'Emily White',
      'score': 4500,
      'email': 'emily.white@email.com',
      'password': '1234#Abc',
    },
    {
      'name': 'Sarah Johnson',
      'score': 4200,
      'email': 'sarah.johnson@email.com',
      'password': '1234#Abc',
    },
    {
      'name': 'Tom Wilson',
      'score': 3800,
      'email': 'tom.wilson@email.com',
      'password': '1234#Abc',
    },
    {
      'name': 'Maria Garcia',
      'score': 3500,
      'email': 'maria.garcia@email.com',
      'password': '1234#Abc',
    },
  ];

  @override
  Future<List<UserModel>> getUserData() async {
    await Future.delayed(const Duration(milliseconds: 800));

    final models = _mockData.map((data) => UserModel.fromJson(data)).toList();

    models.sort();

    return models;
  }

  @override
  Future<bool> addNewUser(UserModel newUser) async {
    await Future.delayed(const Duration(milliseconds: 800));
    _mockData.add({
      'name': newUser.name,
      'score': newUser.score,
      'email': newUser.email,
      'password': newUser.password,
    });
    return true;
  }

  @override
  Future<bool> checkEmailExists(String email) async {
    await Future.delayed(const Duration(milliseconds: 800));
    return _mockData.any((user) => user['email'] == email);
  }
}
