import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class ShowCaseSetting {
  ShowCaseSetting._privateConstructor();

  static final ShowCaseSetting _instance =
      ShowCaseSetting._privateConstructor();

  static ShowCaseSetting get instance => _instance;

  bool mainScreen = true;
  bool addPrescriptionScreen = true;
  bool captureScreen = true;
  bool scheduleScreen = true;
  bool prescriptionListScreen = true;
  bool drugListScreen = true;
  bool medHistoryScreen = true;
  bool notiScreen = true;

  updateWith(Map<String, dynamic> copy) async {
    mainScreen = copy[ShowCaseSettingKey.mainScreen] ?? mainScreen;
    addPrescriptionScreen =
        copy[ShowCaseSettingKey.addPrescriptionScreen] ?? addPrescriptionScreen;
    captureScreen = copy[ShowCaseSettingKey.captureScreen] ?? captureScreen;
    scheduleScreen = copy[ShowCaseSettingKey.scheduleScreen] ?? scheduleScreen;
    prescriptionListScreen = copy[ShowCaseSettingKey.prescriptionListScreen] ??
        prescriptionListScreen;
    drugListScreen = copy[ShowCaseSettingKey.drugListScreen] ?? drugListScreen;
    medHistoryScreen =
        copy[ShowCaseSettingKey.medHistoryScreen] ?? medHistoryScreen;
    notiScreen = copy[ShowCaseSettingKey.notiScreen] ?? notiScreen;

    // update in sharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final showCaseSettingJson = jsonEncode(this.toJson());
    await prefs.setString(
        ShowCaseSettingKey.showCaseSettingPref, showCaseSettingJson);
  }

  Map toJson() {
    return {
      ShowCaseSettingKey.mainScreen: mainScreen,
      ShowCaseSettingKey.addPrescriptionScreen: addPrescriptionScreen,
      ShowCaseSettingKey.captureScreen: captureScreen,
      ShowCaseSettingKey.scheduleScreen: scheduleScreen,
      ShowCaseSettingKey.prescriptionListScreen: prescriptionListScreen,
      ShowCaseSettingKey.drugListScreen: drugListScreen,
      ShowCaseSettingKey.medHistoryScreen: medHistoryScreen,
      ShowCaseSettingKey.notiScreen: notiScreen,
    };
  }

  fromJson(Map<String, dynamic> json) {
    mainScreen = json[ShowCaseSettingKey.mainScreen] ?? mainScreen;
    addPrescriptionScreen =
        json[ShowCaseSettingKey.addPrescriptionScreen] ?? addPrescriptionScreen;
    captureScreen = json[ShowCaseSettingKey.captureScreen] ?? captureScreen;
    scheduleScreen = json[ShowCaseSettingKey.scheduleScreen] ?? scheduleScreen;
    prescriptionListScreen = json[ShowCaseSettingKey.prescriptionListScreen] ??
        prescriptionListScreen;
    drugListScreen = json[ShowCaseSettingKey.drugListScreen] ?? drugListScreen;
    medHistoryScreen =
        json[ShowCaseSettingKey.medHistoryScreen] ?? medHistoryScreen;
    notiScreen = json[ShowCaseSettingKey.notiScreen] ?? notiScreen;
  }

  reset() {
    mainScreen = true;
    addPrescriptionScreen = true;
    captureScreen = true;
    scheduleScreen = true;
    prescriptionListScreen = true;
    drugListScreen = true;
    medHistoryScreen = true;
    notiScreen = true;
  }
}

class ShowCaseSettingKey {
  static String showCaseSettingPref = 'showCaseSetting';
  static String mainScreen = 'mainScreen';
  static String addPrescriptionScreen = 'addPrescriptionScreen';
  static String captureScreen = 'captureScreen';
  static String scheduleScreen = 'scheduleScreen';
  static String prescriptionListScreen = 'prescriptionListScreen';
  static String drugListScreen = 'drugListScreen';
  static String medHistoryScreen = 'medHistoryScreen';
  static String notiScreen = 'notiScreen';
}
