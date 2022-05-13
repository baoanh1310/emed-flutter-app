import 'package:emed/data/model/drug_history_item_time.dart';
import 'package:emed/data/model/prescription.dart';
import 'package:emed/data/repository/notification_repository.dart';
import 'package:emed/screen/main/main_screen.dart';
import 'package:emed/screen/capture_screen/capture_screen.dart';
import 'package:emed/screen/instruction_screen/instruction_screen.dart';
import 'package:emed/screen/notification/notification_screen.dart' as noti;
import 'package:emed/screen/notification_screen/noti_screen.dart';
import 'package:emed/screen/ocr_result/ocr_result_screen.dart';
import 'package:emed/screen/pill_result/pill_result_card.dart';
import 'package:emed/screen/prescription_detail/prescription_detail_screen.dart';
import 'package:emed/screen/question_screen/dummy_screen.dart';
import 'package:emed/screen/sign_in/auth_screen.dart';
import 'package:emed/screen/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:emed/screen/splash/splash_screen.dart';
import "package:emed/screen/before_signin/introduction_screen.dart";
import "package:emed/screen/register/register_screen.dart";
import "package:emed/screen/forgot_password/send_email.dart";
import "package:emed/screen/forgot_password/confirm_email.dart";
import "package:emed/screen/set_schedule/schedule_prescription.dart";
import 'package:emed/screen/drug/drug_detail_screen.dart';
import "package:emed/components/drugDetail/drug_detail_screen.dart";
import "package:emed/screen/add_prescription/add_prescription_screen.dart";

const String ROUTER_SPLASH = "/";
const String ROUTER_AUTH = "auth";
const String ROUTER_HOME = "home";
const String ROUTER_INTRODUCTION = "introduction";
const String ROUTER_REGISTER = "register";
const String ROUTER_SEND_EMAIL_FORGOTPASSWORD = "send_email_forgotpassword";
const String ROUTER_CONFIRM_EMAIL_FORGOTPASSWORD =
    "confirm_email_forgotpassword";
