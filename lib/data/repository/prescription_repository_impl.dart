import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emed/data/model/drug.dart';
import 'package:emed/data/model/drug_history_item.dart';
import 'package:emed/data/model/drug_history_item_time.dart';
import 'package:emed/data/model/drug_history_time.dart';
import 'package:emed/data/model/drug_time.dart';
import 'package:emed/data/model/prescription.dart';
import 'package:emed/data/model/prescription_notification.dart';
import 'package:emed/data/model/user_question_notify.dart';
import 'package:emed/data/repository/notification_repository.dart';
import 'package:emed/data/repository/prescription_repository.dart';
import 'package:emed/screen/prescription_detail/my_calendar.dart';
import 'package:emed/shared/setting/firebase_const.dart';
import 'package:emed/shared/utils/utils.dart';
import 'package:emed/shared/extension/date.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:path/path.dart' as p;
import "package:emed/screen/drug/drug_detail_logic.dart";

class PrescriptionRepositoryImpl implements PrescriptionRepository {
  NotificationRepository _notificationRepository;

  PrescriptionRepositoryImpl(this._notificationRepository);

  @override
  Future<List<Prescription>> getAllPrescriptions() async {
    String uid = getUserId();
    CollectionReference prescriptionListRef = FirebaseFirestore.instance
        .collection(FirebaseConstant.prescription)
        .doc(uid)
        .collection(FirebaseConstant.prescriptionList);
    final documents = (await prescriptionListRef.get()).docs;
    final List<Prescription> result = [];
    documents.forEach((document) {
      final Map<String, dynamic> data = document.data();
      try {
        result.add(Prescription.fromMap(data));
      } catch (e) {
        print('hungvv cant map prescription');
        print('hungvv - document ${data.toString()}');
      }
    });
    return result;
  }

  @override
  Future<List<Prescription>> getPrescriptionsWithSearchText(
      String partialText) async {
    String uid = getUserId();
    CollectionReference prescriptionListRef = FirebaseFirestore.instance
        .collection(FirebaseConstant.prescription)
        .doc(uid)
        .collection(FirebaseConstant.prescriptionList);
    final documents = (await prescriptionListRef.get()).docs;
    final List<Prescription> result = [];
    documents.forEach((document) {
      final Map<String, dynamic> data = document.data();
      if (data['chan_doan'].toLowerCase().contains(partialText)) {
        result.add(Prescription.fromMap(data));
        return;
      }
      bool hasDrug = false;
      data['danh_sach_thuoc'].forEach((drug) {
        if (!hasDrug && drug['ten_thuoc'].toLowerCase().contains(partialText)) {
          result.add(Prescription.fromMap(data));
          hasDrug = true;
        }
      });
    });
    return result;
  }

  Future<List<DrugHistoryItemTime>> getMedHistoryEachDay(
      DateTime selectedDate) async {
    String uid = getUserId();
    final List<DrugHistoryItemTime> result = [];
    print('date: ${selectedDate.toString()}');
    final dateCollection = selectedDate.toFirestoreCollectionNameFormat();
    final prescriptionDayHistoryRef = FirebaseFirestore.instance
        .collection(FirebaseConstant.medHistory)
        .doc(uid)
        .collection(dateCollection);
    final medHistoryCollection = await prescriptionDayHistoryRef.get();
    await Future.forEach(medHistoryCollection.docs, (doc) async {
      if (doc.exists) {
        final medList = doc[FirebaseConstant.medList] as List;

        for (Map element in medList) {
          String imagePath = "";
          if (element[FirebaseConstant.image] == "") {
            String imageFullPath = await DrugDetailScreenLogic()
                .getDrugImage(registerId: element[FirebaseConstant.id]);
            imagePath = await DrugDetailScreenLogic()
                .getUrlUpdate(imagePath: imageFullPath);
          } else {
            imagePath = await DrugDetailScreenLogic()
                .getUrlUpdate(imagePath: element[FirebaseConstant.image]);
          }
          // String imagePath = element[FirebaseConstant.image];
          final drugs = (element[FirebaseConstant.medTime] as List).map((e) {
            Map drugHistory = new Map();

            drugHistory[FirebaseConstant.amount] =
                element[FirebaseConstant.amount];
            drugHistory[FirebaseConstant.note] = element[FirebaseConstant.note];
            drugHistory[FirebaseConstant.medName] =
                element[FirebaseConstant.medName];
            drugHistory[FirebaseConstant.id] = element[FirebaseConstant.id];
            drugHistory[FirebaseConstant.image] = imagePath;
            drugHistory.addAll(e);

            print('current drugHistory ${drugHistory.toString()}');
            return DrugHistoryItemTime.fromMap(drugHistory);
          });
          result.addAll(drugs);
        }
      }
    });
    // final resultIdSet = result.map((e) => e.id).toSet();
    // result.retainWhere((x) => resultIdSet.remove(x.id));
    // final ids = result.map((e) => "${e.hour}:${e.minute}:${e.name}").toSet();
    // result.retainWhere((x) => ids.remove("${x.hour}:${x.minute}:${x.name}"));
    result.sort((a, b) {
      return a.compareTo(b);
    });

    return result;
  }

