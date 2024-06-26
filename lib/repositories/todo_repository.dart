import 'package:flutter_list_app/models/todo.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

const todoListKey = 'todo_list';

class TodoRepository{
  late SharedPreferences sharedPreferences ;

 Future<List<Todo>>getTodolist() async{
   sharedPreferences = await SharedPreferences.getInstance();
   final String  jsonString = sharedPreferences.getString(todoListKey)?? '[]';
   final List jsonDecoded = json.decode(jsonString) as List;
   return jsonDecoded.map((e)=> Todo.fromJson(e)).toList();
 }

  void saveTodoList(List<Todo> todos){
    final jsonString = json.encode(todos);
    sharedPreferences.setString(todoListKey, jsonString);
  }

}