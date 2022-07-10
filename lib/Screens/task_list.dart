import 'package:flutter/material.dart';
import 'package:todo_list/Screens/task_add.dart';
import 'package:todo_list/detabase_helper/database_helper.dart';
import 'package:todo_list/taskmodel/task_model.dart';

class TaskList extends StatefulWidget {

  const TaskList({Key? key, required this.title}) : super(key: key);


  final String title;
  @override
  State<TaskList> createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: Text(widget.title),
      ),
      body: Center(
        child: FutureBuilder<List<TaskModel>>(
          future: DatabaseHelper.instance.getTask(),
          builder: (BuildContext context,AsyncSnapshot<List<TaskModel>> snapshot){
            if(!snapshot.hasData){
              return Center(child: Text("Loading"),);
            }
           return snapshot.data!.isEmpty?Center(child:Text("There is no data yet"))
               :
           ListView(children: snapshot.data!.map((data) => Center(child: ListTile(title: Text(data.name),subtitle: Text(data.description),),)).toList(),);
            }
          ,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: nextPage,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
    
   
  }
  void nextPage(){
    Navigator.push(context,  MaterialPageRoute(builder: (context) => const TaskAdd()),);
}
}