  @override
  Future<Prescription> getPrescription(String prescriptionId) async {
    String uid = getUserId();
    CollectionReference prescriptionListRef = FirebaseFirestore.instance
        .collection(FirebaseConstant.prescription)
        .doc(uid)
        .collection(FirebaseConstant.prescriptionList);
    final prescriptionCollection = await prescriptionListRef.get();
    final document = prescriptionCollection.docs
        .where(
            (element) => element.data()[FirebaseConstant.id] == prescriptionId)
        .first;
    final data = document.data();
    return Prescription.fromMap(data);
  }

  @override
  Future<List<List<MedicationStatus>>> getMedHistoryById(String prescriptionId,
      String drugId, DateTime startDate, DateTime endDate,
      {int timesPerDay = 0}) async {
    final List<List<MedicationStatus>> result = [];
    final String uid = getUserId();
    final now = DateTime.now();
    final dayCount = endDate.dayDifference(startDate);
    for (int i = 0; i < dayCount; i++) {
      final currentDate = startDate.add(Duration(days: i));
      final dateCollection = currentDate.toFirestoreCollectionNameFormat();
      final prescriptionDayHistoryRef = FirebaseFirestore.instance
          .collection(FirebaseConstant.medHistory)
          .doc(uid)
          .collection(dateCollection)
          .doc(prescriptionId);
      final prescriptionDaySchedule = await prescriptionDayHistoryRef.get();
      if (prescriptionDaySchedule.exists) {
        final medList =
            prescriptionDaySchedule[FirebaseConstant.medList] as List;
        final medDayHistory = medList.firstWhere(
            (element) => element[FirebaseConstant.id] == drugId,
            orElse: () => null);
        if (medDayHistory != null) {
          final timeList = (medDayHistory[FirebaseConstant.medTime] as List)
              .map((map) => DrugHistoryTime.fromMap(map));
          result.add(timeList
              .map((e) => getMedicationStatus(
                  currentDate.add(Duration(hours: e.hour, minutes: e.minute)),
                  now,
                  e.isTaken))
              .toList());
          continue;
        }
      }
      result.add(List.generate(
          timesPerDay, (index) => MedicationStatus.NOT_NECESSARY));
    }
    return result;
  }

  @override
  Future<List<List<MedicationStatus>>> getMedHistoryByName(
      String prescriptionId, String name, DateTime startDate, DateTime endDate,
      {int timesPerDay = 0}) async {
    final List<List<MedicationStatus>> result = [];
    final String uid = getUserId();
    final now = DateTime.now();
    final dayCount = endDate.dayDifference(startDate);
    for (int i = 0; i < dayCount; i++) {
      final currentDate = startDate.add(Duration(days: i));
      final dateCollection = currentDate.toFirestoreCollectionNameFormat();
      final prescriptionDayHistoryRef = FirebaseFirestore.instance
          .collection(FirebaseConstant.medHistory)
          .doc(uid)
          .collection(dateCollection)
          .doc(prescriptionId);
      final prescriptionDaySchedule = await prescriptionDayHistoryRef.get();
      if (prescriptionDaySchedule.exists) {
        final medList =
            prescriptionDaySchedule[FirebaseConstant.medList] as List;
        final medDayHistory = medList.firstWhere(
            (element) => element[FirebaseConstant.medName] == name,
            orElse: () => null);
        if (medDayHistory != null) {
          final timeList = (medDayHistory[FirebaseConstant.medTime] as List)
              .map((map) => DrugHistoryTime.fromMap(map));
          final dayHistory = timeList
              .map((e) => getMedicationStatus(
                  DateTime(currentDate.year, currentDate.month, currentDate.day,
                      e.hour, e.minute),
                  now,
                  e.isTaken))
              .toList();
          for (int i = timeList.length; i < timesPerDay; i++) {
            dayHistory.insert(0, MedicationStatus.NOT_NECESSARY);
          }
          result.add(dayHistory);
          continue;
        }
      }
      result.add(List.generate(
          timesPerDay, (index) => MedicationStatus.NOT_NECESSARY));
    }
    return result;
  }

