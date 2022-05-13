import 'package:emed/shared/setting/firebase_const.dart';
import 'package:flutter/material.dart';

class UserQuestionNotify {
  DateTime startDate;
  DateTime completeDate;
  String prescriptionDiagnose;
  String prescriptionId;
  DateTime noteDate;
  String userNote;
  int userStatus;

  UserQuestionNotify({
    @required this.prescriptionDiagnose,
    @required this.prescriptionId,
    noteDate,
    userNote,
    userStatus,
    @required this.startDate,
    @required this.completeDate,
  })  : this.userNote = userNote ?? '',
        this.userStatus = userStatus ?? 0,
        this.noteDate = noteDate ?? completeDate;

  UserQuestionNotify.fromMap(Map<String, dynamic> map) {
    prescriptionDiagnose = map[FirebaseConstant.prescriptionDiagnose];
    prescriptionId = map[FirebaseConstant.prescriptionId];
    completeDate = map[FirebaseConstant.completeDate].toDate();
    startDate = map[FirebaseConstant.startDate].toDate();
    noteDate = map[FirebaseConstant.dateNote].toDate();
    userNote = map[FirebaseConstant.userNote];
    userStatus = map[FirebaseConstant.userStatus];
  }

  Map<String, dynamic> toMap() {
    return {
      FirebaseConstant.prescriptionDiagnose: prescriptionDiagnose,
      FirebaseConstant.prescriptionId: prescriptionId,
      FirebaseConstant.startDate: startDate,
      FirebaseConstant.completeDate: completeDate,
      FirebaseConstant.dateNote: noteDate,
      FirebaseConstant.userNote: userNote,
      FirebaseConstant.userStatus: userStatus,
    };
  }
}

enum UserQuestionStatus { NONE, KHONG_DO, DO_IT, DO_NHIEU, DA_KHOE }

//  ['lọ', 'tube', 'viên', 'ống', 'hộp', 'gói', 'bút', 'chai']
Map<UserQuestionStatus, int> userQuestionStatusToInt = {
  UserQuestionStatus.NONE: 0,
  UserQuestionStatus.KHONG_DO: 1,
  UserQuestionStatus.DO_IT: 2,
  UserQuestionStatus.DO_NHIEU: 3,
  UserQuestionStatus.DA_KHOE: 4
};
