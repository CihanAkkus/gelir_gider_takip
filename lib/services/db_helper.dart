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
  static const String colCategoryId = 'categoryId';
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
    $colCategoryId TEXT,
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
          await db.execute(
            "CREATE INDEX idx_transaction_type ON $_tableName ($colType)",
          );
          await db.execute(
            "CREATE INDEX idx_transaction_category ON $_tableName ($colCategoryId)",
          );
          await db.execute(
            "CREATE INDEX idx_transaction_date ON $_tableName ($colDate DESC)",
          );
        },
      );
    } catch (e) {
      print("DB Init Error: $e");
    }
  }

  static Future<int> insert(TransactionModel model) async {
    return await _db?.insert(_tableName, model.toJson()) ?? 0;
  }

  static Future<List<Map<String, dynamic>>> queryTransactions({
    int limit = 20,
    int offset = 0,
    String? searchQuery,
    String? categoryId,
    String? startDate,
  }) async {
    String whereClause = "1=1";
    List<dynamic> whereArgs = [];

    if (searchQuery != null && searchQuery.isNotEmpty) {
      whereClause += " AND $colTitle LIKE  ?";
      whereArgs.add('%$searchQuery%');
    }

    if (categoryId != null && categoryId.isNotEmpty) {
      whereClause += " AND $colCategoryId = ?";
      whereArgs.add(categoryId);
    }

    if (startDate != null) {
      whereClause += " AND $colDate >= ?";
      whereArgs.add(startDate);
    }

    return await _db!.query(
      _tableName,
      where: whereClause == "1=1" ? null : whereClause,
      whereArgs: whereArgs.isEmpty ? null : whereArgs,
      limit: limit,
      offset: offset,
      orderBy: '$colDate DESC',
    );
  }

  static Future<double> calculateTotalAmount(
    String type, {
    String? searchQuery,
    String? categoryId,
    String? startDate,
  }) async {
    String whereClause = "$colType = ?";
    List<dynamic> whereArgs = [type];

    if (searchQuery != null && searchQuery.isNotEmpty) {
      whereClause += " AND $colTitle LIKE ?";
      whereArgs.add('%$searchQuery%');
    }

    if (categoryId != null && categoryId.isNotEmpty) {
      whereClause += " AND $colCategoryId = ?";
      whereArgs.add(categoryId);
    }

    if (startDate != null) {
      whereClause += " AND $colDate >= ?";
      whereArgs.add(startDate);
    }

    var result = await _db!.rawQuery(
      "SELECT SUM($colAmount) as total FROM $_tableName WHERE $whereClause",
      whereArgs,
    );

    if (result.isNotEmpty && result.first['total'] != null) {
      return (result.first['total'] as num).toDouble();
    }
    return 0.0;
  }

  static Future<int> delete(String id) async {
    return await _db!.delete(_tableName, where: 'id = ?', whereArgs: [id]);
  }

  //kategori methodları
  static Future<int> insertCategory(CategoryModel model) async {
    return await _db?.insert(_categoryTableName, model.toJson()) ?? 0;
  }

  static Future<List<Map<String, dynamic>>> queryCategory() async {
    return await _db!.query(_categoryTableName);
  }

  static Future<int> deleteCategory(String id) async {
    return await _db!.delete(
      _categoryTableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
