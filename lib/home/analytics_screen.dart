import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gana/core/unit/color/colors.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:gana/home/widget/app_bar_widget.dart';
import 'package:gana/home/widget/cart_widget.dart';

import '../core/unit/string/string.dart';
import 'logic/math/counter_math_cubit.dart'; // Make sure the path is correct

class AnalyticsScreen extends StatefulWidget {
  @override
  _AnalyticsScreenState createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  int _selectedIndex = 1; // 0: Weekly, 1: Monthly, 2: Yearly
  final List<String> _labels = ['أسبوعي', 'شهري', 'سنوي'];

  List<_ChartData> _buildChartData(CounterState state) {
    if (_selectedIndex == 0) {
      return state.weeklyMap.entries
          .map((e) => _ChartData(e.key, e.value.toDouble()))
          .toList();
    } else if (_selectedIndex == 1) {
      return state.monthlyMap.entries
          .map((e) => _ChartData(e.key, e.value.toDouble()))
          .toList();
    } else {
      return state.totalList.asMap().entries.map((e) {
        return _ChartData('سنة ${e.key + 1}', e.value.toDouble());
      }).toList();
    }
  }

  List<StatCardModel> _buildCards(CounterState state) {
    final cleanChartData = state.pressCounts
        .where((e) => e != null && e.isFinite && !e.isNaN)
        .map((e) => e.toInt())
        .toList();

    final total = cleanChartData.fold(0, (a, b) => a + b);
    return [
      StatCardModel(
        value: state.weeklyTotal.toString(),
        title:
            'الغرس الاسبوعي',
        change: '+2.5%',
        isPositive: true,
      ),
      StatCardModel(
        value: total.toString(),
        title:
            'الغرس اليومي ${DateTime.now().day % 2 == 0 ? AppString.tree : AppString.palmTree}',
        change: '+0.5%',
        isPositive: true,
      ),
      StatCardModel(
        value: state.monthlyTotal.toString(),
        title: 'الحالة الشهري',
        change: '-5%',
        isPositive: false,
      ),
      StatCardModel(
        value: state.total.toString(),
        title: 'الحالة الكلية لغرسك',
        change: '-2.5%',
        isPositive: false,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: BlocBuilder<CounterCubit, CounterState>(
          builder: (context, state) {
            final cards = _buildCards(state);
            final chartData = _buildChartData(state);

            return Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const SizedBox(height: 50),
              const  AppBarWidget(title: 'التحاليل اليومية' , haveIcon: true,),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 15.0 , left: 25 , right: 25 , bottom: 10),
                    child: GridView.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 18,
                      crossAxisSpacing: 12,
                      childAspectRatio: 1.5,
                      children: cards.map((card) => StatCard(card)).toList(),
                    ),
                  ),
                ),

                const Text(
                  'مخطوط بياني لغرسك',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Text(
                  'يمكنك الاطلاع على غرسك بشكل اسبوعي، وشهري، وسنوي',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),

                SizedBox(
                  height: 35,
                  width: double.infinity,

                    child: ToggleButtons(
                      isSelected: List.generate(3, (i) => i == _selectedIndex),
                      onPressed: (int index) {
                        setState(() {
                          _selectedIndex = index;
                        });
                      },
                      borderRadius: BorderRadius.circular(12),
                      selectedColor: Colors.white,
                      fillColor: Colors.green,
                      children: _labels
                          .map((label) => Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 40),
                                child: Text(label),
                              ))
                          .toList(),
                    ),
                  ),

                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                //   child: SizedBox(
                //     height: 40,
                //     child: Row(
                //       children: List.generate(_labels.length, (index) {
                //         return Expanded(
                //           child: Padding(
                //             padding: const EdgeInsets.symmetric(horizontal: 2),
                //             child: ElevatedButton(
                //               style: ElevatedButton.styleFrom(
                //                 backgroundColor:
                //                 _selectedIndex == index ? Colors.green : Colors.white,
                //                 foregroundColor:
                //                 _selectedIndex == index ? Colors.white : Colors.black,
                //                 shape: RoundedRectangleBorder(
                //                   borderRadius: BorderRadius.circular(12),
                //                   side: const BorderSide(color: Colors.green),
                //                 ),
                //               ),
                //               onPressed: () {
                //                 setState(() {
                //                   _selectedIndex = index;
                //                 });
                //               },
                //               child: Text(_labels[index]),
                //             ),
                //           ),
                //         );
                //       }),
                //     ),
                //   ),
                // ),

                Expanded(
                  child: SfCartesianChart(
                    plotAreaBorderWidth: 0,
                    primaryXAxis:  CategoryAxis(
                      axisLine: AxisLine(width: 0),
                      majorTickLines: MajorTickLines(size: 0),
                      majorGridLines: MajorGridLines(width: 0),
                    ),
                    primaryYAxis:  LogarithmicAxis(
                      axisLine: AxisLine(width: 0),
                      majorTickLines: MajorTickLines(size: 0),
                      minimum: 1,
                      maximum: 10000,
                      interval: 1,
                      labelFormat: '{value}',
                      majorGridLines: MajorGridLines(width: 0),
                    ),
                    series: <LineSeries<_ChartData, String>>[
                      LineSeries<_ChartData, String>(
                        dataSource: chartData,
                        xValueMapper: (_ChartData data, _) => data.month,
                        yValueMapper: (_ChartData data, _) => data.value,
                        markerSettings: const MarkerSettings(isVisible: true),
                        dataLabelSettings:
                            const DataLabelSettings(isVisible: false),
                        color: Colors.green,
                        width: 2,
                        // Disabled: this screen's BlocBuilder can rebuild
                        // (or the whole route can be torn down, e.g. by
                        // notification-tap navigation) while the entrance
                        // animation is still running, which crashes with
                        // "A disposed RenderObject was mutated" inside
                        // syncfusion_flutter_charts.
                        animationDuration: 0,
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _ChartData {
  final String month;
  final double value;
  _ChartData(this.month, this.value);
}
