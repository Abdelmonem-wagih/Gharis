import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gana/core/unit/color/colors.dart';
import 'package:gana/home/widget/app_widget.dart';
import 'package:gana/home/widget/button_tap_widget.dart';
import 'package:gana/home/widget/chart_widget.dart';
import 'package:gana/home/widget/expand_widget.dart';

import '../Form/presentation/bloc/user_form_cubit.dart';
import 'analytics_screen.dart';
import 'logic/math/counter_math_cubit.dart';
import 'logic/progress/increment_cubit.dart';
import 'logic/switch/switch_cubit.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final formState = context.read<UserFormCubit>().state;

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child:SingleChildScrollView(child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            SizedBox(
              height: 50,
            ),
            const AppWidget(
              haveIcon: true,
            ),
            Text('السلام عليكم،${formState.firstName}' ,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w400,
              ),
            ),
            const Text('هل غرست في جنتك اليوم؟' ,
              style:  TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: AppColors.primary,
              ),
            ),
          const  SizedBox(
              height: 20,
            ),
            const ExpandableContainer(),

            BlocBuilder<SwitchCubit, SwitchState>(builder: (context, switchState) {
              return switchState.dailyAnalyticsEnabled ? Container(
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.only(top: 15),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: InkWell(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AnalyticsScreen()),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Text(
                        'التحاليل اليومية',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                     const SizedBox(width: 6),
                      SvgPicture.asset(
                        'assets/analytics.svg',
                        color: Colors.white,
                      )
                    ],
                  ),
                ),
              ):const SizedBox();
            }),
            const SizedBox(
              height: 20,
            ),
          const  Text('غرسك اليومي' ,
              style:  TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            const Text('هدفنا هو ان يتجاوز غرسك الـ 100 يومياً' ,
              style:  TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            BlocBuilder<CounterCubit, CounterState>(
              builder: (context, state) {
                final cleanChartData = state.pressCounts
                    .where((e) => e != null && e.isFinite && !e.isNaN)
                    .map((e) => e.toInt())
                    .toList();

                final total = cleanChartData.fold(0, (a, b) => a + b);
                final lastSession =
                    cleanChartData.isNotEmpty ? cleanChartData.last : 0;
                int percentageChange = 0;

                if (cleanChartData.length > 1) {
                  final prevSession = cleanChartData[cleanChartData.length - 2];
                  percentageChange = lastSession - prevSession;
                }

                return StatisticCardWithChart(
                  dataPoints: cleanChartData,
                  value: total.toString(),
                  label: "مجموع غرسك",
                  percentageChange: percentageChange.abs(),
                  isPositive: percentageChange >= 0,
                );
              },
            ),

            // CustomProgressBar(),
            SizedBox(
              height: 50,
            ),
            TapToIncrement()
          ],
        ),
      ),
    ),);
  }
}
