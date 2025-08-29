import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gana/core/unit/color/colors.dart';
import 'package:gana/core/unit/string/string.dart';
import '../logic/expand/expand.dart';

class ExpandableContainer extends StatelessWidget {
  const ExpandableContainer({super.key});

  @override
  Widget build(BuildContext context) {
    final isEvenDay = DateTime.now().day % 2 == 0;

    final List<String> parts = isEvenDay
        ? AppString.text2Parts  // a list of 3 strings
        : AppString.text1Parts; // also a list of 3 strings


    return BlocBuilder<ExpandCubit, bool>(
      builder: (context, isExpanded) {
        return Container(
          constraints: isExpanded
              ? const BoxConstraints(minWidth: double.infinity)
              : const BoxConstraints(), // shrink to content
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFFDCD0CC),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                onTap: () => context.read<ExpandCubit>().toggleExpand(),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Text(
                      'الدليل',
                      style: TextStyle(
                        color: Color(0xFF36474F),
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 6),
                    SvgPicture.asset('assets/ref.svg')
                  ],
                ),
              ),
              if (isExpanded) ...[
                const SizedBox(height: 10),
                RichText(
                  textDirection: TextDirection.rtl,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: parts[0],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w300,
                          fontFamily: 'CustomFont1',
                          height: 1.2,
                          color: AppColors.fontPrimary,
                        ),
                      ),
                      TextSpan(
                        text: parts[1],
                        style: const TextStyle(
                          fontSize: 16,
                          height: 1.2,
                          fontWeight: FontWeight.w600,
                          color: AppColors.fontPrimary,
                          fontFamily: 'CustomFont11',
                        ),
                      ),
                      TextSpan(
                        text: parts[2],
                        style: const TextStyle(
                          fontSize: 16,
                          fontFamily: 'CustomFont1',
                          height: 1.2,
                          fontWeight: FontWeight.w300,
                          color: AppColors.fontPrimary,
                        ),
                      ),
                    ],
                  ),
                ),

              ],
            ],
          ),
        );
      },
    );
  }
}
