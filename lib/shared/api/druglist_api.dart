import 'dart:convert';
import 'dart:io';
import 'package:emed/data/model/drug.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:emed/shared/extension/file.dart';

const String host = 'http://202.191.57.61:8081/uong_thuoc/';

const String urlOcr = '';

// extension CapExtension on String {
//   String get inCaps => '${this[0].toUpperCase()}${this.substring(1)}';
//   String get allInCaps => this.toUpperCase();
//   String get capitalizeFirstofEach =>
//       this.split(" ").map((str) => str.inCaps).join(" ");
// }

String inCaps(String str) => '${str[0].toUpperCase()}${str.substring(1)}';

String capitalizeFirstofEach(String string) =>
    string.split(" ").map((str) => inCaps(str)).join(" ");

Future<Map<String, dynamic>> getDrugListResult(
    File image, String strListDrug, String userId) async {
  List<Drug> drugList = [];
  List<dynamic> pos = []; // list of corresponded drug's box
  List<dynamic> lstPositionOfCorrespondedDrug =
      []; // show the positions of correspond drug in json

  final selectedImage = image.toImage();

  print(
      'DUYNA: File: path - ${image.path} w - ${selectedImage.width}, h - ${selectedImage.height}');
  var request = new http.MultipartRequest("POST", Uri.parse(host));
  request.fields["list_drug_names"] = strListDrug;
  request.fields['user_id'] = userId;
  request.files.add(
    new http.MultipartFile(
      'file',
      File(image.path).readAsBytes().asStream(),
      File(image.path).lengthSync(),
      filename: image.path,
      contentType: new MediaType('image', 'jpeg'),
    ),
  );

  Stopwatch stopwatch = new Stopwatch()..start();
  var timeOut = false;
  var response =
      await request.send().timeout(Duration(seconds: 5), onTimeout: () {
    timeOut = true;
    return null;
  });
  if (timeOut) return null;
  print('get drug infos take ${stopwatch.elapsed}');
  print('response.statusCode: ${response.statusCode}');

  if (response.statusCode == 200) {
    final value = await response.stream.bytesToString();
    print('druglist api: $value');
    final resp = jsonDecode(value);
    print('druglist: resp - $resp');

    final result = resp['result'];
    if (result == null) {
      return null;
    }

    // lay set cua cac thuoc
    Set<String> setPillName = {};
    result['pills'].forEach((valuePill) {
      // neu ten khac others thi them vao set
      if (valuePill['pillname'] != 'others') {
        setPillName.add(valuePill['pillname']);
      }
    });

    setPillName.toList().forEach((valuePill) {
      // neu khong phai others
      Drug tmpDrug = Drug(
        id: '',
        amount: 1,
        doseUnit: '2',
        timeConsume: TimeConsume.NONE,
        nDaysPerWeek: 0,
        nTimesPerDay: 0,
      );
      tmpDrug.name = valuePill;

      // tim cac vi tri chua ten thuoc tuong ung
      tmpDrug.amount = result['pills']
          .where((element) => element['pillname'] == valuePill)
          .length;

      // tim box tuong ung voi phan tu dau tien chua thuoc ten ....
      final idx = result['pills']
          .indexWhere((element) => element['pillname'] == valuePill);
      drugList.add(tmpDrug);
      pos.add(result['pills'][idx]);

      var lstPositions = [];
      for (var i = 0; i < result['pills'].length; i++) {
        if (result['pills'][i]['pillname'] == valuePill) lstPositions.add(i);
      }
      print('hungvv - get lst position: ${lstPositions.toString()}');
      lstPositionOfCorrespondedDrug.add(lstPositions);
    });

    result['pills'].asMap().forEach((idx, valuePill) {
      if (valuePill['pillname'] == 'others') {
        // neu thuoc khong nhan dien duoc thi auto them vao
        Drug tmpDrug = Drug(
          id: '',
          amount: 1,
          doseUnit: '2',
          timeConsume: TimeConsume.NONE,
          nDaysPerWeek: 0,
          nTimesPerDay: 0,
        );
        tmpDrug.name = '';
        drugList.add(tmpDrug);
        pos.add(valuePill);
        var lstPositions = [idx];
        print('hungvv - get lst position: ${lstPositions.toString()}');
        lstPositionOfCorrespondedDrug.add(lstPositions);
      }
    });

    print('string drug list - ${drugList.toString()}');
    print('hungvv - lst position ${lstPositionOfCorrespondedDrug}');
    return {
      'drugs': drugList,
      'boxes': pos,
      'jsonString': value,
      'positions': lstPositionOfCorrespondedDrug
    };
  } else {
    print("Cant get value");
    return null;
  }
}
