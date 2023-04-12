import 'package:get_it/get_it.dart';
import 'package:today/screens/today_screen/today_screen_manager.dart';

final getIt = GetIt.instance;

void setupGetIt() {
  getIt.registerLazySingleton<TodayScreenManager>(() => TodayScreenManager());
}