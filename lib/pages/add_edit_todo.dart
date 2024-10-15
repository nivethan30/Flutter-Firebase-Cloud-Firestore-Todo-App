import 'package:flutter/material.dart';

class AddEditTodo {
  FocusNode focusNode = FocusNode();

  AddEditTodo() {
    focusNode.requestFocus();
  }
  /// Show a modal bottom sheet with a text field and a 'Done' button to
  /// either add or edit a Todo.
  ///
  /// [context] is the build context of the widget that calls this function.
  /// [todoName] is the name of the Todo to be edited. If null, the modal is
  /// used to add a new Todo.
  /// [isEdit] is true if the modal is used to edit a Todo. Otherwise, it is
  /// used to add a new Todo.
  /// [controller] is the [TextEditingController] that controls the text field.
  /// [onDonePressed] is the callback function that is called when the 'Done'
  /// button is pressed. It is given the text of the text field as an argument.
  void show(
      {required BuildContext context,
      required String? todoName,
      required bool isEdit,
      required TextEditingController controller,
      required Function(String) onDonePressed}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom + 5,
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    isEdit ? "Edit Todo" : "Add New Todo",
                  ),
                  const SizedBox(height: 16.0),
                  TextField(
                      textCapitalization: TextCapitalization.sentences,
                      maxLength: 100,
                      controller: controller,
                      focusNode: focusNode,
                      onTapOutside: (event) {
                        focusNode.unfocus();
                      },
                      decoration: InputDecoration(
                        counterText: "",
                        hintText: 'Enter Todo Name',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(3)),
                      )),
                  const SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                          onPressed: () {
                            if (controller.text.isNotEmpty) {
                              onDonePressed(controller.text);
                            }
                          },
                          child: const Text(
                            'Done',
                          )),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
