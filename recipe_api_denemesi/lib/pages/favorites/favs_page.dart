import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_api_denemesi/pages/favorites/fav_recipe_detail.dart';
import 'package:recipe_api_denemesi/widgets/circle_icon.dart';

import '../../colors.dart';
import 'favs_recipe_card.dart';
import '../../models/recipe.dart';
import '../../provider/favs_manager.dart';
import '../../widgets/favs_search_modal.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final w = size.width;

    // provider icindeki list'i aldi 
    // watch => iste değişince UI güncelliyor
    final fav = context.watch<FavsManager>();
    final favorites = fav.entries;

    if (favorites.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: AppColors.beige,
          elevation: 0,
          title: Column(
            children: [
              Text(
                "Your Favorite Recipes",
                style: TextStyle(
                  color: AppColors.darkGreen,
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                ),
              ),
              Text(
                "Everything you love is here.",
                style: TextStyle(color: Colors.black54, fontSize: 13),
              ),
            ],
          ),
          actions: [
            circleIcon(
              Icons.search,
              w,
              onTap: () {
                showModalBottomSheet(
                  // flutter ın kendisinden
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (_) => const FavoritesSearchModal(),
                );
              },
            ),
            SizedBox(width: w * 0.05),
          ],
        ),
        body: Center(child: Text("You don't have any favorites yet")),
      );
    }

    return Scaffold(
      //appBar: AppBar(title: const Text("Favoriler")),
      // appBar: AppBar(
      //   backgroundColor: AppColors.beige,
      //   surfaceTintColor: Colors.white,
      //   titleSpacing: w * 0.05,
      //   centerTitle: true,
      //   leading: Icon(Icons.circle_outlined, color: AppColors.darkGreen,) ,
      //   title: Text(
      //     "Favori Tariflerin",
      //     style: TextStyle(
      //       fontSize: w * 0.055,
      //       fontWeight: FontWeight.w600,
      //       color: AppColors.darkGreen,
      //     ),
      //   ),
      // ),
      appBar: AppBar(
        // automaticallyImplyLeading: false,   // <-- back button yok
        centerTitle: true,
        backgroundColor: AppColors.beige,
        elevation: 0,
        title: Column(
          children: [
            Text(
              "Your Favorite Recipes",
              style: TextStyle(
                color: AppColors.darkGreen,
                fontWeight: FontWeight.w600,
                fontSize: 20,
              ),
            ),
            Text(
              "Everything you love is here.",
              style: TextStyle(color: Colors.black54, fontSize: 13),
            ),
          ],
        ),
        actions: [
          circleIcon(
            Icons.search,
            w,
            onTap: () {
              showModalBottomSheet(
                // flutter ın kendısinden
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (_) => const FavoritesSearchModal(),
              );
            },
          ),
          SizedBox(width: w * 0.05),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),

        child: LayoutBuilder(
          builder: (_, constraints) {
            final itemWidth = constraints.maxWidth / 2; // responsive
            final itemHeight = itemWidth * 1.35; // sabit oran
            return GridView.builder(
              itemCount: favorites.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: itemWidth / itemHeight, // overflow yok
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemBuilder: (_, index) {
                final item = favorites[index];

                return RecipeFavoriteCard(
                  image: item.thumbnail,
                  title: item.name,
                  instructions: item.instructions,
                  onTap: () {
                    // UI Meal bekliyor o yüzden çeviriyoruz
                    final meal = Meal.fromFavorite(item);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => FavoriteRecipeDetailPage(
                          meal: meal,
                        ), // SADECE DBDEN
                      ),
                    );
                  },
                  onFavTap: () {
                    context.read<FavsManager>().toggleFavorite(
                      id: item.id,
                      name: item.name,
                      thumbnail: item.thumbnail,
                      instructions: item.instructions,
                      category: item.category,
                      area: item.area,
                      ingredients: item.ingredients,
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
