
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../provider/favs_manager.dart';
import '../../../colors.dart';

import '../../api/recipe_api_service.dart';
import '../../models/recipe.dart';

class MealDetailPage extends StatelessWidget {
  final String? mealId; // API ICIN

  const MealDetailPage({super.key, required this.mealId});

  @override
  Widget build(BuildContext context) {
    // Ekran bilgileri
    final size = MediaQuery.of(context).size;
    final w = size.width;
    final h = size.height;

    return FutureBuilder(
      future: MealApiService.getMealById(mealId!),
      builder: (_, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final meal = snapshot.data as Meal;
        final fav = context.watch<FavsManager>();
        final isFav = fav.isFavorite(meal.id);

        return Scaffold(
          backgroundColor: AppColors.beige,

          appBar: AppBar(
            backgroundColor: AppColors.beige,
            elevation: 2,
            centerTitle: true,
            title: Text(
              meal.name,
              style: TextStyle(
                fontSize: w * 0.052,
                fontWeight: FontWeight.w600,
                color: AppColors.darkGreen,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(
                Icons.arrow_back,
                color: AppColors.darkGreen,
                size: w * 0.065,
              ),
            ),
            actions: [
              _circleIcon(
                isFav ? Icons.favorite : Icons.favorite_border,
                w,
                onTap: () {
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
              ),

              SizedBox(width: w * 0.04),
            ],
          ),

          body: ListView(
            padding: EdgeInsets.zero,
            children: [

              ClipRRect(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(w * 0.05),
                ),
                child: Image.network(
                  meal.thumbnail,
                  height: h * 0.30,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    height: h * 0.30,
                    width: double.infinity,
                    color: Colors.grey.shade200,
                    child: Icon(
                      Icons.hide_image_rounded,
                      color: Colors.grey,
                      size: w * 0.25,
                    ),
                  ),
                ),
              ),

              SizedBox(height: h * 0.02),

              //  CATEGORY ⎯ AREA CHIPS
              Padding(
                padding: EdgeInsets.symmetric(horizontal: w * 0.05),
                child: Wrap(
                  spacing: w * 0.025,
                  children: [
                    if (meal.category.isNotEmpty) _chip(meal.category, w),
                    if (meal.area.isNotEmpty) _chip(meal.area, w),
                  ],
                ),
              ),

              SizedBox(height: h * 0.02),

              _sectionTitle("Instructions", w),

              SizedBox(height: h * 0.01),

              // Instructions Text (Paragraphs + indent)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: w * 0.05),
                child: _instructionsText(meal.instructions, w),
              ),

              SizedBox(height: h * 0.01),

              // Ingredients
              _sectionTitle("Ingredients", w),

              SizedBox(height: h * 0.01),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: w * 0.05),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: meal.ingredients
                      .map(
                        (e) => Padding(
                          padding: EdgeInsets.symmetric(vertical: h * 0.005),
                          child: Text(
                            "• $e",
                            style: TextStyle(fontSize: w * 0.040, height: 1.35),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),

              SizedBox(height: h * 0.05),
            ],
          ),

          // BURASI KALDI FAB' A BAK
          // floatingActionButton: FloatingActionButton(
          //   onPressed: (){

          //   },
          //   child: const Icon(Icons.arrow_upward_outlined),
          // ),
        );
      },
    );
  }

  // Ortak yuvarlak ikon
  Widget _circleIcon(IconData icon, double w, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: w * 0.1,
        height: w * 0.09,
        decoration: BoxDecoration(
          color: AppColors.ligtGreen,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: w * 0.055, color: AppColors.darkGreen),
      ),
    );
  }


  Widget _chip(String text, double w) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: w * 0.03, vertical: w * 0.015),
      decoration: BoxDecoration(
        color: AppColors.ligtGreen,
        borderRadius: BorderRadius.circular(w * 0.04),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: w * 0.040,
          color: AppColors.darkGreen,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }


  Widget _sectionTitle(String s, double w) => Padding(
    padding: EdgeInsets.symmetric(horizontal: w * 0.05),
    child: Text(
      s,
      style: TextStyle(
        fontSize: w * 0.050,
        fontWeight: FontWeight.w700,
        color: AppColors.darkGreen,
      ),
    ),
  );


  Widget _instructionsText(String text, double w) {
    final parts = text.split("\n").where((e) => e.trim().isNotEmpty).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(parts.length, (i) {
        return Padding(
          padding: EdgeInsets.only(bottom: w * 0.03),
          child: Text(
            parts[i],
            style: TextStyle(fontSize: w * 0.040, height: 1.40),
          ),
        );
      }),
    );
  }
}
