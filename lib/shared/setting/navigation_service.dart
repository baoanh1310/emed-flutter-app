// Flutter imports:
import 'package:flutter/material.dart';

class NavigationService {
  factory NavigationService() {
    if (_this == null) {
      _this = NavigationService._getInstance();
      // _this.initAdTime();
    }
    return _this;
  }

  static NavigationService _this;
  NavigationService._getInstance();

  GlobalKey<NavigatorState> _navigationKey = GlobalKey<NavigatorState>();

  GlobalKey<NavigatorState> get navigationKey => _navigationKey;

  void pop<T extends Object>([T result]) {
    return _navigationKey.currentState.pop(result);
  }

  void popUtils(String routeName) {
    return _navigationKey.currentState.popUntil(ModalRoute.withName(routeName));
  }

  Future<dynamic> pushNamed(String routeName, {dynamic arguments}) {
    return _navigationKey.currentState
        .pushNamed(routeName, arguments: arguments);
  }

  Future<dynamic> pushReplacementNamed(String routeName, {dynamic arguments}) {
    return _navigationKey.currentState
        .pushReplacementNamed(routeName, arguments: arguments);
  }

  Future<dynamic> popAndPushNamed(String routeName, {dynamic arguments}) {
    return _navigationKey.currentState
        .popAndPushNamed(routeName, arguments: arguments);
  }

  Future<dynamic> pushNamedAndRemoveUntil(
      String routeName, RoutePredicate predicate,
      {dynamic arguments}) {
    return _navigationKey.currentState
        .pushNamedAndRemoveUntil(routeName, predicate, arguments: arguments);
  }
}
