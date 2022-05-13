import 'package:emed/data/model/prescription.dart';
import 'package:emed/data/repository/prescription_repository.dart';
import 'package:emed/data/service_locator.dart';
import 'package:flutter/foundation.dart';

class PrescriptionListModel extends ChangeNotifier {
  final PrescriptionRepository prescriptionRepository =
      serviceLocator<PrescriptionRepository>();
  FilterType filter = FilterType.USING;
  List<Prescription> prescriptions;

  void getPrescriptions(FilterType filterType) async {
    filter = filterType;
    prescriptions = null;
    notifyListeners();

    final tmp = await prescriptionRepository.getAllPrescriptions();

    switch (filterType) {
      case FilterType.ALL:
        prescriptions = tmp;
        break;
      case FilterType.COMPLETED:
        prescriptions = tmp
            .where((element) => element.completedAt.isBefore(DateTime.now()))
            .toList();
        break;
      case FilterType.USING:
        prescriptions = tmp
            .where((element) => element.completedAt.isAfter(DateTime.now()))
            .toList();
        break;
    }

    notifyListeners();
  }

  void addNewPrescript(Prescription prescription) async {
    prescriptions = null;
    getPrescriptions(FilterType.ALL);
    notifyListeners();

    await Future.delayed(Duration(milliseconds: 300), () {
      prescriptions.add(prescription);
    });
    notifyListeners();
  }

  void addPrescription(Prescription prescription) {
    if (prescriptions == null) {
      prescriptions = [prescription];
      notifyListeners();
      return;
    }
    final index =
        prescriptions.indexWhere((element) => element.id == prescription.id);

    if (index == -1) {
      prescriptions.insert(0, prescription);
    } else {
      prescriptions[index] = prescription;
    }
    notifyListeners();
  }
}

enum FilterType { COMPLETED, USING, ALL }
