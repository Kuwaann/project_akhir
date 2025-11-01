import 'package:project_akhir/models/user.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  // Gunakan Singleton pattern agar hanya ada satu instance database
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    // Kode openDatabase() yang sudah dijelaskan di langkah 2
    String path = join(await getDatabasesPath(), 'nama_database.db');
    
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDb,
    );
  }

  void _createDb(Database db, int version) async {
    await db.execute(
      '''CREATE TABLE user
      id_user INTEGER PRIMARY KEY AUTOINCREMENT, 
      namadepan_user TEXT, 
      namabelakang_user TEXT, 
      username_akun TEXT, 
      fotopath_akun
      )''',
    );
  }

  final String _userTable = 'user';
  Future<int> insertUser(User user) async {
    final db = await database;
  
    int idBaru = await db.insert(
      _userTable,
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    return idBaru;
  }
}