// import 'dart:convert';

// class UserRecipe {
//   final String id;
//   final String name;
//   final String instructions;
//   final String category;
//   final String area;
//   final String thumbnail;
//   final List<String> ingredients;
//   final int createdAt;
//   final int updatedAt;

//   UserRecipe({
//     required this.id,
//     required this.name,
//     required this.instructions,
//     required this.category,
//     required this.area,
//     required this.thumbnail,
//     required this.ingredients,
//     required this.createdAt,
//     required this.updatedAt,
//   });

//   factory UserRecipe.fromMap(Map<String, dynamic> map) {
//     return UserRecipe(
//       id: map["id"],
//       name: map["name"],
//       thumbnail: map["thumbnail"] ?? "",
//       instructions: map["instructions"] ?? "",
//       category: map["category"] ?? "",
//       area: map["area"] ?? "",
//       ingredients: (map["ingredients"] != null)
//           ? List<String>.from(jsonDecode(map["ingredients"]))
//           : [],
//       createdAt: map["createdAt"] ?? 0,
//       updatedAt: map["updatedAt"] ?? 0,
//     );
//   }

//   Map<String, dynamic> toMap() {
//     return {
//       "id": id,
//       "name": name,
//       "thumbnail": thumbnail,
//       "instructions": instructions,
//       "category": category,
//       "area": area,
//       "ingredients": jsonEncode(ingredients),
//       "createdAt": createdAt,
//       "updatedAt": updatedAt,
//     };
//   }
// }

import 'dart:convert';

class UserRecipe {
  final String id;
  final String name;
  final String instructions;
  final String category;
  final String area;
  final String thumbnail;
  final List<String> ingredients;
  final int createdAt;
  final int updatedAt;

  UserRecipe({
    required this.id,
    required this.name,
    required this.instructions,
    required this.category,
    required this.area,
    required this.thumbnail,
    required this.ingredients,
    required this.createdAt,
    required this.updatedAt,
  });


  // FROM API (Flask)
  
  factory UserRecipe.fromApi(Map<String, dynamic> json) {
    return UserRecipe(
      id: json["id"],
      name: json["name"],
      thumbnail: json["thumbnail"] ?? "",
      instructions: json["instructions"] ?? "",
      category: json["category"] ?? "",
      area: json["area"] ?? "",
      ingredients: List<String>.from(json["ingredients"] ?? []),
      createdAt: json["createdAt"],
      updatedAt: json["updatedAt"],
    );
  }


  // FROM LOCAL DB (SQLite)
  factory UserRecipe.fromMap(Map<String, dynamic> map) {
    return UserRecipe(
      id: map["id"],
      name: map["name"],
      thumbnail: map["thumbnail"] ?? "",
      instructions: map["instructions"] ?? "",
      category: map["category"] ?? "",
      area: map["area"] ?? "",
      ingredients: (map["ingredients"] != null)
          ? List<String>.from(jsonDecode(map["ingredients"]))
          : [],
      createdAt: map["createdAt"] ?? 0,
      updatedAt: map["updatedAt"] ?? 0,
    );
  }


  // OFFLINE FALLBACK
  factory UserRecipe.localFallback({
    required String name,
    required List<String> ingredients,
    required int createdAt,
    String instructions = "",
    String category = "",
    String area = "",
    String thumbnail = "",
  }) {
    return UserRecipe(
      id: "local-$createdAt",
      name: name,
      instructions: instructions,
      category: category,
      area: area,
      thumbnail: thumbnail,
      ingredients: ingredients,
      createdAt: createdAt,
      updatedAt: createdAt,
    );
  }


  // TO LOCAL DB
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "thumbnail": thumbnail,
      "instructions": instructions,
      "category": category,
      "area": area,
      "ingredients": jsonEncode(ingredients),
      "createdAt": createdAt,
      "updatedAt": updatedAt,
    };
  }
}

