import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/todo_model.dart';

class DatabaseService {
  final CollectionReference _todo =
      FirebaseFirestore.instance.collection("todo");

  /// A stream that emits a list of [TodoModel] each time the todos in the
  /// database change. The list is sorted by the "updatedAt" field in descending
  /// order, so the most recently updated todo appears first.
  ///
  /// This stream is useful for displaying a list of todos to the user, and for
  /// keeping the list up to date as the user edits the todos.
  Stream<List<TodoModel>> getTodos() {
    return _todo.snapshots().map((doc) {
      return doc.docs.map((doc) => TodoModel.fromDoc(doc)).toList();
    });
  }

  /// Adds the given [TodoModel] to the database. If the operation is
  /// successful, the returned [Future] completes with no value. If the
  /// operation fails, the returned [Future] completes with the error
  /// encountered.

  Future<void> addTodo(TodoModel todo) async {
    try {
      await _todo.add(todo.toMap());
    } catch (e) {
      rethrow;
    }
  }

  /// Updates the TodoModel with the given [id] to have the given [title]
  /// and [isDone] values. If the operation is successful, the returned
  /// [Future] completes with no value. If the operation fails, the returned
  /// [Future] completes with the error encountered.
  Future<void> updateTodo(TodoModel updatedTodo) async {
    try {
      await _todo.doc(updatedTodo.id).update(updatedTodo.toMap());
    } catch (e) {
      rethrow;
    }
  }

  /// Deletes the TodoModel with the given [id] from the database. If the
  /// operation is successful, the returned [Future] completes with no value.
  /// If the operation fails, the returned [Future] completes with the error
  /// encountered.
  Future<void> deleteTodo(String id) async {
    try {
      await _todo.doc(id).delete();
    } catch (e) {
      rethrow;
    }
  }
}
