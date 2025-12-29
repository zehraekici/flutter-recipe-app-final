import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'main_screen.dart';
import 'provider/favs_manager.dart';

import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'dart:io';

import 'provider/user_recipes_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); //async oldugu icin 

  // Platform desktop ise sqflite_ffi kullan + sqflite mobilde iyi 
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi; 
  }

  final favsManager = FavsManager(); 
  final userRecipeManager = UserRecipesManager(); 

  await favsManager.loadFavorites(); // DB’den oku
  await userRecipeManager.loadUserRecipes();

  // runApp(
  //   ChangeNotifierProvider<FavsManager>.value(
  //     value: favsManager, // eldeki instance'ı doğrudan veriyoruz
  //     child: const MyApp(),
  //   ),
  // );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<FavsManager>.value(value: favsManager),
        ChangeNotifierProvider<UserRecipesManager>.value(
          value: userRecipeManager,
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      //ESKI PATLADI
      // initialRoute: "/home",

      // routes: {
      //   "/home": (context) => const MealExamplePage(),
      //   "/favorites": (context) => const FavoritesPage(),
      // },
      home: const MainScreen(),
    );
  }
}
