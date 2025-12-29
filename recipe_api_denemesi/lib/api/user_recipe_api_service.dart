import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_recipe.dart';

import 'api_config.dart';

class UserRecipeApiService {
  // static const _base = "http://10.0.2.2:5050/api/user-recipes";

  static String get _base =>
      "${ApiConfig.baseUrl}/api/user-recipes";

  static Future<UserRecipe> create({
    required String name,
    required List<String> ingredients,
    String instructions = "",
    String category = "",
    String area = "",
    String thumbnail = "",
  }) async {
    final res = await http.post(
      Uri.parse(_base),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "name": name,
        "thumbnail": thumbnail,
        "instructions": instructions,
        "category": category,
        "area": area,
        "ingredients": ingredients,
      }),
    );

    if (res.statusCode != 201) {
      throw Exception("POST /user-recipes failed");
    }

    return UserRecipe.fromApi(jsonDecode(res.body));
  }

  static Future<List<UserRecipe>> fetchAll() async {
    final res = await http.get(Uri.parse(_base));
    if (res.statusCode != 200) {
      throw Exception("GET /user-recipes failed");
    }

    final list = jsonDecode(res.body) as List;
    return list.map((e) => UserRecipe.fromApi(e)).toList();
  }

  static Future<void> delete(String id) async {
    final res = await http.delete(
      Uri.parse("$_base/$id"),
    );

    if (res.statusCode != 204) {
      throw Exception("DELETE /user-recipes failed");
    }
  }
}
