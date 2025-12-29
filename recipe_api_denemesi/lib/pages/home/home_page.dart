import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_api_denemesi/colors.dart';

import '../user_recipes/add_recipe_page.dart';
import '../../provider/favs_manager.dart';
import 'recipe_card.dart';

import '../../api/recipe_api_service.dart';
import '../../models/recipe.dart';
import 'recipe_detail.dart';
import '../../widgets/favs_search_modal.dart';
import 'home_appbar.dart';
import '../../widgets/search_modal.dart';
import '../../main_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Meal> _meals = []; // api den
  bool _loading = false; // yükleniyor göstergesi

  @override
  void initState() {
    super.initState();
    fetchMeals(); // Sayfa açılınca 5 meal getir
  }

  // Veri çekme fonksiyonu
  Future<void> fetchMeals() async {
    setState(() {
      _loading = true;
    });

    List<Meal> temp = [];

    // 5 defa çalış → 5 farklı meal getir
    for (int i = 0; i < 5; i++) {
      final meal = await MealApiService.getRandomMeal(); //API cagrisi
      if (meal != null) {
        temp.add(meal);
      }
    }

    setState(() {
      _meals = temp;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {

    // kalp ikonuna basıldığında güncelleme icin
    final fav = context.watch<FavsManager>();

    // Loading
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // Eğer API başarısız => liste boş yani offline
    if (_meals.isEmpty) {
      return Scaffold(
        backgroundColor: AppColors.beige,
        //appBar: AppBar(title: const Text("Tarifler")),
        appBar: HomeAppBar(

          onSearch: () {
            // int yokken dbden
            showModalBottomSheet(
              // flutter ın kendısinden
              // Bu bottom sheet i bu widget’ın bulunduğu konuma göre aç
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (_) => const FavoritesSearchModal(),
            );
          },
          onAdd: fetchMeals,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "No Internet Connection",
                style: TextStyle(fontSize: 18, color: AppColors.brown),
              ),
              const SizedBox(height: 8),
              const Text(
                "You can still view your favorite recipes offline.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15, color: Colors.black54),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // MainScreen'in State'ine eriş (parent widget'ta duruyor)
                  // navbar icin 
                  final mainState = context
                      .findAncestorStateOfType<MainScreenState>();
                  mainState?.setIndex(1);
                },
                child: const Text(
                  "View Favorites",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.ligtGreen,
                  foregroundColor: AppColors.darkGreen,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 28,
                    vertical: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: fetchMeals,
          backgroundColor: AppColors.ligtGreen,
          foregroundColor: AppColors.darkGreen,
          child: const Icon(Icons.refresh),
        ),
      );
    }

    // NORMAL EKRAN
    return Scaffold(
      backgroundColor: AppColors.beige,

      appBar: HomeAppBar(
        onSearch: _openSearchDialog,
        onAdd: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddRecipePage()),
          );
        },
      ),

      body: ListView.builder(
        itemCount: _meals.length,
        itemBuilder: (context, index) { // her meal icin bir widget doner
          final meal = _meals[index];
          return RecipeCard(
            title: meal.name,
            thumbnailUrl: meal.thumbnail,
            isFavorite: fav.isFavorite(meal.id), // DOLU GELME (sonra bak)
            onFavoriteTap: () {
              // Meal bilgisi DB’ye FavoriteEntry olarak kaydediliyor
              fav.toggleFavorite(
                id: meal.id,
                name: meal.name,
                thumbnail: meal.thumbnail,
                instructions: meal.instructions,
                category: meal.category,
                area: meal.area,
                ingredients: meal.ingredients,
              );
            },
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => MealDetailPage(mealId: meal.id),
                ),
              );
            },
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: fetchMeals,
        backgroundColor: AppColors.ligtGreen,
        foregroundColor: AppColors.darkGreen,
        child: const Icon(Icons.refresh),
      ),
    );
  }

  // SEARCH CAGIR
  void _openSearchDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const SearchModal(),
    );
  }
}
