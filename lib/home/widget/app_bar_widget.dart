import 'package:flutter/material.dart';

import '../../core/unit/color/colors.dart';
import '../setting_screen.dart';

class AppBarWidget extends StatelessWidget {
  const AppBarWidget({
    super.key,
    required this.title,
     this.haveIcon = false,
  });
  final String title;
  final bool haveIcon;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Visibility(
          visible: haveIcon,
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
            child: const Icon(
              Icons.menu,
            ),
          ),
        ),
        InkWell(
          hoverColor: Colors.transparent,
          focusColor: Colors.transparent,
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          onTap: () => Navigator.pop(context),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              ),
              const Icon(
                Icons.arrow_forward,
                color: AppColors.primary,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
