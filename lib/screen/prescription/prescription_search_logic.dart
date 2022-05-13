import 'dart:async';

import 'package:emed/data/service_locator.dart';
import 'package:emed/data/model/prescription.dart';
import 'package:emed/data/repository/prescription_repository.dart';

class PrescriptionSearchLogic {
  final PrescriptionRepository prescriptionRepository =
      serviceLocator<PrescriptionRepository>();

  /// return the url of the image of a drug by passing its soDangKy
  Future<List<Prescription>> getPrescriptionByText(
      {String partialText = ''}) async {
    List<Prescription> prescriptionList = await prescriptionRepository
        .getPrescriptionsWithSearchText(partialText);

    if (prescriptionList.length != 0) return prescriptionList;
    return [];
  }
}
