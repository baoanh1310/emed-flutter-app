import 'dart:convert';
import 'dart:ffi';
import 'package:emed/data/model/drug.dart';
import 'package:http/http.dart' as http;

const String host = '202.191.57.61:8081';
const String updateLabels = 'update_labels/';

updateJsonLabels(Map<String, dynamic> jsonBody, String userId) async {
  jsonBody['user_id'] = userId;
  var body = jsonEncode(jsonBody);
  print('hungvv- update label');

  var response = await http.post(
    Uri.http(host, updateLabels),
    headers: <String, String>{
      'Content-Type': 'application/json',
    },
    body: body,
  );
  print('hungvv response code- ${response.statusCode}');
  if (response.statusCode == 200) {
    return 'API-update succeeded';
  } else {
    print('Duyna: Fail to fetch drug data from the server!');
  }
}
