import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_api_denemesi/colors.dart';

import 'package:recipe_api_denemesi/provider/user_recipes_manager.dart';
import 'package:recipe_api_denemesi/pages/user_recipes/user_recipe_card.dart';

import '../../../models/user_recipe.dart';
import 'user_recipe_detail_page.dart';
import '../../widgets/circle_icon.dart';

class UserRecipePage extends StatelessWidget {
  const UserRecipePage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final w = size.width;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColors.beige,
        elevation: 0,
        title: Column(
          children: [
            Text(
              "Your Homemade Recipes",
              style: TextStyle(
                color: AppColors.darkGreen,
                fontWeight: FontWeight.w600,
                fontSize: 20,
              ),
            ),
            Text(
              "A collection built by you",
              style: TextStyle(color: Colors.black54, fontSize: 13),
            ),
          ],
        ),
        actions: [
          //eskiden search vardı sildin !!!
          circleIcon(
            Icons.handshake_outlined,
            w,
            onTap: () {
              //       showModalBottomSheet(
              // context: context,
              // isScrollControlled: true,
              // backgroundColor: Colors.transparent,
              // builder: (_) => const UserRecipeSearchModal(),
              // );
            },
          ),
          SizedBox(width: w * 0.05),
        ],
      ),

      body: Consumer<UserRecipesManager>(
        builder: (context, mgr, child) {
          final items = mgr.items;

          if (items.isEmpty) {
            return const Center(child: Text("No recipes added yet"));
          }

          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (_, i) {
              final UserRecipe r = items[i];

              return Dismissible(
                key: ValueKey(r.id),
                direction: DismissDirection.endToStart,
                background: Container(
                  alignment: Alignment.centerRight,
                  color: Colors.red,
                  padding: const EdgeInsets.only(right: 20),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                onDismissed: (_) {
                  context.read<UserRecipesManager>().removeUserRecipe(r.id);
                },

                child: UserRecipeCard(
                  recipe: r,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => UserRecipeDetailPage(recipeId: r.id),
                      ),
                    );
                  },
                  onActionTap: () {
                    _openRecipeMenu(context, r);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  //  DELETE 
  void _openRecipeMenu(BuildContext context, UserRecipe recipe) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              //EDIT KISMI YOK SIMDILIK ????
              //               ListTile(
              //                 leading: const Icon(Icons.edit),
              //                 title: const Text("Edit Recipe"),
              //                 onTap: () {
              //   // Navigator.pop(context);
              //   // Navigator.push(
              //   //   context,
              //   //   MaterialPageRoute(
              //   //     builder: (_) => EditUserRecipePage(recipe: recipe),
              //   //   ),
              //   // );
              // },

              // ),
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text("Delete"),
                onTap: () {
                  Navigator.pop(context);
                  context.read<UserRecipesManager>().removeUserRecipe(
                    recipe.id,
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