  MedicationStatus getMedicationStatus(
      DateTime drugTime, DateTime currentTime, bool isTaken) {
    if (isTaken) {
      return MedicationStatus.TOOK;
    } else {
      if (drugTime.isBefore(currentTime)) {
        return MedicationStatus.MISSED;
      } else {
        return MedicationStatus.NECESSARY;
      }
    }
  }

  Future<String> uploadImagePill(
      {String path, String imagePathFirestore}) async {
    final img = File(path);
    final String filePath = imagePathFirestore;
    // final metaData = SettableMetadata(
    //   customMetadata: {
    //     'uid': uid,
    //     'prescriptionId': prescriptionId,
    //   },
    // );
    try {
      final uploadedImgTask =
          await FirebaseStorage.instance.ref(filePath).putFile(img);
      if (uploadedImgTask.state == TaskState.success) {
        return filePath;
      } else {
        return '';
      }
    } on FirebaseException catch (e) {
      print(e);
      return '';
    } catch (anotherException) {
      print(anotherException);
      return '';
    }
  }

  /// return true if the prescription is created successfully and vice versa
  Future<bool> createPrescription(Prescription prescription) async {
    final completer = Completer<bool>();
    String userID = getUserId();

    if (prescription.id == null || prescription.id.isEmpty) {
      prescription.id = Uuid().v1();
    }

    //upload prescription
    final prescriptionImgUrl =
        await uploadImage(prescription.local_image_url, prescription.id);

    prescription.image_url = prescriptionImgUrl;
    await Future.forEach(prescription.listPill, (element) async {
      String pillID = getDrugID(element);
      String imageFirestore = "images/${userID}/${pillID}png";
      //upload pill image
      if (element.localImagePath != "") {
        await uploadImagePill(
            path: element.localImagePath, imagePathFirestore: imageFirestore);
      }
    });
    createPrescriptionWorks(prescription).then((_) {
      completer.complete(true);
    }).catchError((error) {
      print(
          'Phungtd: PrescriptionRepositoryImpl.createPrescription failed: $error');
      print('Hungvv: Prescription detail: ${prescription.id}');
      completer.complete(false);
    });

    return completer.future;
  }

  /// return true if the prescription is updated successfully and vice versa
  Future<bool> updatePrescription(Prescription old, Prescription current) {
    final completer = Completer<bool>();
    updatePrescriptionWorks(old, current).then((_) {
      completer.complete(true);
    }).catchError((error) {
      print(
          'Phungtd: PrescriptionRepositoryImpl.updatePrescription failed: $error');
      completer.complete(false);
    });
    return completer.future;
  }

  Future<List> createPrescriptionWorks(Prescription prescription) {
    final String uid = getUserId();
    print(
        'Phungtd: createPrescriptionWorks - prescriptionId: $prescription, uid: $uid');
    correctPrescriptionDataBeforeCreating(prescription);
    final prescriptionListRef = FirebaseFirestore.instance
        .collection(FirebaseConstant.prescription)
        .doc(uid)
        .collection(FirebaseConstant.prescriptionList)
        .doc(prescription.id);

    final notifications = createNotificationsFromPrescription(prescription);
    prescription.notifications = notifications
        .map((e) => PrescriptionNotification(
            id: e.id, time: e.time.millisecondsSinceEpoch))
        .toList();
    // print(
    //     'Phungtd: createPrescriptionWorks : notifications -> ${notifications.first.toString()}');

    final scheduleNotification = scheduleNotifications(notifications);
    final createNewPrescription = prescriptionListRef.set(prescription.toMap());
    print("Cuong nh - before update med history");
    final createNewHistory = createMedHistory(prescription);
    print("Cuong nh - after update med history");

    final updateTakenMed = prescription.listPill
        .map((drug) => updateTakenMedWithNewPrescription(drug, prescription.id))
        .toList();

    // tao cau hoi cho nguoi dung
    final createUserQuestion = createUserQuestionNotify(prescription);
    return Future.wait([
      createNewPrescription,
      ...scheduleNotification,
      createNewHistory,
      ...updateTakenMed,
      createUserQuestion,
    ], eagerError: true);
  }

