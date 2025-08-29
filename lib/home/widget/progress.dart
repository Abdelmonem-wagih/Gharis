import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gana/core/unit/images.dart';
import 'package:gana/home/logic/progress/progress_cubit.dart';
// Import the Cubit

class CustomProgressBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProgressCubit(),
      child: BlocBuilder<ProgressCubit, double>(
        builder: (context, progress) {
          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'الجنة',
                    style: TextStyle(color: Colors.green, fontSize: 14),
                  ),
                  Text(
                    'غرس',
                    style: TextStyle(color: Colors.green, fontSize: 14),
                  ),
                ],
              ),
              SizedBox(height: 5),
              Stack(
                children: [
                  // Background progress bar
                  Container(
                    height: 10,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.green[100],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  // Foreground progress bar
                  Container(
                    height: 10,
                    width: MediaQuery.of(context).size.width * progress,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  // Moving SVG icon
                  Positioned(
                    left: (MediaQuery.of(context).size.width - 24) * progress,
                    child: SvgPicture.asset(
                      AppImages.tree, // Add your tree image in assets
                      height: 24,
                      width: 24,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Slider(
                value: progress,
                min: 0,
                max: 1,
                onChanged: (value) {
                  context.read<ProgressCubit>().updateProgress(value);
                },
                activeColor: Colors.green,
                inactiveColor: Colors.green[100],
              ),
            ],
          );
        },
      ),
    );
  }
}
