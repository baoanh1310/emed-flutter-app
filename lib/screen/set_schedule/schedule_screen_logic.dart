import 'dart:async';

import 'package:emed/data/model/prescription.dart';
import 'package:emed/data/repository/prescription_repository.dart';
import 'package:emed/data/service_locator.dart';
import 'package:emed/provider/model/prescription_list_model.dart';
import 'package:emed/provider/model/drug_list_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ScheduleScreenLogic {
  final PrescriptionRepository prescriptionRepository =
      serviceLocator<PrescriptionRepository>();
  final PrescriptionListModel prescriptionListModel;
  final DrugListModel drugListModel;

  ScheduleScreenLogic(BuildContext context)
      : prescriptionListModel = context.read<PrescriptionListModel>(),
        drugListModel = context.read<DrugListModel>();

  Future<bool> createPrescription(Prescription prescription) async {
    prescription.listPill.forEach((drug) {
      if (drug.completedAt.isAfter(prescription.completedAt))
        prescription.completedAt = drug.completedAt;
    });

    final success =
        await prescriptionRepository.createPrescription(prescription);
    if (success) {
      print('Duyna: Adding to druglist...');
      print('Duyna: Complete At ${prescription.completedAt}');
      prescriptionListModel.addPrescription(prescription);
      // drugListModel.addDrugsFromPrescription(prescription);
    }
    return success;
  }

  Future<bool> updatePrescription(
    Prescription old,
    Prescription current,
  ) async {
    final success =
        await prescriptionRepository.updatePrescription(old, current);
    if (success) {
      prescriptionListModel.addPrescription(current);
    }
    return success;
  }
}
