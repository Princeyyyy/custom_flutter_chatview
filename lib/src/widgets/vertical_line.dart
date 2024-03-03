import 'package:flutter/material.dart';

class VerticalLine extends StatelessWidget {
  const VerticalLine({
    super.key,
    this.leftPadding = 0,
    this.rightPadding = 0,
    required this.color,
  });

  /// Allow user to set left padding.
  final double leftPadding;

  /// Allow user to set left padding.
  final double rightPadding;

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 2.7,
      margin: EdgeInsets.only(
        left: leftPadding,
        right: rightPadding,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(1.35),
        color: color,
      ),
    );
  }
}
