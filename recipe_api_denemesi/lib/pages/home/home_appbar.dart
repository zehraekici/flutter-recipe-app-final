import 'package:flutter/material.dart';
import '../../../colors.dart';
import '../../widgets/circle_icon.dart';

// padding olmadı sadece içerideki bosluk oldu o yüzden bu

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {

  // Opsiyonel callback'ler dısaridan geliyor
  final VoidCallback? onSearch;
  final VoidCallback? onAdd;

  const HomeAppBar({super.key, this.onSearch, this.onAdd});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final w = size.width;
    final h = size.height;

    return AppBar(
      elevation: 2, // golge ekliyor altına
      centerTitle: false,
      backgroundColor: AppColors.beige,
      surfaceTintColor: Colors.white,
      automaticallyImplyLeading: false,
      titleSpacing: w * 0.05,

      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Hi Chef !",
            style: TextStyle(
              fontSize: w * 0.06,
              color: AppColors.darkGreen,
              fontWeight: FontWeight.w600,
            ),
          ),

          SizedBox(height: h * 0.002),

          Text(
            "What are you cooking today?",
            style: TextStyle(fontSize: w * 0.040, color: Colors.black54),
          ),
        ],
      ),

      actions: [
        circleIcon(Icons.add, w, onTap: onAdd),

        SizedBox(width: w * 0.04),

        circleIcon(Icons.search, w, onTap: onSearch),

        SizedBox(width: w * 0.05),
      ],
    );
  }

  // Ortak yuvarlak ikon
  // Widget _circleIcon(
  //   IconData icon,
  //   double w, {
  //   VoidCallback? onTap,
  // }) {
  //   return GestureDetector(
  //     onTap: onTap,
  //     child: Container(
  //       width: w * 0.10,
  //       height: w * 0.10,
  //       decoration: BoxDecoration(
  //         color: AppColors.ligtGreen,
  //         shape: BoxShape.circle,
  //       ),
  //       child: Icon(
  //         icon,
  //         size: w * 0.055,
  //         color: const Color(0xFF7AA46A),
  //       ),
  //     ),
  //   );
  // }

  // @override
  // Size get preferredSize => const Size.fromHeight(kToolbarHeight + 20);

  @override
  Size get preferredSize {
    final view = WidgetsBinding.instance.platformDispatcher.views.first;

    final h = view.physicalSize.height / view.devicePixelRatio;
    return Size.fromHeight(h * 0.085);
  }
}