  Future<List> updatePrescriptionWorks(Prescription old, Prescription current) {
    final String uid = getUserId();
    final prescriptionListRef = FirebaseFirestore.instance
        .collection(FirebaseConstant.prescription)
        .doc(uid)
        .collection(FirebaseConstant.prescriptionList)
        .doc(current.id);
    correctPrescriptionDataBeforeCreating(current);
    final cancelOldNotification = cancelNotification(
        old.notifications.map((e) => e.notificationId).toList());
    final notifications =
        createNotificationsFromPrescription(current, fromDate: DateTime.now());
    current.notifications = notifications
        .map((e) => PrescriptionNotification(
            id: e.id, time: e.time.millisecondsSinceEpoch))
        .toList();
    final scheduleNotification = scheduleNotifications(notifications);

    final updateNewPrescription = prescriptionListRef.set(current.toMap());
    final updateNewHistory = updateMedHistory(old, current);

    return Future.wait([
      ...cancelOldNotification,
      ...scheduleNotification,
      updateNewPrescription,
      ...updateNewHistory
    ], eagerError: true);
  }

  correctPrescriptionDataBeforeCreating(Prescription prescription) {
    prescription.listPill.forEach((pill) {
      var theLastTakenTime = pill.drugTimeList.first;
      for (int i = 1; i < pill.drugTimeList.length; i++) {
        final time = pill.drugTimeList[i];
        if (time.compareTo(theLastTakenTime) > 0) {
          theLastTakenTime = time;
        }
      }
      final pillCompletedDate = DateTime(
        pill.completedAt.year,
        pill.completedAt.month,
        pill.completedAt.day,
        theLastTakenTime.hour,
        theLastTakenTime.minute,
      );
      print(
          'Phungtd: correctPrescriptionDataBeforeCreating: presc completed: ${prescription.completedAt},'
          'pill completed at: $pillCompletedDate, '
          'need to be replaced: ${pillCompletedDate.isAfter(prescription.completedAt)}');
      if (pillCompletedDate.isAfter(prescription.completedAt)) {
        prescription.completedAt = pillCompletedDate;
      }
    });
  }

  List<NotificationDetail> createNotificationsFromPrescription(
      Prescription prescription,
      {DateTime fromDate}) {
    List<NotificationDetail> notifications = [];
    final uid = getUserId();
    DateTime startDate;
    if (fromDate == null) {
      startDate = prescription.startedDate;
    } else {
      startDate = fromDate.isAfter(prescription.startedDate)
          ? fromDate
          : prescription.startedDate;
    }
    final dayCount = prescription.completedAt.dayDifference(startDate);
    for (int i = 0; i < dayCount; i++) {
      final currentDate = startDate.add(Duration(days: i));
      final drugList = prescription.listPill
          .where((drug) =>
              currentDate.isBetween(drug.startedAt, drug.completedAt) &&
              drug.dayOfWeekList.contains(currentDate.weekday))
          .toList();
      if (drugList.isNotEmpty) {
        List<DrugTime> drugTimeList = [];
        drugList.forEach((drug) {
          drug.drugTimeList.forEach((drugTime) {
            if (_getDrugTimeElementInList(drugTime, drugTimeList) == null &&
                validNotiHour(currentDate, drugTime)) {
              drugTimeList.add(drugTime);
            }
          });
        });
        drugTimeList.forEach((element) {
          final time = DateTime(currentDate.year, currentDate.month,
              currentDate.day, element.hour, element.minute);
          if (time.isAfter(startDate)) {
            final id = generateRandomInt();
            final payload = NotificationPayload(
              notiId: id,
              uid: uid,
              prescriptionId: prescription.id,
              time: time.millisecondsSinceEpoch,
              originalTime: time.millisecondsSinceEpoch,
            );
            final newNoti = NotificationDetail(
              id: id,
              time: time,
              title: null,
              body:
                  'Hãy đảm bảo bạn đừng bỏ lỡ nó! Uống những thuốc trong khung giờ ${getHourAndMinute(time)} và đánh dấu nó là đã uống',
              payload: payload.toJson(),
            );
            notifications.add(newNoti);
          }
        });
      }
    }
    return notifications;
  }

  bool validNotiHour(DateTime currentDay, DrugTime time) {
    final now = DateTime.now();
    return currentDay.isDayInFuture() ||
        (currentDay.isToday() &&
            (time.hour * 60 + time.minute > now.hour * 60 + now.minute));
  }

