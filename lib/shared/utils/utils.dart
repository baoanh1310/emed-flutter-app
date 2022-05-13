import 'dart:io';
import 'dart:math';
import 'package:emed/data/model/drug.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'package:uuid/uuid.dart';
import 'package:path_provider/path_provider.dart';

var uuid = Uuid();
String getUserId() {
  final User user = FirebaseAuth.instance.currentUser;
  print('Phungtd: getUserId -> User: ${user.email} , id: ${user.uid}');
  return user.uid;
}

bool isInteger(String s) {
  if (s == null) {
    return false;
  }
  return int.parse(s, onError: (e) => null) != null;
}

int generateRandomInt() {
  final random = Random();
  return random.nextInt(2147483647);
}

String getHourAndMinute(DateTime dateTime) {
  int hour = dateTime.hour;
  int minute = dateTime.minute;
  final hourText = hour < 10 ? '0$hour' : '$hour';
  final minuteText = minute < 10 ? '0$minute' : '$minute';
  return '$hourText:$minuteText';
}

String genDrugID({String drugName = ""}) {
  String normalizeDrug =
      drugName.split(" ").join("").replaceAll(new RegExp(r'/'), '');
  normalizeDrug = normalizeDrug.toLowerCase();
  normalizeDrug = uuid.v5(Uuid.NAMESPACE_URL,
      normalizeDrug); // -> 'c74a196f-f19d-5ea9-bffd-a2742432fc9c'
  return normalizeDrug;
}

String getDrugID(Drug drug) {
  if (drug.id != "" && '-'.allMatches(drug.id).length > 1) {
    return drug.id;
  } else {
    return genDrugID(drugName: drug.name);
  }
}

String getDrugIDByName(String drugName) {
  if (drugName == '') return '';
  return genDrugID(drugName: drugName);
}

Future<String> getFilePath(String drugId) async {
  Directory appDocumentsDirectory =
      await getApplicationDocumentsDirectory(); // 1
  String appDocumentsPath = appDocumentsDirectory.path; // 2
  String filePath = '$appDocumentsPath/$drugId.jpg'; // 3

  return filePath;
}

TargetFocus buildTarget({
  String id = '',
  @required GlobalKey keyTarget,
  @required String description,
  bool enableOverlayTab = true,
  bool enableTargetTab = false,
  ContentAlign contentAlign = ContentAlign.top,
  ShapeLightFocus shape,
  double paddingFocus,
}) {
  if (description != null)
    return TargetFocus(
      identify: id,
      keyTarget: keyTarget,
      shape: shape ?? ShapeLightFocus.Circle,
      radius: 8,
      paddingFocus: paddingFocus,
      enableOverlayTab: enableOverlayTab,
      enableTargetTab: enableTargetTab,
      contents: [
        TargetContent(
          align: contentAlign,
          child: Text(
            description,
            style: TextStyle(
                fontWeight: FontWeight.normal,
                color: Colors.white,
                fontSize: 16.0),
          ),
        ),
      ],
    );
  else
    return TargetFocus(
      identify: id,
      keyTarget: keyTarget,
      shape: shape ?? ShapeLightFocus.Circle,
      radius: 8,
      paddingFocus: paddingFocus,
      enableOverlayTab: enableOverlayTab,
      enableTargetTab: enableTargetTab,
      contents: [
        TargetContent(
          align: contentAlign,
          child: SizedBox(
            height: 100,
          ),
        ),
      ],
    );
}
