import 'dart:io';
import 'package:flutter/material.dart';
import '../../../../colors.dart';
import '../../../../models/user_recipe.dart';

class UserRecipeCard extends StatelessWidget {
  final UserRecipe recipe;
  final VoidCallback? onTap;
  final VoidCallback? onActionTap; // edit/delete veya istediğin buton

  const UserRecipeCard({
    super.key,
    required this.recipe,
    this.onTap,
    this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
        width: double.infinity,
        height: 180,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(15),
          boxShadow: const [
            BoxShadow(
              color: Color(0x99000000),
              offset: Offset(0, 10),
              blurRadius: 10,
              spreadRadius: -6,
            ),
          ],
          image: recipe.thumbnail.isNotEmpty
              ? DecorationImage(
                  image: FileImage(File(recipe.thumbnail)),
                  fit: BoxFit.cover,
                  colorFilter: const ColorFilter.mode(
                    Color(0x59000000),
                    BlendMode.multiply,
                  ),
                )
              : const DecorationImage(
                  image: AssetImage("assets/placeholder.png"),
                  fit: BoxFit.cover,
                ),
        ),
        child: Stack(
          children: [
            // Action icon (edit/delete)
            Positioned(
              top: 10,
              right: 10,
              child: GestureDetector(
                onTap: onActionTap,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.28),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: const Icon(
                    Icons.more_vert, // edit/delete koyarız
                    color: AppColors.ligtGreen,
                    size: 22,
                  ),
                ),
              ),
            ),

            // Title
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  recipe.name,
                  style: const TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
