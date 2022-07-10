import 'package:flutter/material.dart';
import 'package:todo_list/detabase_helper/database_helper.dart';
import 'package:todo_list/taskmodel/task_model.dart';
class TaskAdd extends StatefulWidget {
  const TaskAdd({Key? key}) : super(key: key);

  @override
  State<TaskAdd> createState() => _TaskAddState();
}


class _TaskAddState extends State<TaskAdd> {
  final nameController= TextEditingController();
  final descriptController= TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

        TextField(decoration: InputDecoration(border: OutlineInputBorder(),hintText: "Enter task name"),controller: nameController,),
        TextField(decoration: InputDecoration(border: OutlineInputBorder(),hintText: "Enter task description"),controller:descriptController,),
        ElevatedButton(onPressed: (){
          addTask();
          setState((){
            nameController.clear();
            descriptController.clear();
          });
          Navigator.pop(context);
        }, child: Text("Add Task"))
      ],),
    );
  }

  void addTask() async{
  await DatabaseHelper.instance.add(TaskModel(name: nameController.text, description: descriptController.text));
}
}
