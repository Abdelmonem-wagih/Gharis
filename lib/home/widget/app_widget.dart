import 'package:flutter/material.dart';
import 'package:gana/home/setting_screen.dart';

import '../../core/functions/save_monthly.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key, required this.haveIcon});
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
        Text(getHijriDateFormatted()),
      ],
    );
  }
}
