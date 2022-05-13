import 'package:emed/screen/splash/splash_screen.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:rxdart/rxdart.dart';
import 'data/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:emed/provider/app_providers.dart';
import 'package:emed/shared/setting/app_router.dart';
import 'package:emed/shared/setting/navigation_service.dart';
import 'package:emed/shared/setting/theme.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

/// Streams are created so that app can respond to notification-related events
/// since the plugin is initialised in the `main` function
final BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject =
    BehaviorSubject<ReceivedNotification>();

final BehaviorSubject<String> selectNotificationSubject =
    BehaviorSubject<String>();

// const MethodChannel platform =
// MethodChannel('dexterx.dev/flutter_local_notifications_example');

class ReceivedNotification {
  ReceivedNotification({
    @required this.id,
    @required this.title,
    @required this.body,
    @required this.payload,
  });

  final int id;
  final String title;
  final String body;
  final String payload;
}

String selectedNotificationPayload;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initTimeZoneLocation();
  setupServiceLocator();

  await AppProvider().init();
  await initializeDateFormatting("vi");

  await initNotificationPlugin();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final String initialRoute;

  MyApp({@required this.initialRoute});

  final Future<FirebaseApp> _firebaseInit = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _firebaseInit,
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.done)
            return ScreenUtilInit(
              designSize: Size(375, 812),
              builder: () => MultiProvider(
                providers: AppProvider().providers,
                child: MaterialApp(
                  title: 'Emed',
                  debugShowCheckedModeBanner: false,
                  theme: appThemeData(),
                  navigatorKey: NavigationService().navigationKey,
                  onGenerateRoute: AppRouter.generateRoute,
                  // initialRoute: NOTIFICATION_SCREEN,
                  initialRoute: ROUTER_SPLASH,
                  // initialRoute: DUMMY_SCREEN,
                  // initialRoute: OCR_RESULT,
                ),
              ),
            );
          return Center(child: CircularProgressIndicator());
        });
  }
}

Future initTimeZoneLocation() async {
  tz.initializeTimeZones();
  final String currentTimeZone = await FlutterNativeTimezone.getLocalTimezone();
  tz.setLocalLocation(tz.getLocation(currentTimeZone));
}

Future<String> initNotificationPlugin() async {
  final NotificationAppLaunchDetails notificationAppLaunchDetails =
      await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
  String initialRoute = ROUTER_SPLASH;
  if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
    selectedNotificationPayload = notificationAppLaunchDetails.payload;
    initialRoute = NOTIFICATION_SCREEN;
  }

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('launch_image');

  /// Note: permissions aren't requested here just to demonstrate that can be
  /// done later
  final IOSInitializationSettings initializationSettingsIOS =
      IOSInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
          onDidReceiveLocalNotification:
              (int id, String title, String body, String payload) async {
            print(
                'Phungtd: Main -> Init setting IOS -> onDidReceiveLocalNotification: id: $id - payload: $payload');
            didReceiveLocalNotificationSubject.add(ReceivedNotification(
                id: id, title: title, body: body, payload: payload));
          });
  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (String payload) async {
    if (payload != null) {
      debugPrint('notification payload: $payload');
    }
    selectedNotificationPayload = payload;
    selectNotificationSubject.add(payload);
  });
  return initialRoute;
}
