import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:todo_list/taskmodel/task_model.dart';

class DatabaseHelper{
//Creating Sigleton intance of the Database helper
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

//Check for database if not create one
 static Database? _database;
 Future<Database> get database async => _database ??= await _initDatabase();

 // method for initializing database
 Future <Database> _initDatabase() async{
 Directory documentsDirectory=await getApplicationDocumentsDirectory();
 String path =join(documentsDirectory.path,"task.do");
 return await openDatabase(path,version: 1,onCreate: _oncreate);
 }
//creates a database
Future _oncreate(Database db,int version) async {
   await db.execute('''CREATE TABLE task(id INTEGER PRIMARY KEY,name TEXT,description TEXT,complete INTEGER)''');
}

// Read the data base

Future<List <TaskModel>> getTask ()async {
   Database db =await instance.database;
   var task=await db.query('task' ,orderBy: "name");
   List <TaskModel> taskList=task.isNotEmpty? task.map((e) => TaskModel.fromMap((e))).toList():[];
   return taskList;
}


Future<int>add(TaskModel task) async {
   Database db= await instance.database;
   return await db.insert("task", task.toMap());
}

Future<int> remove (int id) async{
   Database db= await instance.database;
   return await db.delete("task",where: 'id = ?',whereArgs:[id]);
}

Future<int> update (TaskModel task) async{
   Database db= await instance.database;
   return await db.update('task', task.toMap(),
   where: 'id= ?',whereArgs: [task.id]);
}

}