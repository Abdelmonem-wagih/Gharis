import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Center(
            child: Image.asset(
              'assets/app_logo.png',
              width: 180,
              height: 180,
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 32,
            child: SvgPicture.asset(
              'assets/ifq.svg',
              width: 120,
              height: 60,
            ),
          ),
        ],
      ),
    );
  }
}
