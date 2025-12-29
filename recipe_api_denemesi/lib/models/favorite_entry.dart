import 'dart:convert';

class FavoriteEntry {
  final String id;
  final String name;
  final String thumbnail;
  final String instructions;
  final String category;
  final String area;
  final List<String> ingredients;

  FavoriteEntry({
    required this.id,
    required this.name,
    required this.thumbnail,
    required this.instructions,
    required this.category,
    required this.area,
    required this.ingredients,
  });

  //SQL sadece
  // Tek bir yerde (değiştirmeyi unutma !! burad instructions yok)
  factory FavoriteEntry.fromMap(Map<String, dynamic> map) {
    return FavoriteEntry(
      id: map["id"],
      name: map["name"],
      thumbnail: map["thumbnail"] ?? "",
      instructions: map["instructions"] ?? "",
      category: map["category"] ?? "",
      area: map["area"] ?? "",
      ingredients: (map["ingredients"] != null)
          ? List<String>.from(jsonDecode(map["ingredients"]))
          : [],
    );
  }
}
