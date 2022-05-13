import 'package:emed/data/model/drug_history_item_time.dart';
import 'package:emed/data/model/prescription.dart';
import 'package:emed/data/model/user_question_notify.dart';
import 'package:emed/screen/prescription_detail/my_calendar.dart';

abstract class PrescriptionRepository {
  Future<List<Prescription>> getAllPrescriptions();

  Future<List<Prescription>> getPrescriptionsWithSearchText(String partialText);

  Future<Prescription> getPrescription(String prescriptionId);

  Future<List<List<MedicationStatus>>> getMedHistoryById(String prescriptionId,
      String drugId, DateTime startDate, DateTime endDate,
      {int timesPerDay});

  Future<List<List<MedicationStatus>>> getMedHistoryByName(String prescriptionId,
      String name, DateTime startDate, DateTime endDate,
      {int timesPerDay});

  Future<bool> createPrescription(Prescription prescription);

  Future<bool> updatePrescription(Prescription old, Prescription current);

  Future<List<DrugHistoryItemTime>> getMedHistoryEachDay(DateTime selectedDate);

  Future<void> createUserQuestionNotify(Prescription prescription);

  Future<List<UserQuestionNotify>> getUserQuestionNotify();

  Future<void> updateUserQuestionNotify(UserQuestionNotify userQuestionNotify);

  Future<List<DrugHistoryItemTime>> getMedHistoryAtTime(
      int selectedHour, int selectedMinute, DateTime date);

  Future<void> updateMedHistoryAtTime(
      List<DrugHistoryItemTime> lstDrugTime,
      int selectedHour,
      int selectedMinute,
      DateTime selectedDate,
      bool isDirect);

  Future<String> getDrugImage(
      {String registerId = 'VN-', String doseUnit = ""});
}
