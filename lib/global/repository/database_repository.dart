import 'package:vauchar_test/event_list/model/events_model.dart';
import 'package:vauchar_test/global/helper/database_helper.dart';
import 'package:vauchar_test/register/model/register_user_model.dart';
import 'package:vauchar_test/services/service_locator.dart';

class DatabaseRepository{

  DatabaseHelper helper = locator<DatabaseHelper>();

  Future<int> registerUser(RegisterUserModel registerUserModel) async{
    return await helper.registerUser(registerUserModel.toMap());
  }

  Future<int> loginUser(String emailId, String password) async{
    return await helper.loginUser(emailId, password);
  }

  Future<int> userExists(String emailId) async{
    return await helper.checkUserExists(emailId);
  }

  Future<int> createEvent(EventsModel eventsModel) async{
    return await helper.createEvent(eventsModel.toMap());
  }

  Future<List<EventsModel>> getEvents() async{
    return await helper.getEvents();
  }

  Future<List<EventsModel>> getEventsFiltered(String filter) async{
    return await helper.getEventsFiltered(filter);
  }

}