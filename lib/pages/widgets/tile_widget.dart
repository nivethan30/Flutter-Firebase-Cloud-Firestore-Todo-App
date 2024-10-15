import 'package:flutter/material.dart';
import '../../model/todo_model.dart';
import '../../provider/theme_provider.dart';
import '../../utils/theme.dart';
import '../add_edit_todo.dart';

class TileWidget extends StatelessWidget {
  final TodoModel todo;
  final VoidCallback changeTodoStatus;
  final VoidCallback deleteTodo;
  final Function(String value) editTodo;
  final ThemeProvider themeProvider;
  final TextEditingController controller;
  const TileWidget(
      {super.key,
      required this.todo,
      required this.changeTodoStatus,
      required this.deleteTodo,
      required this.editTodo,
      required this.themeProvider,
      required this.controller});

  @override
  /// Builds a tile widget that displays a todo's information and has buttons to
  /// change the todo's status, edit the todo, and delete the todo.
  ///
  /// When the tile is tapped, a modal bottom sheet is shown with a text field
  /// and a 'Done' button to edit the todo. The text field is pre-filled with
  /// the current title of the todo.
  ///
  /// The tile's color is determined by the current theme. In light theme, the
  /// tile is light grey. In dark theme, the tile is deep purple.
  ///
  /// The tile contains a circle avatar that shows a checkbox image. When the
  /// avatar is tapped, the todo's status is toggled.
  ///
  /// The tile also contains a text widget that displays the title of the todo.
  ///
  /// The tile also contains an 'Edit' button to edit the todo, and a 'Delete'
  /// button to delete the todo.
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        controller.text = todo.title;
        AddEditTodo().show(
            context: context,
            controller: controller,
            todoName: todo.title,
            isEdit: true,
            onDonePressed: editTodo);
      },
      child: Container(
        height: 70,
        width: double.maxFinite,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          color: themeProvider.themeData == AppTheme.lightTheme
              ? Colors.grey.shade300
              : Colors.deepPurple.shade800,
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: GestureDetector(
                onTap: changeTodoStatus,
                child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 20,
                    child: todo.isDone == false
                        ? const Icon(
                            Icons.check_box_outline_blank_rounded,
                            color: Colors.black,
                          )
                        : const Icon(
                            Icons.check_box_outlined,
                            color: Colors.black,
                          )),
              ),
            ),
            Expanded(
              flex: 5,
              child: Text(
                todo.title.toString(),
                style: const TextStyle(fontSize: 16),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
            const Expanded(flex: 1, child: SizedBox()),
            IconButton(
                onPressed: deleteTodo,
                icon: const Icon(
                  Icons.delete,
                ))
          ],
        ),
      ),
    );
  }
}
