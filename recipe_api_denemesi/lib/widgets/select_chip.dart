import 'package:flutter/material.dart';
import '../colors.dart';

class SelectChip extends StatelessWidget {
  final String text;
  final bool selected;
  final Function(bool) onSelected;

  const SelectChip({
    super.key,
    required this.text,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    return ChoiceChip(
      avatar: null, // check ikonu gitsin diye
      showCheckmark: false, //CHECKMARK SİL
      label: Text(
        text,
        style: TextStyle(
          color: selected ? AppColors.beige : AppColors.darkGreen,
          fontSize: w * 0.040,
          fontWeight: FontWeight.w500,
        ),
      ),
      selected: selected,
      selectedColor: AppColors.darkGreen,
      backgroundColor: AppColors.ligtGreen.withOpacity(.55),
      side: BorderSide.none,
      onSelected: onSelected,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(w * 0.05),
      ),
      labelPadding: EdgeInsets.symmetric(
        vertical: w * 0.01,
        horizontal: w * 0.02,
      ),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap, 
    );
  }
}
