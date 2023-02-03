import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ToDoDataBase {
  List toDoList = [];

  // refference the box
  final _myBox = Hive.box("myBox");

  // run this method if this is the 1st time ever open app
  void createInitialdata() {
    toDoList = [
      ["Read Books", false],
      ["Do Exercise", false]
    ];
  }
  // load data from database
  void localdata() {
    toDoList = _myBox.get("TODOLIST");
  }
  // update database
  void updateDataBase() {
    _myBox.put("TODOLIST", toDoList);
  }
}
