import 'package:emed/data/model/drug.dart';
import 'package:emed/data/model/prescription.dart';
import 'package:emed/screen/drug/drug_list_screen.dart';
import 'package:emed/data/repository/drug_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:emed/data/service_locator.dart';

class DrugListModel extends ChangeNotifier {
  final DrugRepository drugRepository = serviceLocator<DrugRepository>();
  FilterType filter = FilterType.USING;
  List<Drug> drugs = [];

  void getDrugs(FilterType filterType) async {
    filter = filterType;
    drugs = null;
    notifyListeners();

    final tmp = await drugRepository.getAllDrugs();

    switch (filterType) {
      case FilterType.ALL:
        drugs = tmp;
        break;
      case FilterType.COMPLETED:
        drugs = tmp
            .where((element) => element.completedAt.isBefore(DateTime.now()))
            .toList();
        break;
      case FilterType.USING:
        drugs = tmp
            .where((element) => element.completedAt.isAfter(DateTime.now()))
            .toList();
        break;
    }

    notifyListeners();
  }

  void addDrugsFromPrescription(Prescription prescription) {
    print('Duyna: Adding drug now..');
    // print('Drugs length: ${drugs.listPill.length}');
    if (prescription.listPill.length > 0) {
      drugs = [...drugs, ...prescription.listPill];
      prescription.listPill.forEach((drug) {
        final i = drugs.indexWhere((element) => element.id == drug.id);
        if (i != -1)
          drugs[i].presentInPrescriptions += 1;
        else
          drugs.add(drug);
      });

      print('Drugs in pres length: ${prescription.listPill.length}');
      print('Drugs length: ${drugs.length}');
      notifyListeners();
    }
  }
}

enum FilterType { COMPLETED, USING, ALL }
