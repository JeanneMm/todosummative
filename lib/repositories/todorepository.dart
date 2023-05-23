import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:get/get.dart';

class TodoRepository {
  CollectionReference<Map<String, dynamic>> get todosCollection =>
      FirebaseFirestore.instance.collection('ToDo App');

  Future createTask(String text) async {
    await todosCollection.add({'todotext': text});
  }

  Future updateTask(String id, String text) async {
    await todosCollection.doc(id).update({'todotext': text});
  }

  Future deleteTask(String id) async {
    await todosCollection.doc(id).delete();
  }
}