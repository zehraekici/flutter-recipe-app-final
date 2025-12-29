import 'package:flutter/material.dart';

import 'colors.dart';
import 'pages/favorites/favs_page.dart';
import 'pages/home/home_page.dart';
import 'pages/user_recipes/user_recipe_page.dart';

// private ydi bozdun (offline da SORUN VAR)
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  int _index = 0;

  final _pages = const [HomePage(), FavoritesPage(), UserRecipePage()];

  // //offline iken buton çalışsın diye (homepage'de)
  // void goToFavorites() {
  //   setState(() => _index = 1);
  // }

  
  // AddRecipePage vb başka yerden tab değiştirmek için
  void setIndex(int i) {
    setState(() {
      _index = i;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // IndexedStack => scroll state vb kaybolmasın diye
      body: IndexedStack(index: _index, children: _pages),

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          //ClipRRect => köseleri yuvarlamak icin
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: BottomNavigationBar(
              backgroundColor:  AppColors.beige, //Color.fromARGB(255, 246, 255, 238),
              selectedItemColor: AppColors.darkGreen,
              unselectedItemColor: AppColors.darkGreen.withOpacity(0.55),
              showSelectedLabels: false,
              showUnselectedLabels: false,
              currentIndex: _index,
              //!!!
              onTap: (i) => setState(() => _index = i), // tıklanan index i ayarla sonra rebuild et
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home_outlined),
                  activeIcon: Icon(Icons.home),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.favorite_border),
                  activeIcon: Icon(Icons.favorite),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person_outlined),
                  activeIcon: Icon(Icons.person),
                  label: '',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
