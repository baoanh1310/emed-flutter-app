import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class AppDatabase {
  static const _databaseName = 'emed.db';
  static const _databaseVersion = 1;

  factory AppDatabase() {
    if (_instance == null) {
      _instance = AppDatabase._getInstance();
    }
    return _instance;
  }
  static AppDatabase _instance;

  AppDatabase._getInstance();

  Database _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database;
    }
    _database = await _initDatabase();
    return _database;
  }

  Future _initDatabase() async {
    final path = await getDatabasesPath();
    final dbPath = join(path, _databaseName);
    return await openDatabase(
      dbPath,
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future _onCreate(Database db, int version) async {
   /* await db.execute('''
            // write sql command to create table
          )
          ''');*/
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < newVersion) {
      // TODO update db based on old version and new version
    }
  }
}