import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:io' as io;

import '../Model/UserModel.dart';

class DBHelper {
  static Database? _database;
  static const String DB_Name = 'test.db';
  static const Table_user = 'user';
  static const int Version = 1;

  static const String C_UserID = 'user_id';
  static const String C_UserName = 'user_name';
  static const String C_Email = 'email';
  static const String C_Password = 'password';

  Future<Database?> get db async{
    if(_database != null){
      return _database;
    }
    _database = await initDB();
    return _database;
  }
  initDB() async{
    io.Directory  doccumentDirectory = await getApplicationDocumentsDirectory();
    String path = join(doccumentDirectory.path,DB_Name);
    var db = await openDatabase(path, version: Version, onCreate: _onCreate);
    return db;
  }
  _onCreate(Database db, int version) async{
    await db.execute("CREATE TABLE $Table_user($C_UserID TEXT, $C_UserName TEXT,$C_Email TEXT, $C_Password TEXT,PRIMARY KEY ($C_UserID))");
  }
  Future<UserModel> saveData(UserModel user) async{
      var dbClient = await db;
      user.user_id = (await dbClient!.insert(Table_user, user.toMap())) as String;
      return user;
  }

  Future<UserModel?> getLoginUser(String userID, String password)async{
    var dbClient = await db;
    var res = await dbClient!.rawQuery("SELECT * FROM $Table_user"
        " WHERE $C_UserID = '$userID'"
        " and $C_Password = '$password'");

    if(res.length > 0){
      return UserModel.fromMap(res.first);
    }
      return null;
  }
}
