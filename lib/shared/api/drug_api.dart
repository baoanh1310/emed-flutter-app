import 'dart:convert';
import 'package:http/http.dart' as http;

const String host = '202.191.57.62:1999';

const String urlDrugByName = 'api/drug/name';
const String urlDrugByNameIfMatch = 'api/drug/match/name';
const String urlDrugById = 'api/drug/id';
const String urlDrugByIdIfMatch = 'api/drug/match/id';

getDrugByName(String partialName, {int sizeQuery = 100}) async {
  var body = jsonEncode({'tenThuoc': partialName, 'sizeQuery': sizeQuery});

  print(body);
  var response = await http.post(Uri.http(host, urlDrugByName),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: body);
  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);

    if (data != null) {
      final matches = data['matches'];
      return matches == null ? [] : matches;
    }
    return [];
  } else {
    print('Duyna: Fail to fetch drug data from the server!');
  }
}

getDrugByNameIfMatch(String partialName, {int sizeQuery = 1}) async {
  var body = jsonEncode({'tenThuoc': partialName, 'sizeQuery': sizeQuery});

  print('DUYNA: getDrugIfMatch... ${partialName}');
  var response = await http.post(Uri.http(host, urlDrugByNameIfMatch),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: body);
  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);

    if (data != null) {
      final matches = data['matches'];
      print('DUYNA: getDrugIfMatch result: ');
      print(matches.toString());
      return matches == null ? [] : matches;
    }
    return [];
  } else {
    print('Duyna: Fail to fetch drug data from the server!');
  }
}

getDrugById(String partialName, {int sizeQuery = 1}) async {
  var body = jsonEncode({'soDangKy': partialName, 'sizeQuery': sizeQuery});

  print(body);
  var response = await http.post(Uri.http(host, urlDrugById),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: body);
  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);

    if (data != null) {
      final matches = data['matches'];
      return matches == null ? null : matches[0];
    }
    return null;
  } else {
    print('Duyna: Fail to fetch drug data from the server!');
  }
}

getDrugByIdIfMatch(String partialName, {int sizeQuery = 1}) async {
  var body = jsonEncode({'soDangKy': partialName, 'sizeQuery': sizeQuery});

  print(body);
  var response = await http.post(Uri.http(host, urlDrugByIdIfMatch),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: body);
  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);

    if (data != null) {
      final matches = data['matches'];
      return matches == null ? null : matches[0];
    }
    return null;
  } else {
    print('Duyna: Fail to fetch drug data from the server!');
  }
}

getBestMatchedDrugIdByName(String partialName, {int sizeQuery = 1}) async {
  var body = jsonEncode({'tenThuoc': partialName, 'sizeQuery': sizeQuery});

  print(body);
  var response = await http.post(Uri.http(host, urlDrugByName),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: body);
  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    print('hungvv -drugapi data');
    print(data);
    if (data != null) {
      final matches = data['matches'];
      return matches == null ? [] : matches;
    }
    return [];
  } else {
    print('Duyna: Fail to fetch drug data from the server!');
    return [];
  }
}