  Future<List<Future<void>>> createMedHistory(Prescription prescription,
      {DateTime startedDate}) async {
    List<Future<void>> results = [];
    final String uid = getUserId();
    final userHistoryRef = FirebaseFirestore.instance
        .collection(FirebaseConstant.medHistory)
        .doc(uid);
    final startDate = startedDate ?? prescription.startedDate;
    final dayCount = startDate.dayDifference(prescription.completedAt);
    for (int i = 0; i < dayCount; i++) {
      final currentDate = startDate.add(Duration(days: i));
      final ref = userHistoryRef
          .collection(currentDate.toFirestoreCollectionNameFormat())
          .doc(prescription.id);
      final drugList = prescription.listPill
          .where((drug) =>
              currentDate.isBetween(drug.startedAt, drug.completedAt) &&
              drug.dayOfWeekList.contains(currentDate.weekday))
          .toList();
      print('Phungtd: checkpoint 1:');
      if (drugList.isNotEmpty) {
        print('Phungtd: drug list size: ${drugList.length}');

        List<DrugHistoryItem> drugHistoryItemList = drugList.map((drug) {
          final drugHistory = DrugHistoryItem.fromDrug(drug)
            ..prescriptionId = prescription.id;
          return drugHistory;
        }).toList();

        List<String> images =
            await Future.wait(_getImageUrlsFromDrugList(drugHistoryItemList));
        if (images.length == drugHistoryItemList.length) {
          for (int i = 0; i < drugHistoryItemList.length; i++) {
            drugHistoryItemList[i].image = images[i];
          }
        }

        results.add(ref.set({
          FirebaseConstant.medList: drugHistoryItemList.map((history) {
            return history.toMap();
          }).toList(),
        }));
      }
      print('Phungtd: checkpoint 2:');
    }
    return results;
  }

  bool hasElementAfterNow(List<DrugTime> timeList) {
    final index = timeList.indexWhere((e) => isAfterNow(e));
    return index != -1;
  }

  bool isAfterNow(DrugTime time) {
    final now = DateTime.now();
    return time.hour * 60 + time.minute > now.hour * 60 + now.minute;
  }

  List<Future<String>> _getImageUrlsFromDrugList(
      List<DrugHistoryItem> drugItems) {
    List<Future<String>> results = [];
    drugItems.forEach((drugItem) {
      getDrugImage(registerId: drugItem.id);
    });
    return results;
  }

  _getDrugTimeElementInList(DrugTime time, List<DrugTime> list) {
    return list.firstWhere((element) {
      return element.hour == time.hour && element.minute == time.minute;
    }, orElse: () => null);
  }

  List<Future<void>> updateMedHistory(Prescription old, Prescription current) {
    // final startedDate = DateTime.now().add(Duration(days: 1));
    final startedDate = DateTime.now();
    final updateDate = DateTime.now().add(Duration(days: 1));
    final List<Future<void>> result = [];
    result.add(updateCurrentDaySchedule(old, current, startedDate));
    result.addAll(deleteOldSchedule(old, updateDate));
    result.add(createMedHistory(current, startedDate: updateDate));
    return result;
  }

  List<Future<void>> deleteOldSchedule(Prescription old, DateTime startDate) {
    final List<Future<void>> result = [];
    final String uid = getUserId();
    final userHistoryRef = FirebaseFirestore.instance
        .collection(FirebaseConstant.medHistory)
        .doc(uid);
    final dayCount = old.completedAt.dayDifference(startDate);
    for (int i = 0; i < dayCount; i++) {
      final currentDate = startDate.add(Duration(days: i));
      final ref = userHistoryRef
          .collection(currentDate.toFirestoreCollectionNameFormat())
          .doc(old.id);
      result.add(ref.delete());
    }
    return result;
  }

  Future<List<Future<void>>> updateCurrentDaySchedule(
      Prescription old, Prescription current, DateTime startDate) async {
    final List<Future<void>> result = [];
    final String uid = getUserId();
    final userHistoryRef = FirebaseFirestore.instance
        .collection(FirebaseConstant.medHistory)
        .doc(uid);

    //update for the current day
    final currentDayRef = userHistoryRef
        .collection(startDate.toFirestoreCollectionNameFormat())
        .doc(old.id);

    final currentDaySnapshot = await currentDayRef.get();
    //modify the taken time if have not drink

    print('Duyna: Update current day document if have not taken...');
    final medList = currentDaySnapshot[FirebaseConstant.medList] as List;

    medList.asMap().forEach((index, drug) {
      print('Duyna: idx: ${index}, value: ${drug}');
      final takeHours = drug[FirebaseConstant.medTime] as List;
      final cPill = current.listPill[index];
      // cPill.drugTimeList.forEach((drugTime) {
      //   takeHours.
      // });
      for (var i = 0; i < takeHours.length; i++) {
        takeHours[i]['hour'] = cPill.drugTimeList[i].hour;
        takeHours[i]['minute'] = cPill.drugTimeList[i].minute;
      }

      drug[FirebaseConstant.medList] = takeHours;
      medList[index] = drug;
    });

    print('DUYNA: UPDATE CURRENT DAY: ${medList}');

    result.add(currentDayRef.update({
      FirebaseConstant.medList: medList,
    }));

    return result;
  }

