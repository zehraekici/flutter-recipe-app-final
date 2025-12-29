// Bir "yemek" (Meal) veri modelini temsil eder

import 'favorite_entry.dart';

class Meal {
  final String id;
  final String name;
  final String thumbnail; // Görsel URL
  final String instructions;

  final String category;
  final String area; // yeni ekledin !!!!!!

  // Ingredient + Measure birlesmis liste
  // ["2 Eggs", "1/2 cup Milk", ...]
  final List<String> ingredients;

  Meal({
    required this.id,
    required this.name,
    required this.thumbnail,
    required this.instructions,
    required this.category, //
    required this.area, //
    required this.ingredients,
  });

  // !!! online icin SADECE (OFFLINE DA PATLIYO)
  factory Meal.fromJson(Map<String, dynamic> json) {
    // json dan nesne üretmek için özel constructor

    // Ingredients topla
    final List<String> ingredientsList = [];

    for (int i = 1; i <= 20; i++) {
      final ing = json["strIngredient$i"];
      final measure = json["strMeasure$i"];

      // Null veya boş degilse
      if (ing != null &&
          ing.toString().trim().isNotEmpty &&
          ing.toString().toLowerCase() != "null") {
        String formatted = "";

        // ölcü + malzeme
        if (measure != null && measure.toString().trim().isNotEmpty) {
          formatted = "${measure.toString().trim()} ${ing.toString().trim()}";
        } else {
          formatted = ing.toString().trim();
        }

        ingredientsList.add(formatted);
        // ingredients: ["2 Eggs", "1 cup Milk", "Salt"]
      }
    }

    return Meal(
      id: json["idMeal"] ?? "",
      name: json["strMeal"] ?? "",
      thumbnail: json["strMealThumb"] ?? "",
      instructions: json["strInstructions"] ?? "",
      category: json["strCategory"] ?? "", //
      area: json["strArea"] ?? "", //
      ingredients: ingredientsList, //
    );
  }

  // OFFLINE — DB (FavoriteEntry => Meal)
  factory Meal.fromFavorite(FavoriteEntry f) {
    return Meal(
      id: f.id,
      name: f.name,
      thumbnail: f.thumbnail,
      instructions: f.instructions,
      category: f.category,
      area: f.area,
      ingredients: f.ingredients,
    );
  }
}

/* ASAGIDA API NIN DUZENLI JSON GORUNUMUNE ORNEK VAR
{
  "meals": [
    {
      "idMeal": "53025",
      "strMeal": "Ful Medames",
      "strDrinkAlternate": null,
      "strCategory": "Vegetarian",
      "strArea": "Egyptian",
      "strInstructions": "As the cooking time varies...",
      "strMealThumb": "https://www.themealdb.com/images/media/meals/lvn2d51598732465.jpg",
      "strTags": null,
      "strYoutube": "https://www.youtube.com/watch?v=...",

      // ingredients + measures
      "strIngredient1": "Fava Beans",
      "strMeasure1": "2 cups",

      "strIngredient2": "Olive Oil",
      "strMeasure2": "1/4 cup",

      "strIngredient3": "Onion",
      "strMeasure3": "1",

      ...
      "strIngredient20": "",
      "strMeasure20": "",
    }
  ]
}


*/
