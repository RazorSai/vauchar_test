import 'package:vauchar_test/global/helper/database_helper.dart';

class EventsModel{

  String eventName;
  String eventLocation;
  String eventStartDate;
  String eventEndDate;
  String eventDescription;
  String eventCategory;

  EventsModel();

  factory EventsModel.fromJson(Map<String, dynamic> json){
    EventsModel eventsModel = EventsModel();

    eventsModel.eventName = json[DatabaseHelper.COLUMN_EVENT_NAME];
    eventsModel.eventLocation = json[DatabaseHelper.COLUMN_EVENT_LOCATION];
    eventsModel.eventStartDate = json[DatabaseHelper.COLUMN_EVENT_START_DATE];
    eventsModel.eventEndDate = json[DatabaseHelper.COLUMN_EVENT_END_DATE];
    eventsModel.eventDescription = json[DatabaseHelper.COLUMN_EVENT_DESCRIPTION];
    eventsModel.eventCategory = json[DatabaseHelper.COLUMN_EVENT_CATEGORY];

    return eventsModel;
  }

  Map<String, dynamic> toMap(){
    Map<String, dynamic> json = Map();

    json[DatabaseHelper.COLUMN_EVENT_NAME] = eventName;
    json[DatabaseHelper.COLUMN_EVENT_LOCATION] = eventLocation ;
    json[DatabaseHelper.COLUMN_EVENT_START_DATE] = eventStartDate;
    json[DatabaseHelper.COLUMN_EVENT_END_DATE] = eventEndDate;
    json[DatabaseHelper.COLUMN_EVENT_DESCRIPTION] = eventDescription;
    json[DatabaseHelper.COLUMN_EVENT_CATEGORY] = eventCategory;

    return json;
  }

}