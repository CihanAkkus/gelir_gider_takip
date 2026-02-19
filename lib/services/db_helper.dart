import 'package:gelir_gider_takip/models/transaction_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:gelir_gider_takip/models/category_model.dart';

class DbHelper {
  static Database? _db;
  static const int _version = 2;

  static const String _tableName = "transactions";
  static const String _categoryTableName = "categories";

  //işlem sütunları
  static const String colId = 'id';
  static const String colTitle = 'title';
  static const String colAmount = 'amount';
  static const String colDesc = 'description';
  static const String colDate = 'date';
  static const String colType = 'type';

  //kategori sütunları
  static const String colCatId = 'id';
  static const String colCatName = 'name';
  static const String colCatIcon = 'iconCodePoint';

  static Future<void> initDb() async {
    if (_db != null) return;

    try {
      String path = join(await getDatabasesPath(), 'transactions.db');
      _db = await openDatabase(
        path,
        version: _version,
        onUpgrade: (db, oldVersion, newVersion) async {
          if (oldVersion < 2) {
            await db.execute("""
            CREATE TABLE $_categoryTableName ($colCatId TEXT PRIMARY KEY, $colCatName TEXT, $colCatIcon INTEGER)
            """);
          }
        },
        onCreate: (db, version) async {
          await db.execute("""
  CREATE TABLE $_tableName (
    $colId TEXT PRIMARY KEY,
    $colTitle TEXT,
    $colDesc TEXT,
    $colAmount REAL,
    $colDate TEXT,
    $colType TEXT
  )
""");
          await db.execute("""
          CREATE TABLE $_categoryTableName (
                  $colCatId TEXT PRIMARY KEY,
                  $colCatName TEXT,
                  $colCatIcon INTEGER
                )
          """);
        },
      );
    } catch (e) {
      print("DB Init Error: $e");
    }
  }

  static Future<int> insert(TransactionModel model) async {
    return await _db?.insert(_tableName, model.toJson()) ?? 0;
  }

  static Future<List<Map<String, dynamic>>> query() async {
    return await _db!.query(_tableName);
  }

  static Future<int> delete(String id) async {
    return await _db!.delete(_tableName, where: 'id = ?', whereArgs: [id]);
  }

  //kategori methodları
  static Future<int> insertCategory(CategoryModel model) async {
    return await _db?.insert(_categoryTableName,model.toJson()) ?? 0;
  }

  static Future<List<Map<String,dynamic>>>  queryCategory() async {
    return await _db!.query(_categoryTableName);
  }

  static Future<int> deleteCategory(String id) async{
    return await _db!.delete(_categoryTableName,where: 'id = ?', whereArgs: [id]);
  }

}
