import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'product_warranty.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createTables,
    );
  }

  Future<void> _createTables(Database db, int version) async {
    // Product table
    await db.execute('''
      CREATE TABLE product (
        id TEXT PRIMARY KEY,
        created_at TEXT,
        user_id TEXT,
        name TEXT,
        purchase_value INTEGER,
        description TEXT,
        purchase_date TEXT,
        validity_date TEXT,
        product_photo TEXT,
        product_bill TEXT,
        wcard_photo TEXT,
        category TEXT,
        last_updated TEXT,
        sync_status TEXT
      )
    ''');

    print('✅ Database tables created successfully');
  }

  // Method to check if tables exist (for debugging)
  Future<List<String>> getTables() async {
    final db = await database;
    final List<Map<String, dynamic>> result =
        await db.rawQuery("SELECT name FROM sqlite_master WHERE type='table'");
    return result.map((map) => map['name'] as String).toList();
  }

  Future<void> close() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }
}
