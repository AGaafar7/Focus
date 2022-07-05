import 'database_barrel.dart';

class DatabaseRepository implements Repository {
  final dao = EntityDao();

  @override
  DatabaseProvider databaseProvider;

  DatabaseRepository(this.databaseProvider);

  @override
  Future<TodoData> insert(TodoData todoData) async {
    final db = await databaseProvider.db();
    todoData.id = await db.insert(
      dao.tableName,
      dao.toMap(todoData),
    );
    return todoData;
  }

  @override
  Future<TodoData> updateComplete(TodoData todoData) async {
    final db = await databaseProvider.db();
    await db.rawUpdate(
        'UPDATE ${dao.tableName} SET completed = ${todoData.isCompleted} WHERE id = ${todoData.id}');
    return todoData;
  }

  @override
  Future<TodoData> editTask(TodoData todoData) async {
    final db = await databaseProvider.db();
    await db.rawUpdate(
        'UPDATE ${dao.tableName} SET task = ? WHERE id = ${todoData.id}',
        [(todoData.task)]);
    return todoData;
  }

  @override
  Future<int> delete(int todoDataId) async {
    final db = await databaseProvider.db();
    await db.delete(
      dao.tableName,
      where: "${dao.columnId} = ?",
      whereArgs: [todoDataId],
    );
    return todoDataId;
  }

  @override
  Future<List<Map>> searchTodo(TodoData todoData) async {
    final db = await databaseProvider.db();
    List<Map> searchedTasks = await db.query(
      dao.tableName,
      columns: ['id', 'task', 'completed'],
      where: 'task LIKE ?',
      whereArgs: ['%${todoData.task}%'],
    );
    return searchedTasks;
  }

  @override
  Future<List<Map>> readData() async {
    final db = await databaseProvider.db();
    List<Map> userData = await db.query(dao.tableName);
    return userData;
  }
}
