import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper{
  static const dbName='notes.db';
  static const notesTable='notes';
  static const userTable='user';
  static const columnId='id';
  static const userIdColumn='user_id';
  static const emailColumn='email';
  static const textColumn='text';
  
  DatabaseHelper instance= DatabaseHelper();
  
  //initialization of database
 Database? _database;
Future<Database?> get database async {
  if(_database!=null){
    return _database;
  }else{
    _database=await initDB();
  }
  return _database;
}
  initDB() async {
  Directory directory = await getApplicationDocumentsDirectory();
  String path = join(directory.path,dbName);
  final db= await openDatabase(path);
  _database=db;
  //creating user Table
  const createUserTable = '''CREATE TABLE IF NOT EXISTS $userTable (
    $columnId INTEGER PRIMARY KEY,
    $emailColumn TEXT NOT NULL UNIQUE,
    $userIdColumn INTEGER NOT NULL
);
''';

  await db.execute(createUserTable);
  // creating notes Table
  const createNotesTable = '''
CREATE TABLE IF NOT EXISTS $notesTable (
    $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
    $userIdColumn INTEGER NOT NULL,
    $textColumn TEXT NOT NULL,
    FOREIGN KEY ($userIdColumn) REFERENCES $userTable ($columnId)
)
''';

  }

  // Insert Method for notes
inset(Map<String ,dynamic>row) async {
  Database? db= await instance.database;
  return await db?.insert(notesTable,row);
}

// Read from database for notes
Future<List<Map<String , dynamic>>>readfromDatabase()async{
  Database? db= await instance.database;
  return db!.query(notesTable);
}

// update for notes
Future<int>updateRecord(Map<String , dynamic>row) async {
  Database? db= await instance.database;
  int id=row[columnId];
  return db!.update(notesTable,row, where:'$columnId=?',whereArgs:[id] );
}
//delete for notes
Future<int>deleteRecord(int id)async{
  Database? db= await instance.database;
  return db!.delete(notesTable,where: '$columnId=?',whereArgs: [id]);
}
// Insert Method for Users
  Future<int> insertUser(Map<String, dynamic> row) async {
    Database? db = await instance.database;
    return await db!.insert(userTable, row);
  }

  // Read Method for Users
  Future<List<Map<String, dynamic>>> readUsersFromDatabase() async {
    Database? db = await instance.database;
    return db!.query(userTable);
  }

  // Update Method for Users
  Future<int> updateUser(Map<String, dynamic> row) async {
    Database? db = await instance.database;
    int id = row[columnId];
    return db!.update(userTable, row, where: '$columnId = ?', whereArgs: [id]);
  }

  // Delete Method for Users
  Future<int> deleteUser(int id) async {
    Database? db = await instance.database;
    return db!.delete(userTable, where: '$columnId = ?', whereArgs: [id]);
  }

  }
