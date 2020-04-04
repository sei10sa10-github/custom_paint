import 'dart:math';

import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Center(
        child: Stack(alignment: Alignment.center, children: [
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).scaffoldBackgroundColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    offset: Offset(-5, -5),
                    blurRadius: 10,
                  ),
                  BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      offset: Offset(5, 5),
                      blurRadius: 10)
                ]),
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: CustomPaint(
                painter: GradientDonutsPainter(data: data),
              ),
            ),
          ),
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).scaffoldBackgroundColor,
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      offset: Offset(-5, -5),
                      blurRadius: 10),
                  BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      offset: Offset(5, 5),
                      blurRadius: 10),
                ]),
          ),
        ]),
      )),
    );
  }
}

class GradientDonutsPainter extends CustomPainter {

  static const redToYellow = [
    Color.fromRGBO(255, 74, 74, 1),
    Color.fromRGBO(252, 255, 74, 1),
  ];

  static const yellowToGreen = [
    Color.fromRGBO(252, 255, 74, 1),
    Color.fromRGBO(195, 255, 74, 1),
  ];

  static const greenToBlue = [
    Color.fromRGBO(195, 255, 74, 1),
    Color.fromRGBO(74, 249, 255, 1)
  ];

  static const List<List<Color>> colors = [redToYellow, yellowToGreen, greenToBlue];
  final List<int> data;

  GradientDonutsPainter({@required this.data});

  @override
  void paint(Canvas canvas, Size size) {
    Offset center = Offset(size.width / 2, size.height / 2);
    double radius = min(size.width / 2, size.height / 2);

    Rect boundingSquare = Rect.fromCircle(center: center, radius: radius);

    List<PieInfo> pie = getPieInfoFrom(data);

    pie.asMap().forEach((index, value) {
      canvas.drawArc(
          boundingSquare,
          value.startAngle,
          value.sweepAngle,
          false,
          getPaint(
              boundingSquare,
              pie[index].colors,
              value.startAngle,
              value.sweepAngle + value.startAngle,
              pie.length - 1 == index ? pi * 0.15 : 0));
    });
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }

  Paint getPaint(Rect boundingRect, List<Color> colors, double startAngle,
      double endAngle, double rotation) {
    Gradient gradient = SweepGradient(
        colors: colors,
        startAngle: startAngle,
        endAngle: endAngle,
        transform: GradientRotation(rotation));

    return Paint()
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = 50
      ..shader = gradient.createShader(boundingRect);
  }

  List<PieInfo> getPieInfoFrom(List<int> data) {
    final int sum = data.reduce((value, element) => value + element);
    double soFar = 0;
    List<PieInfo> result = [];
    data.asMap().forEach((index, value) {
      double sweepAngle = 360 * value / sum;
      PieInfo pie =
          PieInfo(startAngle: toRad(soFar), sweepAngle: toRad(sweepAngle), colors: colors[index]);
      soFar += sweepAngle;
      result.add(pie);
    });
    return result;
  }

  double toRad(double angle) {
    return angle * pi / 180;
  }
}

class PieInfo {
  final double startAngle;
  final double sweepAngle;
  final List<Color> colors;

  const PieInfo(
      {@required this.startAngle,
      @required this.sweepAngle,
      @required this.colors});
}

const data = [
  200,
  900,
  200,
];