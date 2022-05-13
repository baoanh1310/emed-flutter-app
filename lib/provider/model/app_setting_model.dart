import 'package:emed/data/model/app_setting.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSettingModel extends ChangeNotifier {
  AppSetting appSetting;

  Future getAppSetting() async {
    var prefs = await SharedPreferences.getInstance();;
    String userId = prefs.getString("userId") ?? "UID not available";
    String userName = prefs.getString("userName") ?? "Unknown";
    appSetting = AppSetting(userId: userId, userName: userName);
    notifyListeners();
  }
}