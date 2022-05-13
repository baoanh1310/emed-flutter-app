import 'package:emed/data/model/drug.dart';
import 'package:emed/data/model/prescription.dart';
import 'package:flutter/foundation.dart';

class PrescriptionModel extends ChangeNotifier {
  Prescription prescription;

  void getPrescription() async {
    await Future.delayed(Duration(milliseconds: 300), () {
      prescription = Prescription(
          id: "",
          image_url: "",
          local_image_url: "",
          symptom: 'Sick, Cold',
          diagnose: 'Covid 19',
          createdAt: DateTime.now(),
          completedAt: DateTime.now().add(Duration(days: 7)),
          nDaysPerWeek: 5,
          listPill: [
            Drug(
              id: '1',
              name: 'Vitamin C',
              amount: 4,
              doseUnit: 'gói',
              timeConsume: TimeConsume.AFTER,
              startedAt: null,
              completedAt: null,
              nTimesPerDay: 2,
              nDaysPerWeek: 2,
            ),
            Drug(
              id: '2',
              name: 'Vitamin E',
              amount: 4,
              doseUnit: 'gói',
              timeConsume: TimeConsume.AFTER,
              startedAt: null,
              completedAt: null,
              nTimesPerDay: 2,
              nDaysPerWeek: 2,
            ),
          ]
          // nDaysPerWeek: 3,
          );
    });
    notifyListeners();
  }

  void addPrescript(Prescription pres) async {
    await Future.delayed(Duration(milliseconds: 300), () {
      prescription = pres;
    });
    notifyListeners();
  }
}
