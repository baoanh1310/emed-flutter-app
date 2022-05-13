import 'package:flutter/cupertino.dart';

class ScreenReloadModel extends ChangeNotifier {
  int homeScreenState = 0;

  markHomeScreenAsNeedReloading() {
    homeScreenState++;
    notifyListeners();
  }
}