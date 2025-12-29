// BU add_recipe_page.dart'taki ingredients ekleme çıkarma kısmı

import 'package:flutter/material.dart';
import '../../colors.dart';

class IngredientsSection extends StatefulWidget {
  final List<Map<String, String>> ingredients;
  final void Function(List<Map<String, String>>) onChanged; // her change'de parent page haber versin

  const IngredientsSection({
    super.key,
    required this.ingredients,
    required this.onChanged,
  });

  @override
  State<IngredientsSection> createState() => _IngredientsSectionState();
}

class _IngredientsSectionState extends State<IngredientsSection> {
  late List<Map<String, String>> _ingredients;

  @override
  void initState() {
    super.initState();
    _ingredients = [...widget.ingredients];
  }

  void _notify() {
    widget.onChanged(_ingredients);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final w = size.width;
    final h = size.height;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            for (int i = 0; i < _ingredients.length; i++)
              Padding(
                padding: EdgeInsets.only(bottom: h * 0.02),
                child: _ingredientRow(i, w),
              ),
          ],
        ),

        SizedBox(height: h * 0.01),

        _addButton("+ Add Ingredient", () {
          setState(() {
            _ingredients.add({"amount": "", "name": ""});
          });
          _notify();
        }, w),
      ],
    );
  }



  Widget _ingredientRow(int index, double w) {
    return Row(
      children: [
        _miniBox(
          w * 0.22,
          TextField(
            onChanged: (v) {
              _ingredients[index]["amount"] = v;
              _notify();
            },
            decoration: const InputDecoration(
              hintText: "Amount",
              border: InputBorder.none,
            ),
          ),
        ),

        SizedBox(width: w * 0.03),

        _miniBox(
          w * 0.48,
          TextField(
            onChanged: (v) {
              _ingredients[index]["name"] = v;
              _notify();
            },
            decoration: const InputDecoration(
              hintText: "Ingredient",
              border: InputBorder.none,
            ),
          ),
        ),

        SizedBox(width: w * 0.03),

        GestureDetector(
          onTap: () {
            setState(() {
              _ingredients.removeAt(index);
            });
            _notify();
          },
          child: _deleteBtn(),
        ),
      ],
    );
  }

  Widget _miniBox(double width, Widget child) {
    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.ligtGreen.withOpacity(.55),
        borderRadius: BorderRadius.circular(20),
      ),
      child: child,
    );
  }

  Widget _deleteBtn() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.ligtGreen,
      ),
      child: const Icon(Icons.delete_outline, color: AppColors.darkGreen),
    );
  }

  Widget _addButton(String text, VoidCallback onTap, double w) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: w * 0.035),
        decoration: BoxDecoration(
          color: AppColors.darkGreen,
          borderRadius: BorderRadius.circular(20),
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          style: TextStyle(color: Colors.white, fontSize: w * 0.045),
        ),
      ),
    );
  }
}