  Future<void> updateTakenMedWithNewPrescription(
    Drug drug,
    String newPrescriptionId,
  ) async {
    if (drug.id == null || drug.id.isEmpty) {
      return;
    }
    final String uid = getUserId();
    print('Phungtd: updateTakenMedWithNewPrescription: drugId: ${drug.id}');
    final ref = FirebaseFirestore.instance
        .collection(FirebaseConstant.takenDrugList)
        .doc(uid)
        .collection(FirebaseConstant.medList)
        .doc(drug.id);
    final med = await ref.get();
    if (med.exists) {
      final prescriptionIds = med[FirebaseConstant.prescriptionIds] as List;
      if (prescriptionIds.contains(newPrescriptionId)) {
        return;
      } else {
        prescriptionIds.add(newPrescriptionId);
        ref.update({
          FirebaseConstant.prescriptionIds: prescriptionIds,
        });
      }
    } else {
      return ref.set({
        FirebaseConstant.prescriptionIds: [newPrescriptionId],
        FirebaseConstant.lastTaken: null,
        FirebaseConstant.medName: drug.name,
        FirebaseConstant.id: drug.id,
      });
    }
  }

  Future<String> uploadImage(String path, String prescriptionId) async {
    final img = File(path);
    final uid = getUserId();
    final String fileName = 'prescription0.${p.extension(img.path)}';
    final String filePath =
        '${FirebaseConstant.prescriptionList}/$uid/$prescriptionId/$fileName}';
    final metaData = SettableMetadata(
      customMetadata: {
        'uid': uid,
        'prescriptionId': prescriptionId,
      },
    );
    try {
      final uploadedImgTask =
          await FirebaseStorage.instance.ref(filePath).putFile(img, metaData);
      if (uploadedImgTask.state == TaskState.success) {
        return filePath;
      } else {
        return '';
      }
    } on FirebaseException catch (e) {
      print(e);
      return '';
    } catch (anotherException) {
      print(anotherException);
      return '';
    }
  }

  @override
  Future<void> createUserQuestionNotify(
    Prescription prescription,
  ) {
    final String uid = getUserId();
    final String prescriptionId = prescription.id;
    final String prescriptionDiagnose = prescription.diagnose;
    final startDate = prescription.createdAt;
    final completeDate = prescription.completedAt;

    var noteDate = completeDate;

    print(
        'Hungvv: createUserQuestionNotify - prescriptionId: ${prescription.id}, uid: $uid');
    final userQuestionNotifyRef = FirebaseFirestore.instance
        .collection(FirebaseConstant.userStatusCollection)
        .doc(uid)
        .collection(FirebaseConstant.userNoteListCollection)
        .doc(prescriptionId);

    // neu ngay note1 trung ngay note 2 thi cho la ngay tiep theo
    if (startDate.year == completeDate.year &&
        startDate.month == completeDate.month &&
        startDate.day == completeDate.day) {
      noteDate = startDate.add(Duration(days: 1));
    }

    final userQuestionNotify = UserQuestionNotify(
      prescriptionId: prescriptionId,
      prescriptionDiagnose: prescriptionDiagnose,
      startDate: startDate,
      completeDate: completeDate,
      noteDate: noteDate,
    );
    return userQuestionNotifyRef.set(userQuestionNotify.toMap());
  }

  Future<List<UserQuestionNotify>> getUserQuestionNotify() async {
    String uid = getUserId();
    List<UserQuestionNotify> results = [];
    DateTime curTime = DateTime.now();

    CollectionReference userQuestionNotifyListRef = FirebaseFirestore.instance
        .collection(FirebaseConstant.userStatusCollection)
        .doc(uid)
        .collection(FirebaseConstant.userNoteListCollection);
    final documents = (await userQuestionNotifyListRef
            .where('note_date',
                isGreaterThanOrEqualTo:
                    DateTime(curTime.year, curTime.month, curTime.day, 0, 0))
            .where('note_date',
                isLessThanOrEqualTo:
                    DateTime(curTime.year, curTime.month, curTime.day, 23, 59))
            .where('user_status', isEqualTo: 0)
            .get())
        .docs;

    documents.forEach((document) {
      if (true) {
        final Map<String, dynamic> data = document.data();
        results.add(UserQuestionNotify.fromMap(data));
      }
    });

    return results;
  }

