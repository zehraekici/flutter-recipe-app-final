import 'dart:convert';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/user_recipe.dart';

class RecipeDB {
  // Singleton
  static final RecipeDB instance = RecipeDB._init();
  static Database? _database;

  RecipeDB._init();

  /// Eğer DB zaten varsa onu döndüryoksa oluştur
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB("recipes.db");
    return _database!;
  }

  // DB dosyasının yolu
  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  /// SQLite tablo oluşturma
  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE favorites (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        thumbnail TEXT,
        instructions TEXT,
        category TEXT,
        area TEXT,
        ingredients TEXT  -- JSON array (string)
      )
    ''');

    await db.execute('''
    CREATE TABLE user_recipes (
      id TEXT PRIMARY KEY,
      name TEXT NOT NULL,
      thumbnail TEXT,
      instructions TEXT,
      category TEXT,
      area TEXT,   
      ingredients TEXT,
      createdAt INTEGER,
      updatedAt INTEGER
    )
  ''');
  }

  /// Favori ekleme
  Future<int> addFavorite({
    required String id,
    required String name,
    required String thumbnail,
    required String instructions,
    required String category,
    required String area,
    required List<String> ingredients,
  }) async {
    final db = await instance.database;

    return await db.insert(
      "favorites",
      {
        "id": id,
        "name": name,
        "thumbnail": thumbnail,
        "instructions": instructions,
        "category": category,
        "area": area,
        "ingredients": jsonEncode(ingredients),
      },
      conflictAlgorithm: ConflictAlgorithm.ignore, // Duplicate engeli
    );
  }

  /// Favoriden silme
  Future<int> removeFavorite(String id) async {
    final db = await instance.database;

    return await db.delete("favorites", where: "id = ?", whereArgs: [id]);
  }

  /// Favori mi değil mi sorgusu
  Future<bool> isFavorite(String id) async {
    final db = await instance.database;

    final result = await db.query(
      "favorites",
      where: "id = ?",
      whereArgs: [id],
    );

    return result.isNotEmpty;
  }

  /// Tüm favorileri listele
  Future<List<Map<String, dynamic>>> getFavorites() async {
    final db = await instance.database;
    return await db.query("favorites");
  }

  // YENI EKLENDİ
  /// USER RECIPES — CRUD
  Future<int> insertUserRecipe(UserRecipe recipe) async {
    final db = await instance.database;
    return await db.insert(
      "user_recipes",
      recipe.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> deleteUserRecipe(String id) async {
    final db = await instance.database;
    return await db.delete("user_recipes", where: "id = ?", whereArgs: [id]);
  }

  Future<List<Map<String, dynamic>>> getUserRecipes() async {
    final db = await instance.database;
    return await db.query("user_recipes", orderBy: "createdAt DESC");
  }

  Future<Map<String, dynamic>?> getUserRecipeById(String id) async {
    final db = await instance.database;
    final result = await db.query(
      "user_recipes",
      where: "id = ?",
      whereArgs: [id],
    );

    if (result.isNotEmpty) return result.first;
    return null;
  }

  //YENI
  Future<int> updateUserRecipe(UserRecipe recipe) async {
    final db = await instance.database;
    return db.update(
      "user_recipes",
      recipe.toMap(),
      where: "id = ?",
      whereArgs: [recipe.id],
    );
  }
}
