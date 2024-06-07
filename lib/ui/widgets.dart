import 'package:flutter/material.dart';

Widget buildLegend(String title, Color color) {
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        width: 16,
        height: 16,
        color: color,
      ),
      const SizedBox(width: 4),
      Text(title),
    ],
  );
}
