import 'package:flutter/cupertino.dart';

abstract class AuthRepository {
  Future<bool> loginWithEmailAndPassword({@required email, @required password});
}