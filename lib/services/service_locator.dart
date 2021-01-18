import 'package:get_it/get_it.dart';
import 'package:vauchar_test/global/helper/database_helper.dart';
import 'package:vauchar_test/global/helper/shared_preference_helper.dart';

GetIt locator = GetIt.instance;

void setupLocator(){
  locator.registerSingleton(SharedPreferenceHelper());
  locator.registerSingleton(DatabaseHelper());
}
