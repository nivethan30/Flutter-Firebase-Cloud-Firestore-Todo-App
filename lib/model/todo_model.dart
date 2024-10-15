// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';

class TodoModel {
  final String? id;
  final String title;
  final bool isDone;
  final Timestamp updatedAt;

  TodoModel(
      {this.id,
      required this.title,
      this.isDone = false,
      required this.updatedAt});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'isDone': isDone,
      'updatedAt': updatedAt,
    };
  }

  factory TodoModel.fromDoc(DocumentSnapshot doc) {
    return TodoModel(
        id: doc.id,
        title: doc['title'] as String,
        isDone: doc['isDone'] as bool,
        updatedAt: doc['updatedAt'] as Timestamp);
  }

  TodoModel copyWith({
    String? id,
    String? title,
    bool? isDone,
    Timestamp? updatedAt,
  }) {
    return TodoModel(
      id: id ?? this.id,
      title: title ?? this.title,
      isDone: isDone ?? this.isDone,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
