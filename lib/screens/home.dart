import 'package:flutter/material.dart';
import 'package:flutter_todo_app/repositories/todorepository.dart';

import '../Services/notifi_service.dart';
import '../model/todo.dart';
import '../constants/colors.dart';
import '../widgets/todo_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Home extends StatefulWidget {
  const Home({Key? key, required String title}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

TodoRepository _todoRepsoitory = TodoRepository();

class _HomeState extends State<Home> {
  final todosList = ToDo.todoList();
  final _todoController = TextEditingController();
  final CollectionReference<Map<String, dynamic>> _todos =
      _todoRepsoitory.todosCollection;
  late Stream<QuerySnapshot<Map<String, dynamic>>> todoStream;

  @override
  void initState() {
    super.initState();
    todoStream = _todos.snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tdBGColor,
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 15,
            ),
            child: Column(
              children: [
                searchBox(),
                const Text(
                  'All ToDos',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Expanded(
                  child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                      stream: todoStream,
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Text(snapshot.error.toString());
                        }

                        if (snapshot.connectionState ==
                                ConnectionState.waiting ||
                            snapshot.hasData == false) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const <Widget>[
                                CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Color(0xFF4796BD))),
                                // Loader Animation Widget
                                Padding(padding: EdgeInsets.only(top: 20.0)),
                              ],
                            ),
                          );
                        }

                        if (snapshot.data == null ||
                            snapshot.data!.docs.isEmpty) {
                          return Column(
                            children: const <Widget>[
                              Center(child: Text("Unable to find any records"))
                            ],
                          );
                        }
                        if (snapshot.hasData) {
                          NotificationService().showNotification(
                              title: 'Reminder',
                              body: ' Time to do ur next plan ');
                          return ListView.builder(
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (BuildContext context, int index) {
                              return ToDoItem(
                                todo: ToDo(
                                    id: snapshot.data!.docs[index].id,
                                    todoText: snapshot.data!.docs[index]
                                            ['todotext'] ??
                                        'Empty'),
                                onToDoChanged: _handleToDoChange,
                                onDeleteItem: _deleteToDoItem,
                              );
                            },
                          );
                        }
                        return const Center(
                            child: Text('Something went wrong!!'));
                      }),
                )
              ],
            ),
          ),
          // Center(
          //     child: ElevatedButton(
          //   child: const Text('Show notifications'),
          //   onPressed: () {

          //   },
          // )),
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(children: [
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(
                    bottom: 20,
                    right: 20,
                    left: 20,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.grey,
                        offset: Offset(0.0, 0.0),
                        blurRadius: 10.0,
                        spreadRadius: 0.0,
                      ),
                    ],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextField(
                    controller: _todoController,
                    decoration: const InputDecoration(
                        hintText: 'Add a new item', border: InputBorder.none),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(
                  bottom: 20,
                  right: 20,
                ),
                child: ElevatedButton(
                  onPressed: () {
                    _addToDoItem(_todoController.text);
                  },
                  style: ElevatedButton.styleFrom(
                    primary: tdBlue,
                    minimumSize: const Size(60, 60),
                    elevation: 10,
                  ),
                  child: const Text(
                    '+',
                    style: TextStyle(
                      fontSize: 40,
                    ),
                  ),
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }

  void _handleToDoChange(ToDo todo) {
    setState(() {
      todo.isDone = !todo.isDone;
    });
  }

  void _deleteToDoItem(String id) {
    _todoRepsoitory.deleteTask(id);
  }

  void _addToDoItem(String toDo) {
    _todoRepsoitory.createTask(toDo);
  }

  void _runFilter(String enteredKeyword) {
    List<ToDo> results = [];
    if (enteredKeyword.isEmpty) {
      results = todosList;
    } else {
      setState(() {
        todoStream = _todos
            .where('todotext',
                isGreaterThanOrEqualTo: enteredKeyword,
                isLessThan: enteredKeyword.substring(
                        0, enteredKeyword.length - 1) +
                    String.fromCharCode(
                        enteredKeyword.codeUnitAt(enteredKeyword.length - 1) +
                            1))
            .snapshots();
      });
    }
  }

  Widget searchBox() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextField(
        onChanged: (value) => _runFilter(value),
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.all(0),
          prefixIcon: Icon(
            Icons.search,
            color: tdBlack,
            size: 20,
          ),
          prefixIconConstraints: BoxConstraints(
            maxHeight: 20,
            minWidth: 25,
          ),
          border: InputBorder.none,
          hintText: 'Search',
          hintStyle: TextStyle(color: tdGrey),
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: tdBGColor,
      elevation: 0,
      title: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        const Icon(
          Icons.menu,
          color: tdBlack,
          size: 30,
        ),
        SizedBox(
          height: 40,
          width: 40,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.asset('images/list.jpg'),
          ),
        ),
      ]),
    );
  }
}
