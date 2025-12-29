import 'package:flutter/material.dart';
import '../colors.dart';

Widget circleIcon(IconData icon, double w, {VoidCallback? onTap}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      width: w * 0.10,
      height: w * 0.10,
      decoration: BoxDecoration(
        color: AppColors.ligtGreen,
        shape: BoxShape.circle,
      ),
      child: Icon(icon, size: w * 0.055, color: const Color(0xFF7AA46A)),
    ),
  );
}
