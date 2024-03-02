import 'dart:ui';

import 'package:flutter/material.dart';

import '../utils/constants/constants.dart';

class GlassMorphismReactionPopup extends StatelessWidget {
  const GlassMorphismReactionPopup({
    super.key,
    required this.child,
  });

  /// Allow user to assign custom widget which is appeared in glass-morphism
  /// effect.
  final Widget child;

  Color get backgroundColor => Colors.white;

  double get strokeWidth => 2;

  Color get borderColor => Colors.grey.shade400;

  double get borderRadius => 30;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          constraints: const BoxConstraints(maxWidth: 350),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[
                backgroundColor.withAlpha(opacity),
                backgroundColor.withAlpha(opacity),
              ],
              stops: const <double>[
                0.3,
                0,
              ],
            ),
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          child: ClipRRect(
            clipBehavior: Clip.hardEdge,
            borderRadius: BorderRadius.circular(borderRadius),
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 8,
                sigmaY: 16,
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 6, horizontal: 14),
                child: child,
              ),
            ),
          ),
        ),
        IgnorePointer(
          ignoring: true,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: CustomPaint(
              painter: _GradientPainter(
                strokeWidth: strokeWidth,
                radius: borderRadius,
                borderColor: borderColor,
              ),
              child: Container(
                constraints: const BoxConstraints(maxWidth: maxWidth),
                padding: const EdgeInsets.symmetric(
                  vertical: 28,
                ),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.all(
                    Radius.circular(borderRadius),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _GradientPainter extends CustomPainter {
  _GradientPainter({
    required this.strokeWidth,
    required this.radius,
    required this.borderColor,
  });

  final double radius;
  final double strokeWidth;

  final Color borderColor;
  final Paint _paintObject = Paint();

  LinearGradient get _gradient => LinearGradient(
        begin: Alignment.bottomRight,
        end: Alignment.topLeft,
        colors: <Color>[
          borderColor.withAlpha(50),
          borderColor.withAlpha(55),
          borderColor.withAlpha(50),
        ],
        stops: const <double>[0.06, 0.95, 1],
      );

  @override
  void paint(Canvas canvas, Size size) {
    final RRect innerRect2 = RRect.fromRectAndRadius(
      Rect.fromLTRB(strokeWidth, strokeWidth, size.width - strokeWidth,
          size.height - strokeWidth),
      Radius.circular(radius - strokeWidth),
    );

    final RRect outerRect = RRect.fromRectAndRadius(
      Rect.fromLTRB(0, 0, size.width, size.height),
      Radius.circular(radius),
    );
    _paintObject.shader = _gradient.createShader(Offset.zero & size);

    final Path outerRectPath = Path()..addRRect(outerRect);
    final Path innerRectPath2 = Path()..addRRect(innerRect2);
    canvas.drawPath(
      Path.combine(
        PathOperation.difference,
        outerRectPath,
        Path.combine(
          PathOperation.intersect,
          outerRectPath,
          innerRectPath2,
        ),
      ),
      _paintObject,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
