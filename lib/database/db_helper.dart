import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static String tableName = 'Student';
  static const dbName = 'local_db.db';

  // static String id = 'id';
  static String lastName = 'lastName';
  static String firstName = 'firstName';

  static Future<Database> database() async {
    final dbPath = await getDatabasesPath();
    String path = join(dbPath, dbName);

    return await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute(
        "CREATE TABLE IF NOT EXISTS $tableName(id INTEGER PRIMARY KEY AUTOINCREMENT, "
        " $lastName TEXT NOT NULL,"
        " $firstName TEXT NOT NULL)",
      );
    });
  }

  static Future<List<Map<String, dynamic>>> selectAll(String table) async {
    final db = await DBHelper.database();
    return db.query(table);
  }

  static Future insert(String table, Map<String, Object> data) async {
    final db = await DBHelper.database();
    return db.insert(table, data, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future update(
    String table,
    String column,
    String value,
    int id,
  ) async {
    final db = await DBHelper.database();
    return db.update(
      table,
      {column: value},
      where: 'id = ? ',
      whereArgs: [id],
    );
  }

  static Future deleteById(
    String table,
    String column,
    int id,
  ) async {
    final db = await DBHelper.database();

    return db.delete(
      tableName,
      where: '$column = ?',
      whereArgs: [id],
    );
  }
}
