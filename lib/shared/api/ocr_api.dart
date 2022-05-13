import 'dart:convert';
import 'dart:io';
import 'package:emed/data/model/drug.dart';
import 'package:emed/data/model/prescription.dart';
import 'package:emed/screen/ocr_result/components/drug_list.dart';
import 'package:emed/shared/api/drug_api.dart';
import 'package:emed/shared/utils/utils.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:emed/shared/extension/file.dart';
import 'package:emed/shared/extension/image.dart';
import 'package:emed/constants.dart';
import 'package:image/image.dart';

const String host = 'http://202.191.57.61:8081/';

const String urlOcr = '';

Future<Prescription> getPrescriptionInformation(File image) async {
  // print(image.path);
  Prescription tmp = Prescription(
      id: '',
      image_url: '',
      local_image_url: '',
      createdAt: DateTime.now(),
      completedAt: DateTime.now(),
      nDaysPerWeek: 0,
      listPill: []);

  final selectedImage = image.toImage();
  print(
      'Phungtd: getPrescriptionInformation -> selected imageeee: width: ${selectedImage.width}, height: ${selectedImage.height}, path: ${image.path}');

  // final scaledImage =
  //     copyResize(selectedImage, width: resoWidth, height: resoHeight);
  Image scaledImage;
  if (selectedImage.height < resoHeight) {
    final ratio = selectedImage.height / resoHeight;
    scaledImage = selectedImage.resizeWithPercent(ratio: ratio);
  } else {
    scaledImage = selectedImage;
  }
  print(
      'Phungtd: getPrescriptionInformation -> scaledImage imageeee: width: ${scaledImage.width}, height: ${scaledImage.height}');

  // final List<int> imageData = List.from(scaledImage.getBytes());
  final List<int> imageData = encodeNamedImage(scaledImage, image.path);

  var request = new http.MultipartRequest("POST", Uri.parse(host));
  request.files.add(
    new http.MultipartFile(
      'file',
      File(image.path).readAsBytes().asStream(),
      File(image.path).lengthSync(),
      filename: image.path,
      contentType: new MediaType('image', 'jpeg'),
    ),
  );
  // var request = new http.MultipartRequest("POST", Uri.parse(host));
  // request.files.add(
  //   new http.MultipartFile.fromBytes(
  //     'file',
  //     imageData,
  //     filename: image.path,
  //     contentType: new MediaType('image', 'jpeg'),
  //   ),
  // );
  Stopwatch stopwatch = new Stopwatch()..start();
  var timeOut = false;
  var response =
      await request.send().timeout(Duration(seconds: 5), onTimeout: () {
    timeOut = true;
    return null;
  });
  if (timeOut) return tmp;
  print('get prescription info takes ${stopwatch.elapsed}');
  print('response.statusCode: ${response.statusCode}');

  // listen for response
  print('hungvv');
  print(image);

  if (response.statusCode == 200) {
    final value = await response.stream.bytesToString();
    print('hungvv: ahuhu $value');
    final resp = jsonDecode(value);
    print('Hungvv: resp - $resp');
    tmp.id = '';
    tmp.image_url = '';
    final result = resp['result'];
    print('Hungvv: result response: $result');
    if (result == null) {
      return tmp;
    }

    tmp.symptom = result['symptom'] ?? '';
    var tmpDiagnose = result['diagnosis'] ?? '';
    int idx = tmpDiagnose.indexOf(":");
    tmp.diagnose = tmpDiagnose.substring(idx + 1).trim();
    result['listDrug'].forEach((value) async {
      Drug tmpDrug = Drug(
        id: '',
        amount: 0,
        doseUnit: '',
        timeConsume: TimeConsume.NONE,
        nDaysPerWeek: 0,
        nTimesPerDay: 0,
      );

      tmpDrug.name = value['drugname'] ?? '';
      // print('hungvv - ${tmpDrug.name}');
      // check tung thuoc, neu khong co id thuoc thi tra ve string rong

      // final drugMatched = await getBestMatchedDrugIdByName(tmpDrug.name);
      // tmpDrug.id = drugMatched?.length == 0 ? '' : drugMatched[0]['soDangKy'];
      // print('hungvv - ${isInteger(value['drugtype'])}');
      // print('hungvv - ${isInteger(value['frequency'])}');
      // print('hungvv - ${isInteger(value['quantity'])}');
      // print(isInteger(value['quantity']));
      // print(isInteger(value['quantity']));
      // print(isInteger(value['quantity']));

      if (value['drugtype'].runtimeType != int)
        tmpDrug.doseUnit =
            isInteger(value['drugtype']) ? value['drugtype'].toString() : '1';
      else
        tmpDrug.doseUnit = value['drugtype'].toString();

      if (value['frequency'].runtimeType != int)
        tmpDrug.nTimesPerDay =
            isInteger(value['frequency']) ? int.parse(value['frequency']) : 1;
      else
        tmpDrug.nTimesPerDay = value['frequency'];

      if (value['dose'].runtimeType != int)
        tmpDrug.amount = 1;
      //    isInteger(value['dose']) ? int.parse(value['dose']) : 1;
      else
        tmpDrug.amount = value['dose'];

      tmp.listPill.add(tmpDrug);
    });
    print(tmp.listPill.toString());
    return tmp;
  } else {
    print("Cant get value");
    return tmp;
  }
}
