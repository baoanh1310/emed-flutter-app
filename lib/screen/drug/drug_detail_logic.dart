import 'dart:async';

import 'package:firebase_storage/firebase_storage.dart';

class DrugDetailScreenLogic {
  final _fstorageInstance = FirebaseStorage.instance;
  Map<String, String> numberToUnit = {
    '0': "lo",
    '1': "tube",
    '2': "vienthuoc",
    '3': "ong",
    '4': "hop",
    '5': "goi",
    '6': "but",
    '7': "chai",
    '8': "vithuoc"
  };

  /// return the url of the image of a drug by passing its soDangKy
  Future<String> getDrugImage(
      {String registerId = 'VN-', String doseUnit = ""}) async {
    if (registerId == '') return '';
    final refCopy = _fstorageInstance.ref().child('${registerId}');
    if (refCopy != null) {
      ListResult result = await refCopy.listAll();
      print("Drug ID: ${registerId}");

      print("result lenth: ${result.items.length}");
      if (result.items.length > 0) {
        result.items.forEach((Reference ref) {
          //  VN-5621-10/vithuoc-20210219_112520500502.jpg

          final arrString = ref.fullPath.split("/");
          String pill = arrString[1];
          String arrType = pill.split("-")[0];
          if (doseUnit != "") {
            if (numberToUnit[doseUnit] == arrType) {
              return ref.fullPath;
            }
          }
        });
        return result.items[result.items.length - 1].fullPath;
      }
    }
    return '';
  }

  Future<String> getUrlUpdate({String imagePath = ""}) async {
    if (imagePath == "") {
      return "";
    }
    final ref = _fstorageInstance.ref(imagePath);

    if (ref != null || ref != "") {
      print("cuong nh: ${ref}");
      print('Inside list item!');
      // String downloadURL = await ref.getDownloadURL().catchError((err) {
      //   return "";
      // });
      // return downloadURL;
      try {
        String downloadURL = await ref.getDownloadURL();
        return downloadURL;
      } on Exception catch (e) {
        print(e);
        return "";
      }
    }

    return "";
  }
}
