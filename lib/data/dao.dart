abstract class Dao<D> {
  //queries
  String get createTableQuery;

  //to insert the data in the format of the database
  Map<String, dynamic> toMap(D object);
}
