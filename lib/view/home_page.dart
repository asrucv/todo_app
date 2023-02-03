import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo/data/database.dart';
import 'package:todo/view/widgets/dialoge_box.dart';
import 'package:todo/view/widgets/todo_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // reference hive box
  final _myBox = Hive.box("myBox");
  ToDoDataBase dataBase = ToDoDataBase();
  @override
  void initState() {
    // if this is the 1st time open app create deflt data
    if (_myBox.get("TODOLIST") == null) {
      dataBase.createInitialdata();
    } else {
      dataBase.localdata();
    }
    super.initState();
  }

  // text editing controller
  final _controller = TextEditingController();

  // checkbox was taped
  void chackBoxChanged(bool? value, int index) {
    setState(() {
      dataBase.toDoList[index][1] = !dataBase.toDoList[index][1];
    });
    dataBase.updateDataBase();
  }

  // save new task
  void saveNewTask() {
    setState(() {
      dataBase.toDoList.add([_controller.text, false]);
      _controller.clear();
    });
    Navigator.of(context).pop();
    dataBase.updateDataBase();
  }

  // create new task
  void createNewTask() {
    showDialog(
      context: context,
      builder: (context) {
        return DialogBox(
          controller: _controller,
          onSave: saveNewTask,
          onCancel: () => Navigator.of(context).pop(),
        );
      },
    );
  }

  //delete task
  void deleteTask(int index) {
    setState(() {
      dataBase.toDoList.removeAt(index);
    });
    dataBase.updateDataBase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(centerTitle: true, title: const Text("TO DO")),
        floatingActionButton: FloatingActionButton(
          onPressed: createNewTask,
          child: const Icon(Icons.add),
        ),
        body: ListView.builder(
          itemCount: dataBase.toDoList.length,
          itemBuilder: (context, index) {
            return ToDoTile(
              taskName: dataBase.toDoList[index][0],
              taskCompleted: dataBase.toDoList[index][1],
              onChanged: ((value) => chackBoxChanged(value, index)),
              deleteFunction: (context) => deleteTask(index),
            );
          },
        ));
  }
}
