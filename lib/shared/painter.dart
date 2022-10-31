import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart';
import 'package:vnrdn_tai/shared/constants.dart';

class OpenPainter extends CustomPainter {
  OpenPainter(
      {required this.xmin,
      required this.ymin,
      required this.xmax,
      required this.ymax,
      required this.name});
  final double xmin;
  final double ymin;
  final double xmax;
  final double ymax;
  final String name;

  @override
  void paint(Canvas canvas, Size size) {
    var paint1 = Paint()
      ..color = Colors.yellow[100]!
      ..style = PaintingStyle.stroke;
    paint1.strokeWidth = 5;
    Rect rect = Rect.fromLTWH(xmin, ymin, xmax - xmin, ymax - ymin);
    TextSpan span = TextSpan(
        style: TextStyle(
            backgroundColor: Colors.yellow[100],
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 15),
        text: 'Biển $name');
    TextPainter tp = TextPainter(
        text: span,
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr);
    tp.layout();
    tp.paint(canvas, Offset(xmin, ymax));
    canvas.drawRect(rect, paint1);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;

  @override
  bool hitTest(Offset position) {
    Path path = Path();
    Rect rect = Rect.fromLTWH(xmin, ymin, xmax - xmin, ymax - ymin);
    path.addRect(rect);
    path.close();
    return path.contains(position);
  }
}
