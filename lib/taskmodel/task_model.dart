import 'package:flutter/material.dart';

class TaskModel{
  int? id;
  final String name;
  final String description;
  final int complete;

  TaskModel({this.id,required this.name,required this.description,required this.complete});
  factory TaskModel.fromMap(Map<String,dynamic> jason) => TaskModel(id:jason["id"],name: jason["name"], description: jason["description"],complete: jason["complete"]);
  Map<String, dynamic> toMap(){
    return{
      "id":id,
      "name":name,
      "description":description,
      "complete":complete
    };

  }

}