import 'package:flutter/material.dart';

import 'database_barrel.dart';

class MyTaskFunction {
  final dataRepo = DatabaseRepository(DatabaseProvider.get);
  final TextEditingController textController;
  bool isDone = false;
  TodoData todoData;

  BuildContext context;
  // make this a factory class
  MyTaskFunction(this.context, this.textController, this.isDone, this.todoData);

  Future<List<Map>> getTasksList() async {
    List<Map> databaseList = await dataRepo.readData();
    return databaseList;
  }

  Future<List<Map>> searchTasks(TodoData todoData) async {
    List<Map> searchedTasks = await dataRepo.searchTodo(todoData);
    return searchedTasks;
  }

  checkCompleted(int done) {
    if (done == 0) {
      isDone = false;
      return Icon(
        Icons.radio_button_unchecked,
        color: Theme.of(context).iconTheme.color,
      );
    } else if (done == 1) {
      isDone = true;
      return Icon(
        Icons.check_circle_outline,
        color: Theme.of(context).iconTheme.color,
      );
    }
  }

  checkTextCompletedDeco(int done) {
    if (done == 0) {
      isDone = false;
      return TextDecoration.none;
    } else if (done == 1) {
      isDone = true;
      return TextDecoration.lineThrough;
    }
  }

  editTask(int id, String task, int isCompleted) async {
    TodoData taskEdit = TodoData(id, task, isCompleted);
    await dataRepo.editTask(taskEdit);
  }

  deleteTodo(int id) async {
    await dataRepo.delete(id);
  }

  markAsDone(final listData, index) async {
    if (listData[index]['completed'] == 0) {
      isDone = true;
      await dataRepo.updateComplete(TodoData(listData[index]['id'],
          listData[index]['task'], listData[index]['completed'] + 1));
    } else if (listData[index]['completed'] == 1) {
      isDone = false;
      await dataRepo.updateComplete(TodoData(listData[index]['id'],
          listData[index]['task'], listData[index]['completed'] - 1));
    }
  }

  chooseList(bool chooser, todoData) {
    if (chooser == true) {
      return getTasksList();
    } else if (chooser == false) {
      return searchTasks(todoData);
    }
  }
}
