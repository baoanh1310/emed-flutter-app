import 'package:emed/data/repository/auth_repository_impl.dart';
import 'package:emed/data/repository/notification_repository.dart';
import 'package:emed/data/repository/notification_repository_impl.dart';
import 'package:emed/data/repository/prescription_repository.dart';
import 'package:emed/data/repository/drug_repository.dart';
import 'package:emed/data/repository/prescription_repository_impl.dart';
import 'package:emed/data/repository/drug_repository_impl.dart';
import 'package:get_it/get_it.dart';

import 'repository/auth_repository.dart';

GetIt serviceLocator = GetIt.instance;

void setupServiceLocator() {
  serviceLocator.registerLazySingleton<NotificationRepository>(
      () => NotificationRepositoryImpl());
  serviceLocator
      .registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl());
  serviceLocator.registerLazySingleton<PrescriptionRepository>(
      () => PrescriptionRepositoryImpl(serviceLocator<NotificationRepository>()));
  serviceLocator
      .registerLazySingleton<DrugRepository>(() => DrugRepositoryImpl());
}
