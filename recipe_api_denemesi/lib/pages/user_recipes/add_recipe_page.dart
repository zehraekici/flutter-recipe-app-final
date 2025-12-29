import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../colors.dart';

import 'package:image_picker/image_picker.dart';

import '../../main_screen.dart';
import '../../provider/user_recipes_manager.dart';

import '../../widgets/btn_confirm.dart';
import '../../widgets/ingredients_section.dart';
import '../../widgets/select_chip.dart';

import '../../../data/meal_categories.dart';
import '../../../data/meal_areas.dart';
import '../../widgets/select_dropdown.dart';

class AddRecipePage extends StatefulWidget {
  const AddRecipePage({super.key});

  @override
  State<AddRecipePage> createState() => _AddRecipePageState();
}

class _AddRecipePageState extends State<AddRecipePage> {
  File? selectedImage;

  final picker = ImagePicker();

  Future<void> pickImage() async {
    final XFile? img = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (img != null) {
      setState(() => selectedImage = File(img.path));
    }
  }

  // text controllers == textfied in icerigine erismek icin !!!!
  final titleCtrl = TextEditingController();
  final ingredientCtrl = TextEditingController();
  final instructionCtrl = TextEditingController();
  final categoryCtrl = TextEditingController(); // yeni
  final areaCtrl = TextEditingController(); // yeni

  String? selectedCategory; // başta seçim yapmadiği için null da tutabilmeli

  String? selectedArea;


  List<Map<String, String>> ingredients = [
    {"amount": "", "name": ""},
  ];

  List<String> instructions = [""];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final w = size.width;
    final h = size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.beige,
        surfaceTintColor: Colors.white,
        titleSpacing: w * 0.05,
        centerTitle: true,
        //leading: Icon(Icons.circle_outlined, color: AppColors.darkGreen),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back,
            color: AppColors.darkGreen,
            size: w * 0.065,
          ),
        ),
        title: Text(
          "Add Recipe",
          style: TextStyle(
            fontSize: w * 0.055,
            fontWeight: FontWeight.w600,
            color: AppColors.darkGreen,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: w * 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // _topActions(w),
            SizedBox(height: h * 0.02),

            // PHOTO PLACEHOLDER
            GestureDetector(
              onTap: pickImage,
              child: Container(
                width: double.infinity,
                height: h * 0.25,
                decoration: BoxDecoration(
                  color: AppColors.ligtGreen.withOpacity(.55),
                  borderRadius: BorderRadius.circular(w * 0.06),
                ),
                child: selectedImage == null
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.photo_camera,
                            size: w * 0.18,
                            color: AppColors.darkGreen.withOpacity(.6),
                          ),
                          SizedBox(height: h * 0.01),
                          Text(
                            "Add Photo",
                            style: TextStyle(
                              fontSize: w * 0.04,
                              color: Colors.black45,
                            ),
                          ),
                        ],
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(w * 0.06),
                        child: Image.file(
                          selectedImage!,
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
              ),
            ),

            SizedBox(height: h * 0.025),

            //TITLE
            _label("Title", w),
            _inputField("Recipe Name", w, controller: titleCtrl),

            SizedBox(height: h * 0.02),

            _label("Categories", w),
            SizedBox(height: h * 0.015),

            Wrap(
              spacing: w * 0.02,
              runSpacing: w * 0.03,
              children: List.generate(mealCategories.length, (i) {
                final text = mealCategories[i];
                final isSelected = (selectedCategory == text);

                return SelectChip(
                  text: text,
                  selected: isSelected,
                  onSelected: (_) {
                    setState(() => selectedCategory = text);
                  },
                );
              }),
            ),

            SizedBox(height: h * 0.025),

            // AREA (Dropdown olan )
            _label("Area", w),
            SizedBox(height: h * 0.015),

            SelectDropdown(
              label: "Area",
              width: w,
              items: mealAreas,
              value: selectedArea,
              onChanged: (val) {
                setState(() => selectedArea = val);
              },
            ),

            SizedBox(height: h * 0.025),

            _label("Ingredients", w),
            SizedBox(height: h * 0.015),
            // _ingredientsSection(w, h),
            IngredientsSection(
              ingredients: ingredients,
              onChanged: (updatedList) {
                setState(() {
                  ingredients = updatedList;
                });
              },
            ),
            SizedBox(height: h * 0.03),

            // instructions
            _label("Instructions", w),
            SizedBox(height: h * 0.012),
            _inputField(
              "Recipe Instructions",
              w,
              maxLines: 3,
              controller: instructionCtrl,
            ),

            SizedBox(height: h * 0.03),

            _topActions(w),

            SizedBox(height: h * 0.03),
          ],
        ),
      ),
    );
  }

  Widget _topActions(double w) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // PUBLISH
        GestureDetector(
          child: _roundedButton("Publish", w),
          onTap: () {
            showDialog(
              context: context,
              builder: (_) => BtnConfirm(
                title: "Publish Recipe",
                message: "Are you sure you want to publish the recipe?",
                confirmText: "Publish",
                onConfirm: _saveRecipe,
              ),
            );
          },
        ),

        // DELETE
        // GestureDetector(
        //   child: _roundedButton("Delete", w),
        //   onTap: () {
        //     showDialog(
        //       context: context,
        //       builder: (_) => BtnConfirm(
        //         title: "Delete Recipe",
        //         message: "Are you sure you want to delete recipe?",
        //         confirmText: "Sil",
        //         onConfirm: () {},
        //       ),
        //     );
        //   },
        // ),
      ],
    );
  }

  Widget _roundedButton(String text, double w) {
    return Container(
      width: w * 0.40,
      padding: EdgeInsets.symmetric(vertical: w * 0.025),
      decoration: BoxDecoration(
        color: AppColors.darkGreen,
        borderRadius: BorderRadius.circular(w * 0.07),
      ),
      alignment: Alignment.center,
      child: Text(
        text,
        style: TextStyle(
          fontSize: w * 0.045,
          fontWeight: FontWeight.w500,
          color: AppColors.beige,
        ),
      ),
    );
  }

  Widget _label(String text, double w) {
    return Text(
      text,
      style: TextStyle(
        fontSize: w * 0.055,
        fontWeight: FontWeight.w600,
        color: AppColors.darkGreen,
      ),
    );
  }

  // controller da param artık (YOKSA KARIŞIYOR)
  Widget _inputField(
    String hint,
    double w, {
    required TextEditingController controller,
    int maxLines = 1,
  }) {
    return Container(
      margin: EdgeInsets.only(top: w * 0.02),
      padding: EdgeInsets.symmetric(horizontal: w * 0.04, vertical: w * 0.02),
      decoration: BoxDecoration(
        color: AppColors.ligtGreen,
        borderRadius: BorderRadius.circular(w * 0.07),
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(hintText: hint, border: InputBorder.none),
      ),
    );
  }

  void _saveRecipe() async {
    // Artık UserRecipe() UI’da oluşturulmuyor, Manager oluşturuyor
    await context.read<UserRecipesManager>().addUserRecipe(
      name: titleCtrl.text,
      thumbnail: selectedImage?.path ?? "",
      instructions: instructionCtrl.text,
      category: selectedCategory ?? "",
      area: selectedArea ?? "",
      ingredients: ingredients
          .map((e) => "${e['amount']} ${e['name']}")
          .toList(),
    );

    // Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //       builder: (_) => const UserRecipePage(),
    //     ),
    //   );

 
    Navigator.pop(context);

    //MainScreen'in ikinci tabına (User Recipes) geç
    final mainState = context.findAncestorStateOfType<MainScreenState>();
    mainState?.setIndex(1);
  }
}
