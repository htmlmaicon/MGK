import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static const _databaseName = "clientes.db";
  static const _databaseVersion = 1;

  static const table = "usuarios";
  static const columnId = "id";
  static const columnCpf = "cpf";
  static const columnSenha = "senha";

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async =>
      _database ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $table (
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnCpf TEXT NOT NULL,
        $columnSenha TEXT NOT NULL
      )
    ''');

    // Inserindo usuário de teste
    await db.insert(table, {
      columnCpf: "12345678900",
      columnSenha: "1234",
    });
  }

  Future<bool> validateLogin(String cpf, String senha) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> result = await db.query(
      table,
      where: "$columnCpf = ? AND $columnSenha = ?",
      whereArgs: [cpf, senha],
    );
    return result.isNotEmpty;
  }
}
