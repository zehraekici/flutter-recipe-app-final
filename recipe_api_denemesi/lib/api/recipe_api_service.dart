import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/recipe.dart';

import 'package:flutter/foundation.dart';

import 'api_config.dart';



class MealApiService {

  //eski
  //static const String baseUrl = "https://www.themealdb.com/api/json/v1/1";

  // static const String baseUrl =
  //   "http://10.0.2.2:5050/api/meals";

  static String get baseUrl =>
    "${ApiConfig.baseUrl}/api/meals";


  //  RANDOM YEMEK GETİR

  // static cunku new kullanmadan cagır + sınıfa ait
  // ya meal obj donecek ya da null
  static Future<Meal?> getRandomMeal() async {
    try {
      // final url = Uri.parse(
      //   "$baseUrl/random.php",
      // ); //random.php her zaman tek yemek donuyor

      final url = Uri.parse("$baseUrl/random");


      final res = await http
          .get(url)
          .timeout(
            const Duration(seconds: 15),
          ); // GET isteği at + 20 sn bekle olmuyorsa hata at

      // HTTP 200 => başarılı (400 error vb)
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body); // JSON yap

        // print(data.runtimeType);          // Map
        // print(data["meals"].runtimeType); // List

        final meals = data["meals"];
        if (meals == null) {
          return null;
        }

        // JSON => Meal modeline çevir
        return Meal.fromJson(meals[0]);
      }
    } catch (e) {

      return null;
    }

    return null;
  }


  // ID'ye göre yemek detayı getir
  static Future<Meal?> getMealById(String mealId) async {
    try {
      // lookup endpoint => id ile arama
      //final url = Uri.parse("$baseUrl/lookup.php?i=$mealId");

      final url = Uri.parse("$baseUrl/$mealId");


      final res = await http.get(url);

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);

        final meals = data["meals"];
        if (meals == null) return null;

        return Meal.fromJson(meals[0]);
      }
      return null;
    } catch (e) {
      print("getMealById network fail → $e");
      return null; // Offline / hata durumunda null döner
    }
  }


  // YEMEK ARA (Arama barından)
  static Future<List<Meal>> searchMeal(String query) async {
    // Arama endpoint => query ile arama
    //final url = Uri.parse("$baseUrl/search.php?s=$query");

    final url = Uri.parse("$baseUrl/search?q=$query");


    final res = await http.get(url);

    //print("STATUS: ${res.statusCode}");

    debugPrint("STATUS: ${res.statusCode}");
    debugPrint("RAW BODY: ${res.body}");



    if (res.statusCode == 200) {
      final data = jsonDecode(
        res.body,
      ); // str'yi Map<String, dynamic>'e cevirdik / Dartta JSON verisin karşılığı

      final meals = data["meals"];

      if (meals == null) return []; // sonuç yok => boş liste

      // JSON list => Meal list
      return meals.map<Meal>((m) => Meal.fromJson(m)).toList();
    }

    return [];
  }
}
