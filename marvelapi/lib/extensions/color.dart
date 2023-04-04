import 'package:flutter/material.dart';

extension WidgetExtension on Widget {
  Widget withBackground(Color color) {
    return Container(
      color: color,
      child: this,
    );
  }
}