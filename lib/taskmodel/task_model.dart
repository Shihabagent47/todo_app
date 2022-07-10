import 'package:flutter/material.dart';

class TaskModel{
  int? id;
  final String name;
  final String description;

  TaskModel({this.id,required this.name,required this.description});
  factory TaskModel.fromMap(Map<String,dynamic> jason) => TaskModel(id:jason["id"],name: jason["name"], description: jason["description"]);
  Map<String, dynamic> toMap(){
    return{
      "id":id,
      "name":name,
      "description":description
    };

  }

}