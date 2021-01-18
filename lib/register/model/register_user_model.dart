import 'package:vauchar_test/global/helper/database_helper.dart';

class RegisterUserModel{

  String name;
  String emailId;
  String password;

  Map<String, dynamic> toMap(){
    Map<String, dynamic> map = Map();

    map[DatabaseHelper.COLUMN_USER_NAME] = name;
    map[DatabaseHelper.COLUMN_EMAIL_ID] = emailId;
    map[DatabaseHelper.COLUMN_PASSWORD] = password;

    return map;
  }

}