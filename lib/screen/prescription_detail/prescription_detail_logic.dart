import 'package:emed/data/model/prescription.dart';
import 'package:emed/data/repository/prescription_repository.dart';
import 'package:emed/data/service_locator.dart';
import 'package:emed/provider/model/prescription_detail_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'my_calendar.dart';

class PrescriptionDetailLogic {
  final PrescriptionRepository prescriptionRepository = serviceLocator<PrescriptionRepository>();
  final PrescriptionDetailModel model;

  PrescriptionDetailLogic(BuildContext context): model = context.read<PrescriptionDetailModel>();

  getPrescription(String id) async {
    final prescription = await prescriptionRepository.getPrescription(id);
    model.setPrescription(prescription);
  }

  setPrescription(Prescription prescription) {
    model.setPrescription(prescription);
  }

  Future<List<List<MedicationStatus>>> getMedHistory(String prescriptionId, String drugName, DateTime startDate, DateTime endDate, {int timesPerDay}) {
    return prescriptionRepository.getMedHistoryByName(prescriptionId, drugName, startDate, endDate, timesPerDay: timesPerDay);
  }
}