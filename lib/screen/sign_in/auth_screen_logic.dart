import 'package:emed/data/repository/auth_repository.dart';
import 'package:emed/data/service_locator.dart';
import 'package:flutter/foundation.dart';

class AuthScreenLogic {
  AuthRepository authRepository = serviceLocator<AuthRepository>();

  loginWithEmailAndPass(
      {@required email,
      @required password,
      Function successHandler,
      Function failureHandler}) async {
    final loginSuccess = await authRepository.loginWithEmailAndPassword(
        email: email, password: password);
    if (loginSuccess) {
      if (successHandler != null) {
        successHandler();
      }
    } else {
      if (failureHandler != null) {
        failureHandler();
      }
    }
  }
}
