import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:task_flutter/features/product/domain/repository/repository.dart';
import '../../core/utils/validations.dart';
import '../Router/Router.dart';
import '../config/key.dart';
import '../data_source/dio_helper.dart';
import '../data_source/hive_helper.dart';
import '../services/media/my_media.dart';

GetIt locator = GetIt.instance;

Future<void> setupLocator() async {
  locator.registerLazySingleton(() => DataManager());
  locator.registerLazySingleton(() => DioService(ConstKeys.baseUrl));
  locator.registerLazySingleton(() => Routes());
  locator.registerLazySingleton(() => Validation());
  locator.registerLazySingleton(() => MyMedia());
  locator.registerLazySingleton(() => GlobalKey<ScaffoldState>());
  locator.registerLazySingleton(() => GlobalKey<NavigatorState>());
  locator.registerLazySingleton(() => ProductRepository(locator<DioService>()));
}
