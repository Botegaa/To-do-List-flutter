import 'package:flutter/material.dart';
import 'package:flutter_list_app/screens/todo_list.dart';

void main(){
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      theme: ThemeData.light().copyWith(
        useMaterial3: false
      ),
      debugShowCheckedModeBanner: false,
      home:  TodoListPage(),
    );
  }
}
