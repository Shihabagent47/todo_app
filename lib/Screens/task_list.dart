import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:todo_list/detabase_helper/database_helper.dart';
import 'package:todo_list/taskmodel/task_model.dart';

class TaskList extends StatefulWidget {
  const TaskList({Key? key, required this.title}) : super(key: key);

  final String title;
  @override
  State<TaskList> createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  bool isChecked = false;
  int? selectedId;
  final nameController = TextEditingController();
  final descriptController = TextEditingController();
   final player=AudioPlayer();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: FutureBuilder<List<TaskModel>>(
          future: DatabaseHelper.instance.getTask(),
          builder:
              (BuildContext context, AsyncSnapshot<List<TaskModel>> snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: Text("Loading"),
              );
            }
            return snapshot.data!.isEmpty
                ? const Center(child: Text("There is no data yet"))
                : ListView(
                    children: snapshot.data!
                        .map((data) => Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Card(
                                    child: ListTile(
                                  title:data.complete==1?Text(data.name, style:  TextStyle(
                                      decoration: TextDecoration.lineThrough
                                  )):Text(data.name),
                                  subtitle: Text(data.description),
                                  trailing: Checkbox(
                                    checkColor: Colors.white,
                                    value:isChecked= data.complete==0?false:true,

                                    onChanged: (bool? value) {
                                      setState(() {

                                     if(data.complete==0) {
                                       player.play(AssetSource('done.mp3'));
                                       DatabaseHelper.instance.update(TaskModel(
                                           id: data.id,
                                           name: data.name,
                                           description: data.description,
                                           complete: 1));
                                     }
                                     else{
                                       DatabaseHelper.instance.update(TaskModel(id:data.id,name: data.name, description: data.description, complete: 0));

                                     }

                                      });
                                    },
                                  ),
                                      onLongPress:() {setState((){DatabaseHelper.instance.remove(data.id!);});},
                                      onTap: (){
                                    setState((){
                                      nameController.text=data.name;
                                      descriptController.text=data.description;
                                      selectedId=data.id;
                                      modalSheet();
                                    });
                                },
                                )),
                              ),
                            ))
                        .toList(),
                  );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: modalSheet,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void addTask() async {
    selectedId!=null?await DatabaseHelper.instance.update(TaskModel(id:selectedId,name: nameController.text, description: descriptController.text,complete: 0)):
    await DatabaseHelper.instance.add(TaskModel(
        name: nameController.text, description: descriptController.text,complete:0));
  }

  void modalSheet() {
    showModalBottomSheet<void>(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: Container(
            height: 200,

            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
               Padding(
                 padding: const EdgeInsets.all(8.0),
                 child: Column(children: [   TextField(
                   decoration: const InputDecoration(
                       border: OutlineInputBorder(),
                       hintText: "Enter task name"),
                   controller: nameController,
                 ),
                   TextField(
                     decoration: const InputDecoration(
                         border: OutlineInputBorder(),
                         hintText: "Enter task description"),
                     controller: descriptController,
                   ),],),
               ),
                  ElevatedButton(
                      onPressed: () {
                         player.play(AssetSource('upload.mp3'));
                        setState(() {
                          addTask();
                          nameController.clear();
                          descriptController.clear();
                          selectedId=null;
                        });
                        Navigator.pop(context);
                      },
                      child: Text("Add Task"))
                ],
              ),
            ),
          ),
        );
      },
    );

    // Navigator.push(context,  MaterialPageRoute(builder: (context) => const TaskAdd()),);
  }
}
