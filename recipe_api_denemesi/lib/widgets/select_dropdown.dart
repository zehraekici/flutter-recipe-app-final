import 'package:flutter/material.dart';
import '../colors.dart';

class SelectDropdown extends StatelessWidget {
  final String label;
  final List<String> items;
  final String? value;
  final double width;
  final ValueChanged<String?> onChanged;

  const SelectDropdown({
    super.key,
    required this.label,
    required this.items,
    required this.value,
    required this.onChanged,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    final w = width;

    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: w * 0.04,
            vertical: w * 0.01,
          ),
          decoration: BoxDecoration(
            color: AppColors.ligtGreen,
            borderRadius: BorderRadius.circular(w * 0.07),
          ),
          child: DropdownButton<String>(
            value: value,
            isExpanded: true,
            underline: const SizedBox(),

            // arrow
            icon: Icon(
              Icons.keyboard_arrow_down_rounded,
              color: AppColors.darkGreen,
              size: w * 0.075,
            ),

            // items
            items: items.map((area) {
              //FLUTTER DIREKT ÖZELLEŞTİRMEYİ DESTEKLEMİYOR BUNDA O YÜZDEN ÇİRKİN
              return DropdownMenuItem(
                value: area,

                child: Text(
                  area,
                  style: TextStyle(
                    fontSize: w * 0.045,
                    color: AppColors.darkGreen,
                  ),
                ),
              );
            }).toList(),

            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}
