// import 'dart:async';
// import 'package:flutter/cupertino.dart';
// import 'package:my_notes/extension/list/filter.dart';
// import 'package:path/path.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:sqflite/sqflite.dart';
// import 'crud_exceptions.dart';
//
// class NotesServices {
//   Database? _db;
//
//   List<DatabaseNotes>_notes=[];
//
//   DatabaseUser? _user;
//
//   static final NotesServices _shared =NotesServices._sharedInstances();
//
//   NotesServices._sharedInstances(){
//    _notesStreamController=StreamController<List<DatabaseNotes>>.broadcast(
//      onListen: (){
//        _notesStreamController.sink.add(_notes);
//      }
//    );
//   }
//
//   factory NotesServices()=>_shared;
//
//   late final StreamController<List<DatabaseNotes>> _notesStreamController;
//
//   Stream<List<DatabaseNotes>> get allNotes=>
//       _notesStreamController.stream.filter((note){
//         final currentUser=_user;
//         if(currentUser!=null){
//           return note.userId==currentUser.id;
//         }else{
//           throw UserShouldBeSetBeforeReadingAllNotes();
//         }
//       });
//
//   Future<DatabaseUser>getOrCreateUser({required String email,
//     bool setAsCurrentUser=true,
//   }) async {
//     try{
//       final user=await getUser(email: email);
//       if(setAsCurrentUser){
//         _user=user;
//       }
//       return user;
//     }on CouldNotFindUser{
//       final createdUser=await createUser(email: email);
//       if(setAsCurrentUser){
//         _user=createdUser;
//       }
//       return createdUser;
//     }catch(e){
//       rethrow;
//     }
//   }
//
//   Future<void>_cacheNote()async{
//     final allNotes=await getAllNotes();
//     _notes=allNotes.toList();
//     _notesStreamController.add(_notes);
//    }
//
//   Future<DatabaseNotes>updatesNotes({required DatabaseNotes note , required String text})async{
//     await ensueDbIsOpen();
//     final db=_getDatabaseOrThrow();
//     await getNote(id: note.id);
//     final updatesCount= await db.update(notesTable, {
//       textColumn:text,
//       isSyncedWithCloudColumn:0,
//
//     },
//         where: 'id=?',
//         whereArgs: [note.id]
//     );
//     if(updatesCount==0){
//       throw CouldNotUpdateNotes();
//     }else{
//       final updatedNote= await getNote(id: note.id);
//       _notes.removeWhere((note) =>note.id==updatedNote.id );
//       _notes.add(updatedNote);
//       _notesStreamController.add(_notes);
//       return updatedNote;
//     }
//   }
//
//   Future<Iterable<DatabaseNotes>> getAllNotes() async{
//     await ensueDbIsOpen();
//     final db=_getDatabaseOrThrow();
//     final notes=await db.query(notesTable);
//
//     return notes.map((notesRow) =>DatabaseNotes.fromRow(notesRow));
//   }
//
//   Future<DatabaseNotes>getNote({required int id})async{
//     await ensueDbIsOpen();
//     final db=_getDatabaseOrThrow();
//     final notes=await db.query(
//         notesTable,
//         limit: 1,
//         where:'id=?',
//         whereArgs:[id]
//     );if(notes.isEmpty){
//       throw CouldNotFindNotes();
//     }else{
//       final note= DatabaseNotes.fromRow(notes.first);
//       _notes.removeWhere((note) =>note.id==id );
//       _notes.add(note);
//       _notesStreamController.add(_notes);
//       return note;
//     }
//   }
//
//   Future<int>deleteAllNotes()async{
//     await ensueDbIsOpen();
//     await ensueDbIsOpen();
//     final db=_getDatabaseOrThrow();
//    final numberOfDeletions= await db.delete(notesTable);
//    _notes=[];
//    _notesStreamController.add(_notes);
//    return numberOfDeletions;
//   }
//
//   Future<void> deleteNote({required int id})async{
//     await ensueDbIsOpen();
//     final db=_getDatabaseOrThrow();
//     final deleteCount=await db.delete(notesTable,where: 'id= ?',whereArgs: [id]);
//     if(deleteCount==0){
//       throw CouldNotDeleteNote();
//     }else{
//       _notes.removeWhere((note) => note.id==id);
//       _notesStreamController.add(_notes);
//     }
//   }
//
//   Future<DatabaseNotes> createNotes({required DatabaseUser owner})async{
//     await ensueDbIsOpen();
//     final db=_getDatabaseOrThrow();
//     // make sure owner exists in the Database with the correct ID
//
//     final dbUser=await getUser(email:owner.email);
//     if(dbUser!=owner){
//       throw CouldNotFindUser();
//     }
//
//     const text='';
//     // create notes
//     final noteId =await db.insert(notesTable, {
//       userIdColumn:owner.id,
//       textColumn:text,
//       isSyncedWithCloudColumn:1
//     });
//
//     final note=DatabaseNotes(id: noteId, userId: owner.id, text: text, isSyncedWithCloud: true);
//     _notes.add(note);
//     _notesStreamController.add(_notes);
//     return note;
//   }
//
//   Future<DatabaseUser> getUser({required String email})async{
//     await ensueDbIsOpen();
//     final db=_getDatabaseOrThrow();
//     final results =await db.query(
//         userTable,
//         where: 'email=?',
//         whereArgs: [email.toLowerCase()]
//     );
//     if(results.isEmpty){
//       throw CouldNotFindUser();
//     }else{
//       return DatabaseUser.fromRow(results.first);
//     }
//   }
//
//   Database _getDatabaseOrThrow() {
//     final db = _db;
//     if (db == null) {
//       throw DatabaseIsNotOpen();
//     } else {
//       return db;
//     }
//   }
//
//   Future<DatabaseUser>createUser({required String email})async{
//     await ensueDbIsOpen();
//     final db=_getDatabaseOrThrow();
//      final results =await db.query(
//          userTable,
//          where: 'email=?',
//          whereArgs: [email.toLowerCase()]);
//      if(results.isNotEmpty){
//        UserAlreadyExists();
//      }
//     final userId=await db.insert(userTable, {
//        emailColumn : email.toLowerCase(),
//      });
//
//      return DatabaseUser(id:userId, email: email);
//   }
//
//   Future<void> deleteUser({required String email}) async {
//     await ensueDbIsOpen();
//     final db = _getDatabaseOrThrow();
//     final deleteCount = await db.delete(
//       userTable,
//       where: 'email=?',
//       whereArgs: [email.toLowerCase()],
//     );
//     if(deleteCount!=1){
//       throw CloudNotDeleteUser();
//     }
//   }
//
//   Future<void> close() async {
//     final db = _db;
//     if (db == null) {
//       throw DatabaseIsNotOpen();
//     } else {
//       await db.close();
//       _db = null;
//     }
//   }
//
//   Future<void>ensueDbIsOpen()async {
//     try{
//       await open();
//     }on DatabaseAlreadyOpenException{
//       //empty
//     }
//   }
//
//   Future<void> open() async {
//     if (_db != null) {
//       throw DatabaseAlreadyOpenException();
//     }
//     try {
//       final docsPath = await getApplicationDocumentsDirectory();
//       final dbPath = join(docsPath.path, dbName);
//       final db = await openDatabase(dbPath);
//       _db = db;
//
//       //creating user Table
//
//       await db.execute(createUserTable);
//
//       // creating Notes Table
//
//
//
//       await db.execute(createNotesTable);
//       await _cacheNote();
//     } on MissingPlatformDirectoryException {
//       throw UnableToGetDirectory();
//     }
//   }
// }
//
// @immutable
// class DatabaseUser {
//   final int id;
//   final String email;
//   const DatabaseUser({
//     required this.id,
//     required this.email,
//   });
//   DatabaseUser.fromRow(Map<String, Object?> map)
//       : id = map[idColumn] as int,
//         email = map[emailColumn] as String;
//
//   @override
//   String toString() => 'Person ID = $id, email =$email';
//
//   @override
//   bool operator ==(covariant DatabaseUser other) => id == other.id;
//
//   @override
//   int get hashCode => id.hashCode;
// }
//
// class DatabaseNotes {
//   final int id;
//   final int userId;
//   final String text;
//   final bool isSyncedWithCloud;
//
//   DatabaseNotes(
//       {required this.id,
//       required this.userId,
//       required this.text,
//       required this.isSyncedWithCloud});
//   DatabaseNotes.fromRow(Map<String, Object?> map)
//       : id = map[idColumn] as int,
//         userId = map[userIdColumn] as int,
//         text = map[textColumn] as String,
//         isSyncedWithCloud =
//             (map[isSyncedWithCloudColumn] as int) == 1 ? true : false;
//
//   @override
//   String toString() =>
//       'Note , ID =$id, userId =$userId, isSyncend with cloud $isSyncedWithCloud, text =$text';
//
//   bool operator ==(covariant DatabaseNotes other) => id == other.id;
//
//   @override
//   int get hashCode => id.hashCode;
// }
//
// const dbName = 'notes.db';
// const notesTable = 'notes';
// const userTable = 'user';
// const idColumn = 'id';
// const emailColumn = 'email';
// const userIdColumn = 'user_id';
// const textColumn = 'text';
// const isSyncedWithCloudColumn = 'isSyncedWithCloud';
// const createNotesTable=''' CREATE TABLE IF NOT EXISTS "notes" (
//           "id"  INTEGER NOT NULL,
//           "user_id" INTEGER NOT NULL,
//           "text" TEXT,
//           "isSyncedWithCloud" INTEGER NOT NULL DEFAULT 0,
//           FOREIGN KEY("user_id") REFERENCES  "notes" ("id" ),
//     PRIMARY KEY("id"  AUTOINCREMENT)
//     );
//    ''';
// const createUserTable = '''CREATE TABLE IF NOT EXISTS "user" (
// 	    "id"	INTEGER NOT NULL,
//     	"email"	TEXT NOT NULL UNIQUE,
//      	PRIMARY KEY("id")
//       );
//       ''';