import 'package:flutter/foundation.dart';
import '../database/recipe_db.dart';
import '../models/favorite_entry.dart';
import '../models/recipe.dart';


class FavsManager extends ChangeNotifier {
  // DB'den gelen favori listesini FavoriteEntry şeklinde bellekte tut

  List<FavoriteEntry> _favorites = [];

  List<FavoriteEntry> get entries => _favorites;

  // Uygulama ilk açıldığında DB'den favorileri okur + FAVLARI DBDEN OKU
  Future<void> loadFavorites() async {
    final list = await RecipeDB.instance.getFavorites();

    // _favoriteIds = rows.map((e) => e["id"] as String).toSet();

    _favorites
      ..clear()
      ..addAll(list.map((e) => FavoriteEntry.fromMap(e)));

    notifyListeners(); 
  }

  // Favori mi?
  bool isFavorite(String id) {
    return _favorites.any((e) => e.id == id);
  }

 
  // ID'ye göre favoriteEntry döndür
  FavoriteEntry? getFavoriteById(String id) {
    try {
      return _favorites.firstWhere((e) => e.id == id);
    } catch (_) {
      return null;
    }
  }

  // Toggle (fav ekle-sil)
  Future<void> toggleFavorite({
    required String id,
    required String name,
    required String thumbnail,
    required String instructions,
    required String category,
    required String area,
    required List<String> ingredients,
  }) async {
    final exists = isFavorite(id);

    if (exists) {

      await RecipeDB.instance.removeFavorite(id);
      _favorites.removeWhere((e) => e.id == id);
    } else {

      await RecipeDB.instance.addFavorite(
        id: id,
        name: name,
        thumbnail: thumbnail,
        instructions: instructions,
        category: category,
        area: area,
        ingredients: ingredients,
      );

      _favorites.add(
        FavoriteEntry(
          id: id,
          name: name,
          thumbnail: thumbnail,
          instructions: instructions,
          category: category,
          area: area,
          ingredients: ingredients,
        ),
      );
    }

    notifyListeners();
  }

  // FAVORİYİ API’DEN GÜNCEL VERİYLE yeniliyorsun
  Future<void> updateEntry(Meal meal) async {
    final exists = isFavorite(meal.id);
    if (!exists) return;

    // DB güncelle/rewrite
    await RecipeDB.instance.addFavorite(
      id: meal.id,
      name: meal.name,
      thumbnail: meal.thumbnail,
      instructions: meal.instructions,
      category: meal.category,
      area: meal.area,
      ingredients: meal.ingredients,
    );

    final index = _favorites.indexWhere((e) => e.id == meal.id);
    if (index != -1) {
      _favorites[index] = FavoriteEntry(
        id: meal.id,
        name: meal.name,
        thumbnail: meal.thumbnail,
        instructions: meal.instructions,
        category: meal.category,
        area: meal.area,
        ingredients: meal.ingredients,
      );
    }

    notifyListeners();
  }
}
