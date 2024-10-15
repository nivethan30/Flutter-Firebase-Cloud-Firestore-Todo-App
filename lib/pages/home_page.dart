import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../database/database_service.dart';
import '../model/todo_model.dart';
import '../provider/theme_provider.dart';
import '../utils/theme.dart';
import 'add_edit_todo.dart';
import 'widgets/tile_widget.dart';

class HomePage extends StatefulWidget {
  final ThemeProvider themeProvider;
  const HomePage({super.key, required this.themeProvider});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DatabaseService _databaseService = DatabaseService();
  final TextEditingController _controller = TextEditingController();

  /// Pops the current context from the navigator that most tightly encloses the
  /// given [context].
  ///
  /// This method is used to close the add/edit dialog when the user is done
  /// editing a todo.
  void popContext() {
    Navigator.pop(context);
  }

  @override
  /// Disposes the [_controller] and calls the superclass [dispose] method.
  ///
  /// This method is called when the [State] object is removed from the tree.
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  /// Builds the home page of the app, which is a [Scaffold] with an [AppBar]
  /// and a [FloatingActionButton] to add new todos.
  ///
  /// The [AppBar] has a title of "Todo App", and a theme toggle button that
  /// shows a light or dark bulb icon depending on the current theme.
  ///
  /// The body of the [Scaffold] is a [StreamBuilder] that listens to the
  /// [_databaseService]'s [DatabaseService.getTodos] stream. If the
  /// connection state is waiting, a [CircularProgressIndicator] is shown.
  /// If there is an error, a [Text] widget with the error message is shown.
  /// If there are no todos, a [Text] widget with a message is shown.
  /// Otherwise, a [ListView.separated] is shown with all the todos in the
  /// database. Each todo is represented by a [TileWidget] that shows the
  /// todo's name, and has buttons to delete, edit, and toggle the status of
  /// the todo.
  ///
  /// The [FloatingActionButton] is used to add new todos. When pressed, it
  /// shows a [TextFormField] to enter the name of the new todo. When the
  /// [TextFormField] is submitted, the [_createTodo] function is called to
  /// create a new todo in the database.
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo App'),
        actions: [
          IconButton(
              tooltip: "Change Theme",
              onPressed: () {
                widget.themeProvider.toggleTheme();
              },
              icon: widget.themeProvider.themeData == AppTheme.lightTheme
                  ? const Icon(
                      Icons.brightness_4,
                    )
                  : const Icon(
                      Icons.brightness_7,
                    )),
          const SizedBox(width: 20),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: StreamBuilder<List<TodoModel>>(
            stream: _databaseService.getTodos(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator.adaptive(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text(snapshot.error.toString()),
                );
              } else {
                if (snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text('No Tasks. Add New Task'),
                  );
                } else {
                  return ListView.separated(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      TodoModel todo = snapshot.data![index];
                      return TileWidget(
                        controller: _controller,
                        todo: todo,
                        themeProvider: widget.themeProvider,
                        changeTodoStatus: () {
                          _toggleStatus(todo);
                        },
                        deleteTodo: () {
                          _deleteTodo(todo.id!);
                        },
                        editTodo: (newName) {
                          _updateTodoName(todo, newName);
                        },
                      );
                    },
                    separatorBuilder: (context, index) => const SizedBox(
                      height: 15,
                    ),
                  );
                }
              }
            }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _controller.clear();
          AddEditTodo().show(
              controller: _controller,
              context: context,
              todoName: null,
              onDonePressed: (value) {
                _createTodo(value);
              },
              isEdit: false);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  /// Creates a new [TodoModel] with the given [value] as its title,
  /// and the current time as its updated time. Then, it adds the
  /// created [TodoModel] to the database. If there is an error, it
  /// prints the error message to the console. Finally, it pops the
  /// current context.
  Future<void> _createTodo(String value) async {
    try {
      TodoModel todo = TodoModel(title: value, updatedAt: Timestamp.now());
      await _databaseService.addTodo(todo);
      popContext();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  /// Updates the title of the given [TodoModel] to [newName] and updates it in
  /// the database. If there is an error, it prints the error message to the
  /// console. Finally, it pops the current context.
  Future<void> _updateTodoName(TodoModel todo, String newName) async {
    try {
      TodoModel updatedTodo = todo.copyWith(title: newName);
      await _databaseService.updateTodo(updatedTodo);
      popContext();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  /// Toggles the isDone status of the given [TodoModel] and updates it in the
  /// database. If there is an error, it prints the error message to the
  /// console.
  Future<void> _toggleStatus(TodoModel todo) async {
    TodoModel updatedTodo = todo.copyWith(isDone: !todo.isDone);
    await _databaseService.updateTodo(updatedTodo);
  }

  /// Deletes the TodoModel with the given [id] from the database. If there is an
  /// error, it prints the error message to the console.
  Future<void> _deleteTodo(String id) async {
    try {
      await _databaseService.deleteTodo(id);
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
