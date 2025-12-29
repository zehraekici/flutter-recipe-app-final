import 'package:flutter/material.dart';
import 'package:recipe_api_denemesi/colors.dart';

class RecipeCard extends StatelessWidget {
  final String title;
  final String thumbnailUrl;
  final bool isFavorite; // Provider’dan gelen state
  final VoidCallback? onFavoriteTap;
  final VoidCallback? onTap;

  const RecipeCard({
    super.key,
    required this.title,
    required this.thumbnailUrl,
    this.isFavorite = false,
    this.onFavoriteTap,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // Kart tıklanabilir
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
          image: DecorationImage(
            colorFilter: const ColorFilter.mode(
              Color(0x59000000),
              BlendMode.multiply,
            ),
            image: NetworkImage(thumbnailUrl),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            // Favori ikonu – sağ üst köşede
            Positioned(
              top: 10,
              right: 10,
              child: GestureDetector(
                onTap: onFavoriteTap,
                child: Container(
                  padding: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.28),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite
                        ? AppColors.ligtGreen
                        : AppColors.ligtGreen,
                    size: 22,
                  ),
                ),
              ),
            ),

            // Yemek başlığı
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  title,
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
