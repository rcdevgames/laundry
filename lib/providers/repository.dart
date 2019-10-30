import 'package:laundry/models/auth_model.dart';
import 'package:laundry/providers/auth_provider.dart';

class Repository {
  final authProvider = new AuthProvider();
  Future<Auth> actionLogin(String email, String password) => authProvider.actionLogin(email, password);

}

final repo = new Repository();