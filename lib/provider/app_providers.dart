import 'dart:convert';

import 'package:emed/data/model/show_case_setting.dart';
import 'package:emed/provider/model/app_setting_model.dart';
import 'package:emed/provider/model/prescription_detail_model.dart';
import 'package:emed/provider/model/prescription_list_model.dart';
import 'package:emed/provider/model/drug_list_model.dart';
import 'package:emed/provider/model/screen_reload_model.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'model/camera_model.dart';

import 'model/prescription_model.dart';

class AppProvider {
  factory AppProvider() {
    if (_instance == null) {
      _instance = AppProvider._getInstance();
    }
    return _instance;
  }

  static AppProvider _instance;
  AppProvider._getInstance();

  // Declare list of model here
  AppSettingModel appSettingModel;
  PrescriptionListModel prescriptionListModel;
  PrescriptionModel prescriptionModel;
  DrugListModel drugListModel;
  CameraModel cameraModel;
  PrescriptionDetailModel prescriptionDetailModel;
  ScreenReloadModel screenReloadModel;

  init() async {
    appSettingModel = AppSettingModel();
    prescriptionListModel = PrescriptionListModel();
    prescriptionModel = PrescriptionModel();
    cameraModel = CameraModel();
    drugListModel = DrugListModel();
    prescriptionDetailModel = PrescriptionDetailModel();
    screenReloadModel = ScreenReloadModel();

    await getShowCaseSetting();
  }

  getShowCaseSetting() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final showCaseSettingJson = prefs.getString(ShowCaseSettingKey.showCaseSettingPref);
    print('Phungtd: showCaseSettingJson: $showCaseSettingJson');
    if (showCaseSettingJson == null) {
      return;
    }
    ShowCaseSetting.instance.fromJson(jsonDecode(showCaseSettingJson));
    print('Phungtd: getShowCaseSetting: ${ShowCaseSetting.instance.toJson()}');
  }

  List<SingleChildWidget> get providers => [
        ChangeNotifierProvider(create: (_) => appSettingModel),
        ChangeNotifierProvider(create: (_) => prescriptionListModel),
        ChangeNotifierProvider(create: (_) => prescriptionModel),
        ChangeNotifierProvider(create: (_) => cameraModel),
        ChangeNotifierProvider(create: (_) => drugListModel),
        ChangeNotifierProvider(create: (_) => prescriptionDetailModel),
        ChangeNotifierProvider(create: (_) => screenReloadModel),
      ];
}
