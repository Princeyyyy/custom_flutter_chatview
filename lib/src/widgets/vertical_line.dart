import 'package:flutter/material.dart';

class VerticalLine extends StatelessWidget {
  const VerticalLine({
    super.key,
    this.leftPadding = 0,
    this.rightPadding = 0,
  });

  /// Allow user to set left padding.
  final double leftPadding;

  /// Allow user to set left padding.
  final double rightPadding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 2.5,
      color: const Color(0xffEE5366),
      margin: EdgeInsets.only(
        left: leftPadding,
        right: rightPadding,
      ),
    );
  }
}
