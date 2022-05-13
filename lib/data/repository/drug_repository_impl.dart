import 'dart:async';
import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emed/data/model/drug.dart';
import 'package:emed/data/model/prescription.dart';
import 'package:emed/data/repository/drug_repository.dart';
import 'package:emed/shared/setting/firebase_const.dart';
import 'package:emed/shared/utils/utils.dart';

class DrugRepositoryImpl implements DrugRepository {
  @override
  Future<List<Drug>> getAllDrugs() async {
    String uid = getUserId();
    CollectionReference prescriptionListRef = FirebaseFirestore.instance
        .collection(FirebaseConstant.prescription)
        .doc(uid)
        .collection(FirebaseConstant.prescriptionList);
    final documents = (await prescriptionListRef.get()).docs;
    final List<Drug> result = [];
    Map<String, int> presentInPrescriptions = {};
    documents.forEach((document) {
      final Map<String, dynamic> data = document.data();

      try {
        final pres = Prescription.fromMap(data);
        print(
            'Duyna - DrugRepoImp: The number of drug: ${pres.listPill.length}');
        pres.listPill.forEach((drug) {
          final iter = result.where(
              (element) => getKeyFromDrug(element) == getKeyFromDrug(drug));
          print('Duyna - DrugRepoImp: The id of drug: ${drug.id}');
          print(
              'Duyna - DrugRepoImp: The complete date of drug: ${drug.completedAt}');

          if (presentInPrescriptions[getKeyFromDrug(drug)] != null)
            presentInPrescriptions[getKeyFromDrug(drug)] += 1;
          else
            presentInPrescriptions[getKeyFromDrug(drug)] = 1;

          if (iter.isNotEmpty) {
            bool isDup = false;
            for (var match in iter) {
              if (getKeyFromDrug(match) == getKeyFromDrug(drug)) {
                if (match.completedAt.isBefore(drug.completedAt)) {
                  final index = result.indexOf(match);
                  result.removeAt(index);
                  result.insert(index, drug);
                }
                isDup = true;
                break;
              }
            }
            if (!isDup) result.add(drug);
          } else {
            result.add(drug);
          }
        });
      } catch (e) {
        print('hungvv -cant map drug - $e - ${data.toString()}');
      }
    });

    for (var i = 0; i < result.length; i++) {
      result[i].presentInPrescriptions =
          presentInPrescriptions[getKeyFromDrug(result[i])] ?? 1;
    }

    print('Duyna - DrugRepoImp: The total number of drugs: ${result.length}');

    return result;
  }

  String getKeyFromDrug(Drug drug) {
    return '${drug.id}_${drug.name}';
  }
}