const String ROUTER_MAIN = "main";
const String ROUTER_CAPTURE = "capture";
const String ROUTER_INSTRUCTION = "instruction";
const String ROUTER_ADD_PRESCRIPTION = "add_prescription";
const String OCR_RESULT = "ocr_result";
const String ROUTER_DRUG = "drug";
const String ROUTER_SCHEDULE = "schedule";
const String ROUTER_PRESCRIPTION_DETAIL = "prescription_detail";
const String ROUTER_DRUG_DETAIL = "drug_detail";
const String ROUTER_DRUG_DETAIL_WITH_PARTIALNAME = "drug_detail_partialname";
const String DUMMY_SCREEN = "dummy_screen";
const String ROUTER_TEST_NOTIFICATION_DETAIL_SCREEN = "notification_screen";
const String NOTIFICATION_SCREEN = "noti_screen";
const String PILL_OCR_RESULT_SCREEN = "pill_result_card";

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    Map<String, dynamic> arguments = settings.arguments;
    switch (settings.name) {
      case ROUTER_AUTH:
        return _getPageRoute(
          routeName: settings.name,
          viewToShow: AuthScreen(),
        );
      case ROUTER_HOME:
        return _getPageRoute(
          routeName: settings.name,
          viewToShow: HomeScreen(),
        );
      case ROUTER_SPLASH:
        return _getPageRoute(
            routeName: settings.name, viewToShow: SplashScreen());
      case ROUTER_ADD_PRESCRIPTION:
        return _getPageRoute(
            routeName: settings.name, viewToShow: AddPrescriptionScreen());
      case ROUTER_INTRODUCTION:
        return _getPageRoute(
            routeName: settings.name, viewToShow: IntroductionScreen());
      case ROUTER_REGISTER:
        return _getPageRoute(
            routeName: settings.name, viewToShow: RegisterScreen());
      case ROUTER_SEND_EMAIL_FORGOTPASSWORD:
        return _getPageRoute(
            routeName: settings.name,
            viewToShow: SendMailForgotPasswordScreen());
      case ROUTER_CONFIRM_EMAIL_FORGOTPASSWORD:
        return _getPageRoute(
            routeName: settings.name,
            viewToShow: ConfirmMailForgotPasswordScreen());
      case ROUTER_MAIN:
        return _getPageRoute(
            routeName: settings.name, viewToShow: MainScreen());
      case ROUTER_CAPTURE:
        final args = settings.arguments as Map;
        var isPill = false;
        if (args == null) {
          isPill = false;
        } else
          isPill = true;

        return _getPageRoute(
            routeName: settings.name,
            viewToShow: CaptureScreen(isPill: isPill));
      case ROUTER_INSTRUCTION:
        return _getPageRoute(
            routeName: settings.name, viewToShow: InstructionScreen());
      case OCR_RESULT:
        return _getPageRoute(
            routeName: settings.name, viewToShow: OcrResultScreen());
      case ROUTER_DRUG_DETAIL_WITH_PARTIALNAME:
        final String partialName = (settings.arguments as Map)['partialName'];
        return _getPageRoute(
            routeName: settings.name,
            viewToShow: DrugDetailComponent(partialName));
      case ROUTER_SCHEDULE:
        final Map data = settings.arguments;
        final Prescription prescription = data['prescription'];
        final bool isFromEditPrescription =
            data['isFromEditPrescription'] ?? false;
        final int indexDrug = data['indexDrug'];
        // print(prescription.completedAt)
        // print('_someMethod: Foo Error ${prescription.completedAt}}');
        return _getPageRoute(
          routeName: settings.name,
          viewToShow: SchedulePrescriptionScreen(
              prescription: prescription,
              isFromEditPrescription: isFromEditPrescription,
              indexDrug: indexDrug),
        );
      case ROUTER_DRUG_DETAIL:
        final Map drug = (settings.arguments as Map)['drug'];
        return _getPageRoute(
            routeName: settings.name, viewToShow: DrugDetailScreen(drug));
      case ROUTER_PRESCRIPTION_DETAIL:
        final String prescriptionId =
            (settings.arguments as Map)['prescriptionId'];
        final Prescription prescription =
            (settings.arguments as Map)['prescription'];
        return _getPageRoute(
            routeName: settings.name,
            viewToShow: PrescriptionDetailScreen(
              prescriptionId: prescriptionId,
              prescription: prescription,
            ));
      case DUMMY_SCREEN:
        return _getPageRoute(
            routeName: settings.name, viewToShow: DummyScreen());
      case ROUTER_TEST_NOTIFICATION_DETAIL_SCREEN:
        final String payload = (settings.arguments as Map)['payload'];
        // final String payload = 'fixed payload';
        return _getPageRoute(
            routeName: settings.name,
            viewToShow: noti.TestNotificationDetailScreen(payload: payload));
      case NOTIFICATION_SCREEN:
        final Map data = settings.arguments;
        final String payload = data['payload'];
        int hour;
        int minute;
        DateTime day;
        if (payload != null) {
          final noti = NotificationPayload.fromJson(payload);
          final dateTime =
              DateTime.fromMillisecondsSinceEpoch(noti.originalTime);
          hour = dateTime.hour;
          minute = dateTime.minute;
          day = dateTime;
        } else {
          hour = data['hour'];
          minute = data['minute'];
          day = data['day'];
        }

        return _getPageRoute(
            routeName: settings.name,
            viewToShow: NotificationScreen(
              hour: hour,
              minute: minute,
              day: day,
              notificationPayload: payload,
            ));
      case PILL_OCR_RESULT_SCREEN:
        final Map data = settings.arguments;
        final String imageUrl = data['imageUrl'];
        final List<DrugHistoryItemTime> lstDrugHistoryItem = data['pillList'];
        final DateTime selectedDate = data['selectedDate'];
        return _getPageRoute(
            routeName: settings.name,
            viewToShow: PillResultCard(
              imagePath: imageUrl,
              todayList: lstDrugHistoryItem,
              selectedDate: selectedDate,
            ));

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }

  static PageRoute _getPageRoute({String routeName, Widget viewToShow}) {
    return MaterialPageRoute(
      settings: RouteSettings(
        name: routeName,
      ),
      builder: (_) => viewToShow,
    );
  }
}
