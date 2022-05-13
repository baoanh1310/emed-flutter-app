import 'dart:async';

import 'auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  @override
  Future<bool> loginWithEmailAndPassword({email, password}) async {
    await Future.delayed(Duration(milliseconds: 500));
    bool success = true;
    return success;
  }
}