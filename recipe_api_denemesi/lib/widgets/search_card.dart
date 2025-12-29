import 'package:flutter/material.dart';
import '../colors.dart';

class SearchCard extends StatelessWidget {
  final String image;
  final String title;
  final String instructions;
  // fav da mı diye yoksa problem çıktı
  final bool isFavorite;
  final VoidCallback onTap;
  final VoidCallback onFavTap;

  const SearchCard({
    super.key,
    required this.image,
    required this.title,
    required this.instructions,
    required this.isFavorite,
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
            //IMAGE 
            Positioned.fill(
              child: Image.network(
                image,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                    Container(color: Colors.grey.shade200),
              ),
            ),

            // GRADIENT OVERLAY 
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withOpacity(.05),
                      Colors.black.withOpacity(.55),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),

            // text
            Positioned(
              left: 10,
              right: 10,
              bottom: 12,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // TITLE
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.beige,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  // SUBTITLE
                  Text(
                    instructions,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: AppColors.beige.withOpacity(0.85),
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),

            // kalp
            Positioned(
              top: 10,
              right: 10,
              child: InkWell(
                onTap: onFavTap,
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppColors.ligtGreen.withOpacity(.85),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite
                        ? AppColors.darkGreen
                        : AppColors.darkGreen,
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
