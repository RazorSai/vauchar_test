import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:vauchar_test/event_list/model/events_model.dart';

class DatabaseHelper {
  Database db;

  static final int _version = 1;

  static final _databaseName = "vauchar.db";

  //TABLE_NAME

  static final String TBL_USERS = "tbl_users";
  static final String TBL_EVENTS = "tbl_events";

  //Common Columns
  static final String COLUMN_ID = "clm_id";

  //User Table Columns
  static final String COLUMN_USER_NAME = "clm_user_name";
  static final String COLUMN_EMAIL_ID = "clm_email_id";
  static final String COLUMN_PASSWORD = "clm_password";

  //Event Table Columns
  static final String COLUMN_EVENT_NAME = "clm_event_name";
  static final String COLUMN_EVENT_LOCATION = "clm_event_location";
  static final String COLUMN_EVENT_START_DATE = "clm_event_start_date";
  static final String COLUMN_EVENT_END_DATE = "clm_event_end_date";
  static final String COLUMN_EVENT_DESCRIPTION = "clm_event_description";
  static final String COLUMN_EVENT_CATEGORY = "clm_event_category";

  DatabaseHelper() {
    initDatabase();
  }

  /*
  * We initialize the Database instance here.
  * The path is set to the data folder which is non accessible to normal user through file browser.
  *
  * */
  Future initDatabase() async {
    var dbPath = await getTemporaryDirectory();
    var databasePath = join(dbPath.path, _databaseName);
    db = await openDatabase(databasePath,
        onCreate: createDatabase,
        onUpgrade: upgradeDatabase,
        version: _version);
  }

  /*Here we execute database query to create table Favorites.*/
  Future<void> createDatabase(Database db, int version) async {
    db.execute(
        '''CREATE TABLE $TBL_USERS(
        $COLUMN_ID INTEGER PRIMARY KEY AUTOINCREMENT, 
        $COLUMN_USER_NAME TEXT, 
        $COLUMN_EMAIL_ID TEXT, 
        $COLUMN_PASSWORD TEXT)''');

    db.execute(
        '''CREATE TABLE $TBL_EVENTS(
        $COLUMN_ID INTEGER PRIMARY KEY AUTOINCREMENT, 
        $COLUMN_EVENT_NAME TEXT, 
        $COLUMN_EVENT_LOCATION TEXT, 
        $COLUMN_EVENT_START_DATE TEXT, 
        $COLUMN_EVENT_END_DATE TEXT, 
        $COLUMN_EVENT_DESCRIPTION TEXT, 
        $COLUMN_EVENT_CATEGORY TEXT)''');
  }

  Future<void> upgradeDatabase(
      Database db, int oldVersion, int newVersion) async {

  }

  Future<int> registerUser(Map<String, dynamic> registerMap) async{
    if(db == null){
      await initDatabase();
    }
    return await db.insert(TBL_USERS, registerMap);
  }

  Future<int> loginUser(String emailId, String password) async{
    if(db == null){
      await initDatabase();
    }
    List user = await db.query(TBL_USERS, where: '$COLUMN_EMAIL_ID = ? AND $COLUMN_PASSWORD = ?', whereArgs: [emailId, password]);
    return user.length;
  }

  Future<int> checkUserExists(String emailId) async{
    if(db == null){
      await initDatabase();
    }
    List user = await db.query(TBL_USERS, where: '$COLUMN_EMAIL_ID = ?', whereArgs: [emailId]);
    return user.length;
  }

  Future<int> createEvent(Map<String, dynamic> createEventMap) async{
    if(db == null){
      await initDatabase();
    }
    return await db.insert(TBL_EVENTS, createEventMap);
  }

  Future<List<EventsModel>> getEvents() async{
    if(db == null){
      await initDatabase();
    }
    var listMap = await db.query(TBL_EVENTS);
    return listMap.map((e) => EventsModel.fromJson(e)).toList();
  }

  Future<List<EventsModel>> getEventsFiltered(String filter) async{
    if(db == null){
      await initDatabase();
    }
    var listMap = await db.query(TBL_EVENTS, where: "$COLUMN_EVENT_CATEGORY = ?", whereArgs: [filter]);
    return listMap.map((e) => EventsModel.fromJson(e)).toList();
  }

}
