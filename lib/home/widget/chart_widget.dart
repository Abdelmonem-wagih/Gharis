import 'package:flutter/material.dart';
import 'package:gana/core/unit/color/colors.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

class StatisticCardWithChart extends StatelessWidget {
  final List<int> dataPoints;
  final String value;
  final String label;
  final int percentageChange;
  final bool isPositive;

  const StatisticCardWithChart({
    super.key,
    required this.dataPoints,
    required this.value,
    required this.label,
    required this.percentageChange,
    required this.isPositive,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Mini Line Chart
          SizedBox(
            width: 80,
            height: 40,
            child: (dataPoints.isEmpty || dataPoints.any((e) => e == null || e.isNaN || e.isInfinite))
                ? const Center(child: Text('No data'))
                : SfSparkLineChart(
              data: dataPoints.map((e) => e.toDouble()).toList(), // convert to double
              color: Colors.red,
              marker: const SparkChartMarker(
                displayMode: SparkChartMarkerDisplayMode.last,
                color: Colors.red,
              ),
              axisLineColor: Colors.transparent,
            ),
          ),


          // Value and Label
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [

                  Icon(
                    isPositive ? LucideIcons.arrowUp : LucideIcons.arrowDown,
                    color: isPositive ? Colors.green : Colors.red,
                    size: 14,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    "${isPositive ? '+' : '-'}${percentageChange.toStringAsFixed(1)}%",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: isPositive ? Colors.green : Colors.red,
                    ),
                  ),
                  const SizedBox(width: 4),

                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
