import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../core/unit/color/colors.dart';
import '../../core/unit/images.dart';
import '../../core/unit/string/string.dart';
import '../../notification_service.dart';
import '../logic/math/counter_math_cubit.dart';
// import your CounterCubit

class TapToIncrement extends StatelessWidget {
  // Add a static notification plugin instance (should be initialized in main)


  // Helper to show notification


  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CounterCubit, CounterState>(
      builder: (context, state) {
        final count = state.pressCounts.fold<int>(0, (a, b) => a + b);

        // Determine the name based on the day
        final name = DateTime.now().day % 2 == 0 ? "نخلة" : "شجرة";

        // Show notification if count is a multiple of 100 and not zero
        if (count != 0 && count % 100 == 0) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            showNotification(count, name);
          });
        }

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SfLinearGauge(
              minimum: 0,
              maximum: 100,
              showTicks: false,
              showLabels: false,
              isAxisInversed: true,
              axisTrackStyle: LinearAxisTrackStyle(
                color: Colors.green[100],
                thickness: 10,
                edgeStyle: LinearEdgeStyle.bothCurve,
              ),
              barPointers: [
                LinearBarPointer(
                  value: count.toDouble(),
                  color: Colors.green,
                  thickness: 10,
                  edgeStyle: LinearEdgeStyle.bothCurve,
                ),
              ],
              markerPointers: [
                LinearWidgetPointer(
                  value: count.toDouble(),
                  position: LinearElementPosition.outside,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset(
                        AppImages.tree,
                        height: 20,
                        width: 20,
                      ),
                      Text(
                        '$count',
                        style: TextStyle(color: Colors.green, fontSize: 10),
                      ),
                      SizedBox(height: 5),
                    ],
                  ),
                ),
              ],
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('الجنة',
                    style: TextStyle(color: Colors.green, fontSize: 14)),
                Text('غرس',
                    style: TextStyle(color: Colors.green, fontSize: 14)),
              ],
            ),
            const SizedBox(height: 20),
             Text(
               DateTime.now().day % 2 == 0 ? AppString.text2 : AppString.text1,
             textAlign: TextAlign.center,
              style:const TextStyle(
                fontSize: 20,

                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 20),
            InkWell(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () {
                context.read<CounterCubit>().increment();
              },
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey[400],
                ),
                child: Center(
                  child: Text(
                    '$count',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'غرس الجنة',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 20),

          ],
        );
      },
    );
  }
}
