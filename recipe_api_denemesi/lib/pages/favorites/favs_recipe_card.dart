import 'package:flutter/material.dart';
import 'package:recipe_api_denemesi/colors.dart';

class RecipeFavoriteCard extends StatelessWidget {
  final String image;
  final String title;
  final String instructions;
  final VoidCallback onTap;
  final VoidCallback onFavTap;

  const RecipeFavoriteCard({
    super.key,
    required this.image,
    required this.title,
    required this.instructions,
    required this.onTap,
    required this.onFavTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Stack(
          children: [
            // Image
            Positioned.fill(
              child: Image.network(
                image,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                    Container(color: Colors.grey.shade200),
              ),
            ),

            // Gradient
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withOpacity(.05),
                      Colors.black.withOpacity(.62),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),

            // Title & Subtitle
            Positioned(
              left: 10,
              right: 10,
              bottom: 12,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.beige,
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    instructions,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: AppColors.beige.withOpacity(.8),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),

            // Heart
            Positioned(
              top: 10,
              right: 10,
              child: InkWell(
                onTap: onFavTap,
                child: Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: AppColors.ligtGreen.withOpacity(.85),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.favorite_rounded,
                    color: AppColors.darkGreen,
                    size: 20,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
