import 'package:flutter/foundation.dart';
import '../api/user_recipe_api_service.dart';
import '../database/recipe_db.dart';
import '../models/user_recipe.dart';

import 'package:uuid/uuid.dart';

// // ID BURADA URETİIYO ARTIK
// // ID + createdAt + updatedAt => otomatik
// // gerisi (title ingredient vb UIden)

// class UserRecipesManager extends ChangeNotifier {
//   List<UserRecipe> _items = [];

//   List<UserRecipe> get items => _items;

//   final _uuid = const Uuid();

//   Future<void> loadUserRecipes() async {
//     final rows = await RecipeDB.instance.getUserRecipes();

//     _items
//       ..clear()
//       ..addAll(rows.map((e) => UserRecipe.fromMap(e)));

//     notifyListeners();
//   }

//   Future<void> addUserRecipe({
//     required String name,
//     required List<String> ingredients,
//     String instructions = "",
//     String category = "",
//     String area = "",
//     String thumbnail = "",
//   }) async {
//     final now = DateTime.now().millisecondsSinceEpoch;

//     final newRecipe = UserRecipe(
//       id: _uuid.v4(),
//       name: name,
//       ingredients: ingredients,
//       instructions: instructions,
//       category: category,
//       area: area,
//       thumbnail: thumbnail,
//       createdAt: now,
//       updatedAt: now,
//     );

//     await RecipeDB.instance.insertUserRecipe(newRecipe);
//     _items.add(newRecipe);
//     notifyListeners();
//   }

//   Future<void> removeUserRecipe(String id) async {
//     await RecipeDB.instance.deleteUserRecipe(id);
//     _items.removeWhere((e) => e.id == id);
//     notifyListeners();
//   }

//   //YENI
//   Future<void> updateUserRecipe(UserRecipe updated) async {
//     await RecipeDB.instance.updateUserRecipe(updated);

//     final index = _items.indexWhere((e) => e.id == updated.id);
//     if (index != -1) {
//       _items[index] = updated;
//       notifyListeners();
//     }
//   }

//   UserRecipe? getById(String id) {
//     try {
//       return _items.firstWhere((e) => e.id == id);
//     } catch (_) {
//       return null;
//     }
//   }
// }



class UserRecipesManager extends ChangeNotifier {
  final List<UserRecipe> _items = [];
  List<UserRecipe> get items => List.unmodifiable(_items);

  // local ilk
  
  Future<void> loadUserRecipes() async {
  
    final rows = await RecipeDB.instance.getUserRecipes();
    _items
      ..clear()
      ..addAll(rows.map(UserRecipe.fromMap));
    notifyListeners();

    // 2) REMOTE REFRESH (BEST EFFORT)
    try {
      final remote = await UserRecipeApiService.fetchAll();

      _items
        ..clear()
        ..addAll(remote);

      // local cache overwrite
      for (final r in remote) {
        await RecipeDB.instance.insertUserRecipe(r);
      }

      notifyListeners();
    } catch (_) {
      // offline → local yeterli
    }
  }

 
  Future<void> addUserRecipe({
    required String name,
    required List<String> ingredients,
    String instructions = "",
    String category = "",
    String area = "",
    String thumbnail = "",
  }) async {
    try {
      // online
      final created = await UserRecipeApiService.create(
        name: name,
        ingredients: ingredients,
        instructions: instructions,
        category: category,
        area: area,
        thumbnail: thumbnail,
      );

      await RecipeDB.instance.insertUserRecipe(created);
      _items.insert(0, created);
    } catch (_) {
      // offline
      final now = DateTime.now().millisecondsSinceEpoch;
      final local = UserRecipe.localFallback(
        name: name,
        ingredients: ingredients,
        instructions: instructions,
        category: category,
        area: area,
        thumbnail: thumbnail,
        createdAt: now,
      );

      await RecipeDB.instance.insertUserRecipe(local);
      _items.insert(0, local);
    }

    notifyListeners();
  }

 
  Future<void> removeUserRecipe(String id) async {
    //  UI
    _items.removeWhere((e) => e.id == id);
    notifyListeners();

    // local DB !!!
    await RecipeDB.instance.deleteUserRecipe(id);

    // gereksiz api çağrısı olmasın
    if (!id.startsWith("local-")) {
      try {
        await UserRecipeApiService.delete(id);
      } catch (_) {
        // offline 
      }
    }
  }
}

