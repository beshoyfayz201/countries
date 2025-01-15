import 'package:countriesmms/features/home_countries/data/model/countries_list/countries_list.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;
  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('countries.db');
    return _database!;
  }

  // Initialize the database
  Future<Database> _initDB(String filePath) async {
    final dbPath = await getApplicationDocumentsDirectory();
    final path = join(dbPath.path, filePath);
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  // Create the table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE countriesList(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT,
      capital TEXT,
      flag TEXT,
      population TEXT,
      flagImg TEXT,
      isFavorite INTEGER,
      currencies TEXT,
      languages TEXT
    );
    ''');
  }

  // Add a new country to the database
  Future<int> addCountry(CountriesList country) async {
    final db = await instance.database;
    return await db.insert('countriesList', country.toJson(),
        nullColumnHack: 'id');
  }

  // Remove a country by its ID
  Future<int> removeCountry(int id) async {
    final db = await instance.database;
    return await db.delete('countriesList', where: 'id = ?', whereArgs: [id]);
  }

  // Get all countries from the database
  Future<List<CountriesList>> getCountries() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query('countriesList');
    return List.generate(maps.length, (i) {
      return CountriesList.fromDB(maps[i]);
    });
  }

  // Update a country's information
  Future<int> updateCountry(CountriesList country) async {
    final db = await instance.database;
    return await db.update(
      'countriesList',
      country.toJson(),
      where: 'id = ?',
      whereArgs: [
        country.id
      ], // Ensure `id` is present in your `CountriesList` class
    );
  }
}
