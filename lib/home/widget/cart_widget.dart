import 'package:flutter/material.dart';





class StatCardModel {
  final String value;
  final String title;
  final String? subtitle;
  final String change;
  final bool isPositive;

  StatCardModel({
    required this.value,
    required this.title,
    this.subtitle,
    required this.change,
    required this.isPositive,
  });
}

class StatCard extends StatelessWidget {
  final StatCardModel data;

  const StatCard(this.data);

  @override
  Widget build(BuildContext context) {
    final color = data.isPositive ? Colors.green : Colors.red;
    final icon = data.isPositive ? Icons.arrow_upward : Icons.arrow_downward;

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            data.value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(
              height: 4),

          Text(
            data.title,
            textAlign: TextAlign.end,
            style: const TextStyle(fontSize: 14 ),
          ),
          if (data.subtitle != null)
            Text(
              data.subtitle!,
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [

              Text(
                data.change,
                style: TextStyle(color: color, fontSize: 14),
              ),
              const SizedBox(width: 4),
              Icon(icon, size: 14, color: color),
            ],
          ),
        ],
      ),
    );
  }
}
