import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../colors.dart';
import '../../../database/recipe_db.dart';
import '../../../models/user_recipe.dart';
import '../../provider/favs_manager.dart';

class UserRecipeDetailPage extends StatefulWidget {
  final String recipeId;

  const UserRecipeDetailPage({super.key, required this.recipeId});

  @override
  State<UserRecipeDetailPage> createState() => _UserRecipeDetailPageState();
}

class _UserRecipeDetailPageState extends State<UserRecipeDetailPage> {
  UserRecipe? recipe;

  @override
  void initState() {
    super.initState();
    loadRecipe();
  }

  /// DB’den recipeId ile tarif çekiyoruz
  Future<void> loadRecipe() async {
    final map = await RecipeDB.instance.getUserRecipeById(widget.recipeId);
    if (map != null) {
      setState(() => recipe = UserRecipe.fromMap(map));
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final w = size.width;
    final h = size.height;

    // Veri henüz gelmemişse loading göster
    if (recipe == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final r = recipe!;

    final favs = context.watch<FavsManager>();
    final isFav = favs.isFavorite(r.id);

    return Scaffold(
      backgroundColor: AppColors.beige,
      appBar: AppBar(
        backgroundColor: AppColors.beige,
        elevation: 2,
        centerTitle: true,
        title: Text(
          r.name,
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
              favs.toggleFavorite(
                id: r.id,
                name: r.name,
                thumbnail: r.thumbnail,
                instructions: r.instructions,
                category: r.category,
                area: r.area,
                ingredients: r.ingredients,
              );
            },
          ),

          SizedBox(width: w * 0.04),
        ],

        // EDIT—İLERDE olabilirrr
        // actions: [
        //   IconButton(
        //     icon: const Icon(Icons.edit),
        //     onPressed: () async {
        //       await Navigator.push(
        //         context,
        //         MaterialPageRoute(builder: (_) => EditRecipePage(recipe: r)),
        //       );
        //       loadRecipe();  // edit sonrası yenile
        //     },
        //   ),
        // ],
      ),

      body: ListView(
        padding: EdgeInsets.zero,
        children: [
         
          ClipRRect(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(w * 0.05),
            ),
            child: r.thumbnail.isNotEmpty
                ? Image.file(
                    File(r.thumbnail),
                    height: h * 0.30,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  )
                : Container(
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

          SizedBox(height: h * 0.02),

          //CATEGORY – AREA CHIPS
          Padding(
            padding: EdgeInsets.symmetric(horizontal: w * 0.05),
            child: Wrap(
              spacing: w * 0.025,
              children: [
                if (r.category.isNotEmpty) _chip(r.category, w),
                if (r.area.isNotEmpty) _chip(r.area, w),
              ],
            ),
          ),

          SizedBox(height: h * 0.02),

          //INSTRUCTIONS
          _sectionTitle("Instructions", w),
          SizedBox(height: h * 0.01),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: w * 0.05),
            child: _instructionsText(r.instructions, w),
          ),

          SizedBox(height: h * 0.01),

          // INGREDIENTS
          _sectionTitle("Ingredients", w),
          SizedBox(height: h * 0.01),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: w * 0.05),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: r.ingredients
                  .map(
                    (e) => Padding(
                      padding: EdgeInsets.symmetric(vertical: h * 0.005),
                      child: Text(
                        "• $e",
                        style: TextStyle(
                          fontSize: w * 0.040,
                          height: 1.35,
                          // color: Colors.black87,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),

          SizedBox(height: h * 0.05),
        ],
      ),
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

  // PARAGRAPH INSTRUCTIONS
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
