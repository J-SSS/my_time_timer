import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math' as math;
import 'package:provider/provider.dart';
import 'package:my_time_timer/provider/timer_controller.dart';
import 'package:my_time_timer/provider/app_config_controller.dart';


class PizzaType extends StatefulWidget {
  bool isOnTimer = false;

  PizzaType({super.key, required this.isOnTimer});

  @override
  State<StatefulWidget> createState() {
    return _PizzaTypeState();
  }
}

class _PizzaTypeState extends State<PizzaType> {
  _PizzaTypeState();

  @override
  Widget build(BuildContext context) {
    // print('피자타입 ${widget.isOnTimer}');
    Size safeSize = context.read<AppConfigController>().safeSize;
    return CustomPaint(
      size: safeSize, // 원하는 크기로 지정
      painter: PizzaTypePainter(
        angleToMin: widget.isOnTimer ? context.select((TimerController T) => T.remainTime) : context.select((TimerController T) => T.setupTime),
      ),
    );
  }
}

class PizzaTypePainter extends CustomPainter {
  int angleToMin;

  PizzaTypePainter({
    required this.angleToMin,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
    ..color = Colors.red
    // ..color = Color(0xFF56B5B7) // 진한 민트
    //   ..color = Color.fromRGBO(106, 211, 211, 1.0) // 민트
      ..style = PaintingStyle.fill; // 채우기로 변경

    double centerX = size.width / 2;
    double centerY = size.height / 2;
    double radius = size.width / 2;

    double startAngle = -math.pi / 2; // 12시 방향에서 시작

    var sweepAngle = (2 * math.pi) / 60 * angleToMin!;

    if (sweepAngle == 0.0 || sweepAngle == 2 * math.pi) {
      // 시간 꽉 채우는 경우
      Offset center = Offset(size.width / 2, size.height / 2);
      canvas.drawCircle(center, radius, paint);
    } else if(sweepAngle < 0){

    } else {
      Path path = Path()
        ..moveTo(centerX, centerY) // 중심으로 이동
        ..lineTo(centerX + radius * math.cos(startAngle),
            centerY + radius * math.sin(startAngle)) // 시작점으로 이동
        ..arcTo(
          Rect.fromCircle(center: Offset(centerX, centerY), radius: radius),
          startAngle,
          sweepAngle,
          false,
        ) // 부채꼴 그리기
        ..close(); // 닫힌 도형으로 만듦

      canvas.drawPath(path, paint);
    }

    // 중심점
    Paint innerPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    Paint outerPaint = Paint()
      ..color = Colors.black26
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    double innerRadius = size.width / 50;

    Offset center = Offset(size.width / 2, size.height / 2);
    canvas.drawCircle(center, innerRadius, innerPaint);
    canvas.drawCircle(center, innerRadius, outerPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class PizzaTypeBase extends StatefulWidget {
  const PizzaTypeBase({super.key});

  @override
  State<StatefulWidget> createState() {
    return _PizzaTypeStateBase();
  }
}

class _PizzaTypeStateBase extends State<PizzaTypeBase> {
  @override
  Widget build(BuildContext context) {
    Size safeSize = context.read<AppConfigController>().safeSize;
    return CustomPaint(
      size: safeSize, // 원하는 크기로 지정
      painter: pizzaTypeBasePainter(
        context: context,
      ),
    );
  }
}

class pizzaTypeBasePainter extends CustomPainter {
  BuildContext context;

  pizzaTypeBasePainter({required this.context});

  @override
  void paint(Canvas canvas, Size size) {
    double radius = size.width / 2;

    for (int angle = 0; angle < 360; angle += 6) {
      int subRadius = 0;
      final Paint paint = Paint()..color = Colors.grey;

      if (angle % 30 == 0) {
        paint..strokeWidth = 3.5;
        subRadius = 3;
      } else {
        paint..strokeWidth = 1.0;
        subRadius = 0;
      }

      final double radians = angle * (math.pi / 180); // 각도를 라디안으로 변환

      final double startX = size.width / 2 + (radius - 8) * math.cos(radians);
      final double startY = size.height / 2 + (radius - 8) * math.sin(radians);

      final double endX =
          size.width / 2 + (radius + subRadius + 4) * math.cos(radians);
      final double endY =
          size.height / 2 + (radius + subRadius + 4) * math.sin(radians);

      // 원의 둘레를 따라 직선 그리기
      canvas.drawLine(
        Offset(startX, startY),
        Offset(endX, endY),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}