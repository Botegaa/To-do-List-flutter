import 'package:flutter/material.dart';
import 'package:flutter_list_app/components/todo_list_item.dart';
import 'package:flutter_list_app/models/todo.dart';
import 'package:flutter_list_app/repositories/todo_repository.dart';

class TodoListPage extends StatefulWidget {
  TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  final TextEditingController todoController = TextEditingController();
  final TodoRepository todoRepository = TodoRepository();

  List<Todo> todos = [];
  Todo? deletedTodo;
  int? deletedTodoPos;

   String? errorText;

  @override
  void initState(){
    super.initState();

    todoRepository.getTodolist().then((value) {
      setState(() {
        todos = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: todoController,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Adicione uma Tarefa',
                            hintText: 'Ex .Estudar Flutter',
                            errorText: errorText,
                            focusedBorder:OutlineInputBorder(borderSide:BorderSide(color: Color(0xff00d7f3) ) ), 
                            ),
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        String text = todoController.text;

                        if(text.isEmpty){
                          setState(() {
                            errorText = 'O titulo nao pode ser vazio';
                          });
                          return;
                        }

                        setState(() {
                          Todo newTodo =
                              Todo(title: text, dateTime: DateTime.now());
                          todos.add(newTodo);
                          errorText = null;
                        });
                        todoController.clear();
                        todoRepository.saveTodoList(todos);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff00d7f3),
                        padding: const EdgeInsets.all(16),
                      ),
                      child: const Icon(
                        Icons.add,
                        size: 30,
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 16),
                Flexible(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      for (Todo todo in todos)
                        TodoListItem(
                          todo: todo,
                          onDelete: onDelete,
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Voce possui ${todos.length} tarefas pendentes',
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    ElevatedButton(
                        onPressed: showDeleteConfirmation,
                        style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xff00d7f3),
                            padding: const EdgeInsets.all(16)),
                        child: const Text('Limpar')),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void onDelete(Todo todo) {
    deletedTodo = todo;
    deletedTodoPos = todos.indexOf(todo);
    
    setState(() {
      todos.remove(todo);
    });
    todoRepository.saveTodoList(todos);
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        'Tarefa ${todo.title} foi removida com sucesso!',
        style: const TextStyle(color: Color(0xff060708)),
      ),
      backgroundColor: Colors.white,
      action: SnackBarAction(
        label: 'Desfazer',
        textColor: const Color(0xff00d7f3),
        onPressed: () {
          setState(() {
            todos.insert(deletedTodoPos!, deletedTodo!);
          });
          todoRepository.saveTodoList(todos);
        },
      ),
      duration: const Duration(seconds: 5),
    ));
  }

  void showDeleteConfirmation() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Limpar tudo?'),
              content: const Text(
                  'Voce tem certeza que deseja apagar todas as tarefas?'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'Cancelar',
                    style: TextStyle(color: Color(0xff00d7f3)),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    deleteAllTodos();
                  },
                  child: const Text('Limpar Tudo',
                      style: TextStyle(color: Colors.red)),
                ),
              ],
            ));
  }
  void deleteAllTodos(){
    setState(() {
      todos.clear();
    });
    todoRepository.saveTodoList(todos);
  }
}
