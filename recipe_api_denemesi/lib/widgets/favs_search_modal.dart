import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../pages/favorites/fav_recipe_detail.dart';
import '../models/recipe.dart';
import '../provider/favs_manager.dart';

import '../colors.dart';
import 'search_card.dart';

class FavoritesSearchModal extends StatefulWidget {
  const FavoritesSearchModal({super.key});

  @override
  State<FavoritesSearchModal> createState() => _FavoritesSearchModalState();
}

class _FavoritesSearchModalState extends State<FavoritesSearchModal> {
  final TextEditingController _controller = TextEditingController();
  Timer? _debounce;

  List<Meal> _results = [];

  void _onChanged(String text) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 200), () {
      _search(text);
    });
  }

  void _search(String q) {
    final fav = context.read<FavsManager>();
    final all = fav.entries; // FavoriteEntry list

    if (q.isEmpty) {
      setState(() => _results = []);
      return;
    }

    final filtered = all.where((f) {
      return f.name.toLowerCase().contains(q.toLowerCase());
    }).toList();

    // FavoriteEntry → Meal
    final meals = filtered.map((e) => Meal.fromFavorite(e)).toList();

    setState(() => _results = meals);
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
              hintText: "Search favorites…",
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

          // Search results 
          Expanded(
            child: _results.isEmpty
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
                              builder: (_) =>
                                  FavoriteRecipeDetailPage(meal: meal),
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

  // Widget _image(Meal m) {
  // if (m.localImagePath != null) {
  //   return ClipRRect(
  //     borderRadius: BorderRadius.circular(12),
  //     child: Image.file(
  //       File(m.localImagePath!),
  //       height: 130,
  //       width: double.infinity,
  //       fit: BoxFit.cover,
  //     ),
  //   );
  // }

  //   return ClipRRect(
  //     borderRadius: BorderRadius.circular(12),
  //     child: Image.network(
  //       m.thumbnail,
  //       height: 130,
  //       width: double.infinity,
  //       fit: BoxFit.cover,
  //     ),
  //   );
  // }
}
