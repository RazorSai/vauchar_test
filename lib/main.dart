import 'package:flutter/material.dart';
import 'package:vauchar_test/global/helper/shared_preference_helper.dart';
import 'package:vauchar_test/login/controller/login.dart';
import 'package:vauchar_test/services/service_locator.dart';

import 'event_list/controller/event_list_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      title: 'Vauchar Task',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: LoginScreen(),
    );
  }

}