  Future<void> updateUserQuestionNotify(
      UserQuestionNotify userQuestionNotify) async {
    if (userQuestionNotify.prescriptionId == null) {
      return;
    }
    final String uid = getUserId();
    print(
        'Phungtd: updateTakenMedWithNewPrescription: drugId: ${userQuestionNotify.prescriptionId}');
    final ref = FirebaseFirestore.instance
        .collection(FirebaseConstant.userStatusCollection)
        .doc(uid)
        .collection(FirebaseConstant.userNoteListCollection)
        .doc(userQuestionNotify.prescriptionId);

    final med = await ref.get();
    if (med.exists) {
      return ref.update({
        FirebaseConstant.userNote: userQuestionNotify.userNote,
        FirebaseConstant.userStatus: userQuestionNotify.userStatus,
      });
    }
  }

  Future<List<DrugHistoryItemTime>> getMedHistoryAtTime(
    int selectedHour,
    int selectedMinute,
    DateTime selectedDay,
  ) async {
    // lay ngay hien tai va chuyen format collection
    final dateCollection = selectedDay.toFirestoreCollectionNameFormat();
    print('hungvv -datecollection $dateCollection');

    String uid = getUserId();
    final List<DrugHistoryItemTime> result = [];

    final prescriptionDayHistoryRef = FirebaseFirestore.instance
        .collection(FirebaseConstant.medHistory)
        .doc(uid)
        .collection(dateCollection);
    final medHistoryCollection = await prescriptionDayHistoryRef.get();

    await Future.forEach(medHistoryCollection.docs, (doc) async {
      if (doc.exists) {
        final medList = doc[FirebaseConstant.medList] as List;

        print('hungvv - medList ${medList.toString()}');
        for (Map element in medList) {
          List<DrugHistoryItemTime> drugs = [];
          (element[FirebaseConstant.medTime] as List).forEach((e) {
            print('hungvv - drug element 1 ${e.toString()}');
            print('hungvv -hour $selectedHour');
            print('hungvv -minute $selectedMinute');
            print('hungvv -day $selectedDay');
            if (e[FirebaseConstant.hour] == selectedHour &&
                e[FirebaseConstant.minute] == selectedMinute) {
              Map drugHistory = new Map();
              print('hungvv - drug element 2 ${e.toString()}');
              drugHistory[FirebaseConstant.amount] =
                  element[FirebaseConstant.amount];
              drugHistory[FirebaseConstant.note] =
                  element[FirebaseConstant.note];
              drugHistory[FirebaseConstant.medName] =
                  element[FirebaseConstant.medName];
              drugHistory[FirebaseConstant.id] = element[FirebaseConstant.id];
              drugHistory[FirebaseConstant.image] = "";
              drugHistory[FirebaseConstant.prescriptionId] =
                  element[FirebaseConstant.prescriptionId];

              drugHistory.addAll(e);
              var res = DrugHistoryItemTime.fromMap(drugHistory);
              drugs.add(res);
            }
          });
          result.addAll(drugs);
        }
      }
    });

    // final ids = result.map((e) => "${e.hour}:${e.minute}:${e.name}").toSet();
    // result.retainWhere((x) => ids.remove("${x.hour}:${x.minute}:${x.name}"));

    result.sort((a, b) {
      return a.compareTo(b);
    });
    return result;
  }

