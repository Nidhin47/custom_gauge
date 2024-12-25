import 'dart:math';
import 'package:flutter/material.dart';

class Gauge extends StatefulWidget {
  final double value;
  final double maxValue;
  final Color needleColor;

  Gauge({this.value = 0.0, this.maxValue = 100.0, this.needleColor = Colors.black});

  @override
  _GaugeState createState() => _GaugeState();
}

class _GaugeState extends State<Gauge> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _needleRotation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );
    _needleRotation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    _animationController.repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      height: 200,
      child: Stack(
        children: [
          // Needle
          Transform.rotate(
            angle: _needleRotation.value * (widget.value / widget.maxValue) * 2 * pi,
            child: Padding(
              padding: EdgeInsets.all(50),
              child: SizedBox.expand(
                child: CustomPaint(
                  painter: NeedlePainter(
                    needleColor: widget.needleColor,
                  ),
                ),
              ),
            ),
          ),
          // Gauge background
          SizedBox.expand(
            child: CustomPaint(
              painter: GaugeBackgroundPainter(),
            ),
          ),
        ],
      ),
    );
  }
}

class NeedlePainter extends CustomPainter {
  final Color needleColor;

  NeedlePainter({this.needleColor = Colors.black});

  @override
  void paint(Canvas canvas, Size size) {
    Paint needlePaint = Paint()
      ..color = needleColor
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    Path needlePath = Path()
      ..moveTo(size.width / 2, size.height / 4)
      ..lineTo(size.width / 2, size.height / 4 * 3);

    canvas.drawPath(needlePath, needlePaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class GaugeBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Background circle
    Paint backgroundPaint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(Offset(size.width / 2, size.height / 2), size.width / 2 - 10, backgroundPaint);

    // Labels
    TextPainter textPainter = TextPainter(
      text: TextSpan(text: '100', style: TextStyle(fontSize: 20, color: Colors.black)),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(size.width / 2 - textPainter.width / 2, size.height / 2 - textPainter.height / 2));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
