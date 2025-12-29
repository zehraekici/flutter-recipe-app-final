import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../api/recipe_api_service.dart';

import '../models/recipe.dart';
import '../provider/favs_manager.dart';
import '../pages/home/recipe_detail.dart';
import '../colors.dart';
import 'search_card.dart';

class SearchModal extends StatefulWidget {
  const SearchModal({super.key});

  @override
  State<SearchModal> createState() => _SearchModalState();
}

class _SearchModalState extends State<SearchModal> {
  final TextEditingController _controller = TextEditingController();

  // Debounce icin kullanilan Timer / API çağrısını geciktirmek için
  Timer? _debounce;

  List<Meal> _results = [];

  bool _loading = false;
  // int selectedChipIndex = -1;

  // final List<String> recChips = [
  //   "Pizza",
  //   "Soup",
  //   "Cheesecake",
  //   "Pie",
  //   "Fish",
  //   "Vegan",
  // ];


  // Api ye her seferinde istek atmasın diye !!!!!!!!!
  void _onChanged(String text) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      _search(text);
    });
  }

  Future<void> _search(String q) async {
    if (q.isEmpty) {
      setState(() => _results = []);
      return;
    }

    setState(() => _loading = true);

    final data = await MealApiService.searchMeal(q);

    debugPrint("SEARCH RESULT COUNT: ${data.length}");


    setState(() {
      _results = data;
      _loading = false;
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final w = size.width;
    final h = size.height;

    return Container(
      height: h * 0.85,
      padding: EdgeInsets.all(w * 0.05),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(30),
          topLeft: Radius.circular(30),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search Input
          TextField(
            controller: _controller,
            onChanged: _onChanged,
            decoration: InputDecoration(
              hintText: "Search…",
              filled: true,
              fillColor: AppColors.ligtGreen,
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(w * 0.08),
                borderSide: BorderSide.none,
              ),
            ),
          ),

          SizedBox(height: h * 0.02),

          //  Search results !!!!!!!
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _results.isEmpty
                ? const Center(child: Text("No results"))
                : GridView.builder(
                    padding: const EdgeInsets.only(top: 8),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.85,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                        ),
                    itemCount: _results.length,
                    itemBuilder: (_, i) {
                      final fav = context.watch<FavsManager>();

                      final meal = _results[i];

                      final isFav = fav.isFavorite(meal.id);

                      return SearchCard(
                        image: meal.thumbnail,
                        title: meal.name,
                        instructions: meal.instructions,
                        isFavorite: isFav,
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => MealDetailPage(mealId: meal.id),
                            ),
                          );
                        },
                        onFavTap: () {
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
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  // Chip widget ESKI BU TASİNACAK !!!!!!!!!!!!!!!!!
  Widget buildChip({
    required String text,
    required bool selected,
    required double w,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: w * 0.02, horizontal: w * 0.04),
        decoration: BoxDecoration(
          color: selected ? AppColors.darkGreen : AppColors.ligtGreen,
          borderRadius: BorderRadius.circular(w * 0.05),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: selected ? AppColors.beige : AppColors.mediumGreen,
            fontSize: w * 0.040,
          ),
        ),
      ),
    );
  }
}
