import 'database_barrel.dart';

abstract class Repository {
  late DatabaseProvider databaseProvider;

  //Insert
  Future<TodoData> insert(TodoData todoData);

  //Update task and make it completed
  Future<TodoData> updateComplete(TodoData todoData);

  //edit task
  Future<TodoData> editTask(TodoData todoData);

  //Delete
  Future<int> delete(int todoDataId);

  //Search specific Todo
  Future<List<Map>> searchTodo(TodoData todoData);

  //ReadAllData
  Future<List<Map>> readData();
}
