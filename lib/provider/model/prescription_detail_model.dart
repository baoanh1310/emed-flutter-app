import 'package:camera/camera.dart';
import 'package:emed/data/model/prescription.dart';
import 'package:flutter/foundation.dart';

class PrescriptionDetailModel extends ChangeNotifier {
  Prescription prescription;

  setPrescription(Prescription p) {
    prescription = p;
    notifyListeners();
  }

  reset() {
    prescription = null;
  }

}