  Future<void> updateMedHistoryAtTime(
      List<DrugHistoryItemTime> lstDrugTime,
      int selectedHour,
      int selectedMinute,
      DateTime selectedDate,
      bool isDirect) async {
    // lay ngay hien tai va chuyen format collection
    DateTime curTime = selectedDate;
    final dateCollection = curTime.toFirestoreCollectionNameFormat();

    String uid = getUserId();

    final prescriptionDayHistoryRef = FirebaseFirestore.instance
        .collection(FirebaseConstant.medHistory)
        .doc(uid)
        .collection(dateCollection);

    // final prescriptionDayHistoryRef = FirebaseFirestore.instance
    //     .collection(FirebaseConstant.medHistory)
    //     .doc(uid)
    //     .collection('02_04_2021');

    print('Duyna: ${prescriptionDayHistoryRef}');
    final medHistoryCollection = await prescriptionDayHistoryRef.get();
    final docsList = medHistoryCollection.docs;
    await docsList.forEach((doc) async {
      if (doc.exists) {
        final ref = doc.reference;
        print(doc.reference);
        if (doc.exists) {
          final medList = doc[FirebaseConstant.medList] as List;
          lstDrugTime.forEach((drugTime) {
            if (drugTime.isOutside) {
              return;
            } else {
              final idx = medList.indexWhere(
                  (element) => element['ten_thuoc'] == drugTime.name);
              if (idx != -1) {
                print(
                    'Duyna: ${medList[idx][FirebaseConstant.medTime].toString()}');
                final idDrugTime = medList[idx][FirebaseConstant.medTime]
                    .indexWhere((time) => (time['hour'] == drugTime.hour &&
                        time['minute'] == drugTime.minute));
                if (idDrugTime != -1) {
                  if (!isDirect) {
                    medList[idx][FirebaseConstant.medTime][idDrugTime]
                        [FirebaseConstant.isTaken] = drugTime.isTaken;
                    medList[idx][FirebaseConstant.medTime][idDrugTime]
                        [FirebaseConstant.takenHour] = drugTime.takenHour;
                    medList[idx][FirebaseConstant.medTime][idDrugTime]
                        [FirebaseConstant.takenMinute] = drugTime.takenMinute;
                    medList[idx][FirebaseConstant.medTime][idDrugTime]
                        [FirebaseConstant.takenDate] = drugTime.takenDate;
                  } else {
                    final now = DateTime.now();
                    medList[idx][FirebaseConstant.medTime][idDrugTime]
                        [FirebaseConstant.isTaken] = drugTime.isTaken;
                    medList[idx][FirebaseConstant.medTime][idDrugTime]
                        [FirebaseConstant.takenHour] = now.hour;
                    medList[idx][FirebaseConstant.medTime][idDrugTime]
                        [FirebaseConstant.takenMinute] = now.minute;
                    medList[idx][FirebaseConstant.medTime][idDrugTime]
                        [FirebaseConstant.takenDate] = now;
                  }
                }
              }
            }
          });
          // print('Duyna: ${medList[0].toString()}');
          await ref.update({
            FirebaseConstant.medList: medList,
          });
        }
      }
    });

    //handle drug that does not include in any precription
    final outPrescriptionSnapshot = await FirebaseFirestore.instance
        .collection(FirebaseConstant.medHistory)
        .doc(uid)
        .collection(dateCollection)
        .doc('out_prescription')
        .get();

    //neu khong ton tai thuoc ngoai don
    if (outPrescriptionSnapshot == null || !outPrescriptionSnapshot.exists) {
      print('Duyna: Create out_prescription document...');
      List<dynamic> out_drugs = [];
      lstDrugTime.forEach((drug) {
        if (drug.isOutside) {
          drug.isTaken = true;
          drug.takenDate = selectedDate;
          drug.takenHour = DateTime.now().hour;
          drug.takenMinute = DateTime.now().minute;
          out_drugs.add(drug.toFirebaseMap());
        }
      });

      await prescriptionDayHistoryRef
          .doc('out_prescription')
          .set({FirebaseConstant.medList: out_drugs});
    } else {
      print('Duyna: Adding to out_prescription document...');

      final outPrescriptionRef = outPrescriptionSnapshot.reference;
      final medList = outPrescriptionSnapshot[FirebaseConstant.medList] as List;
      lstDrugTime.forEach((drug) {
        if (drug.isOutside) {
          drug.isTaken = true;
          drug.takenDate = selectedDate;
          drug.takenHour = DateTime.now().hour;
          drug.takenMinute = DateTime.now().minute;
          medList.add(drug.toFirebaseMap());
        }
      });

      await outPrescriptionRef.update({
        FirebaseConstant.medList: medList,
      });
    }
  }

  List<Future<void>> scheduleNotifications(
      List<NotificationDetail> notifications) {
    List<Future<void>> results = [];
    for (final noti in notifications) {
      results.add(_notificationRepository.schedule(noti));
    }
    return results;
  }

  List<Future<void>> cancelNotification(List<int> ids) {
    List<Future<void>> results = [];
    for (final id in ids) {
      results.add(_notificationRepository.cancel(id));
    }
    return results;
  }

  /// return the url of the image of a drug by passing its soDangKy
  // neu khong lay duoc theo so dang ky thi truyen ten thuoc + don thuoc de lay anh thuoc
  @override
  Future<String> getDrugImage(
      {String registerId = 'VN-', String doseUnit = ""}) async {
    final _fstorageInstance = FirebaseStorage.instance;
    if (registerId == '') registerId = 'VD-26325-17';
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
}
