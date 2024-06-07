import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ChartData {
  static List<PieChartSectionData> initialSections = [
    PieChartSectionData(
      color: Colors.blue,
      value: 1,
      title: '1',
      titleStyle: const TextStyle(
        fontWeight: FontWeight.bold,
        color: Color(0xffffffff),
      ),
    ),
    PieChartSectionData(
      color: Colors.orange,
      value: 4,
      title: '4',
      titleStyle: const TextStyle(
        fontWeight: FontWeight.bold,
        color: Color(0xffffffff),
      ),
    ),
    PieChartSectionData(
      color: Colors.red,
      value: 1,
      title: '1',
      titleStyle: const TextStyle(
        fontWeight: FontWeight.bold,
        color: Color(0xffffffff),
      ),
    ),
    PieChartSectionData(
      color: Colors.green,
      value: 5,
      title: '5',
      titleStyle: const TextStyle(
        fontWeight: FontWeight.bold,
        color: Color(0xffffffff),
      ),
    ),
  ];

  static int calculateTotal(List<PieChartSectionData> sections) {
    return sections.fold(0, (sum, section) => sum + section.value.toInt());
  }

  static PieChartSectionData updateSectionValue(
      PieChartSectionData section, double newValue) {
    return PieChartSectionData(
      color: section.color,
      value: newValue,
      title: newValue.toInt().toString(), // Formatar valor como inteiro
      titleStyle: section.titleStyle,
    );
  }

  static PieChartSectionData editSection(PieChartSectionData section) {
    final newValue = section.value + 1;
    return PieChartSectionData(
      color: section.color,
      value: newValue,
      title: newValue.toInt().toString(), // Formatar valor como inteiro
      titleStyle: section.titleStyle,
    );
  }
}
