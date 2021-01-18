import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceHelper{

  SharedPreferences _sharedPreferences;

  SharedPreferenceHelper(){
    initSharedPreference();
  }

  Future initSharedPreference() async{
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  void saveString(String key, String value) async{
    if(_sharedPreferences == null)
      await initSharedPreference();
    await _sharedPreferences.setString(key, value);
  }

  void saveBool(String key, bool value) async{
    if(_sharedPreferences == null)
      await initSharedPreference();
    await _sharedPreferences.setBool(key, value);
  }

  Future<bool> getBool(String key) async{
    if(_sharedPreferences == null)
      await initSharedPreference();
    return _sharedPreferences.getBool(key);
  }

}