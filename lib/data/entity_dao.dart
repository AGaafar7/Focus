import 'database_barrel.dart';

class EntityDao implements Dao<TodoData> {
  final tableName = 'Tasks';
  final columnId = 'id';
  final _columnTask = 'task';
  final _columnCompleted = 'completed';

  @override
  String get createTableQuery =>
      "CREATE TABLE IF NOT EXISTS $tableName($columnId INTEGER PRIMARY KEY AUTOINCREMENT,"
      "$_columnTask TEXT,"
      "$_columnCompleted BOOL)";

  @override
  Map<String, dynamic> toMap(TodoData object) {
    return <String, dynamic>{
      _columnTask: object.task,
      _columnCompleted: object.isCompleted
    };
  }
}
