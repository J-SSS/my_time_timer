import 'dart:core';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:my_time_timer/models/timer_model.dart';
import 'package:my_time_timer/provider/create_timer_controller.dart';
import 'dart:async';
import 'dart:math' as math;
import 'package:provider/provider.dart';
import 'package:my_time_timer/provider/timer_controller.dart';
import 'package:my_time_timer/provider/app_config_controller.dart';

import 'package:my_time_timer/utils/timer_utils.dart' as utils;

import '../../utils/common_values.dart';
import '../../utils/size_util.dart';
import '../../viewModels/timer_view_model.dart';


// double 타입 소수점 n자리 까지
extension DoubleExtension on double {
  double toFixed(int fractionDigits) {
    double mod = pow(10.0, fractionDigits).toDouble();
    return ((this * mod).round()) / mod; // 버림
  }
}

class PizzaType extends StatefulWidget {
  Size safeSize;
  TimerScreenType screenType;
  PizzaType({required this.safeSize, super.key, this.screenType = TimerScreenType.main});

  @override
  State<StatefulWidget> createState() {
    return _PizzaTypeState();
  }
}

class _PizzaTypeState extends State<PizzaType> {
  _PizzaTypeState();
  Timer? _timer; // 타이머 객체
  int setupTime = 45;
  late TimerModel _timerModel;

  @override
  Widget build(BuildContext context) {
    if(widget.screenType == TimerScreenType.main){ /// 메인 화면
      setupTime = context.select((TimerController T) => T.setupTime);
      _timerModel = TimerModel(); // 임시
      // _timerModel = context.select((TimerController T) => T.currentTimer);

    } else if(widget.screenType == TimerScreenType.timer) { /// 타이머 작동 중
      setupTime = context.select((TimerController T) => T.remainTime);
      _timerModel = TimerModel(); // 임시
    } else if(widget.screenType == TimerScreenType.theme) { /// 테마 선택 화면
      _timerModel = TimerModel(); // 임시
      // Future.delayed(Duration(seconds: 1), () {
      //   setState(() {
      //     setupTime--; // 값 증가
      //   });
      // });
    } else if(widget.screenType == TimerScreenType.create) { /// 타이머 디자인 화면
      setupTime = context.select((TimerController T) => T.setupTime);
      _timerModel = context.select((CreateTimerController T) => T.timerModel);

    }

    print('피자 리빌드');
    Size safeSize = SizeUtil.get.safeSize;

    // return FutureBuilder(
    //     future: TimerViewModel().loadPresetDb3(),
    //     builder: (context, snapshot) {
    //       if (snapshot.connectionState == ConnectionState.waiting) {
    //         return CircularProgressIndicator();
    //       } else {
    //         final data = snapshot.data;
    //         return Text('Result: $data');
    //         return CustomPaint(
    //           size: safeSize,
    //           // size: Size(double.infinity,double.infinity), // 원하는 크기로 지정
    //           painter: PizzaTypePainter(
    //             setupTime: setupTime,
    //             uiData: uiData,
    //           ),
    //         );
    //       }
    // });


    return CustomPaint(
      size: safeSize,
      // size: Size(double.infinity,double.infinity), // 원하는 크기로 지정
      painter: PizzaTypePainter(
        setupTime: setupTime,
        timerModel : _timerModel,
      ),
    );
  }
}

class PizzaTypePainter extends CustomPainter {
  int setupTime;
  TimerModel timerModel;

  PizzaTypePainter({
    required this.setupTime,
    required this.timerModel,
  });

  /// 진행도에 따른 색상 인덱스 값을 찾는다
  int assignColorIndex (int ratio){
    List<int> colorRange = colorAssignList[timerModel.timerColorList.length-1];
    int colorIdx = 0;

    for (var i = 0; i < colorRange.length; ++i) {
      if(colorRange[i] <= ratio){
        colorIdx = i;
        break;
      }
    }

    return colorIdx;
  }

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..style = PaintingStyle.fill; // 채우기로 변경

    int ratio = (setupTime / timerModel.maxTime * 100).round();


    // 색상 지정
    int colorIdx = timerModel.timerColorList[assignColorIndex(ratio)];
    paint.color = colorList[colorIdx];
    // print("페인터 내부 사이즈 : " + size.toString());

    double centerX = size.width / 2;
    double centerY = size.height / 2;
    // double radius = size.width / 2;
    double radius = size.width <= size.height ? size.width / 2 : size.height / 2;

    double startAngle = -math.pi / 2; // 12시 방향에서 시작
    var sweepAngle = (2 * math.pi) / 60 * setupTime;
    // todo 라디안법 찾아보기 2파이는 180도, 2파이r은 원의 둘레

    var sweepAngleOne = (2 * math.pi) / 60 * 1; // 한 칸당 각도
    // print(startAngle);
    // print(sweepAngleOne);

    if (sweepAngle == 0.0 || sweepAngle.toFixed(2) == (2 * math.pi).toFixed(2)) {
      // 시간 꽉 채우는 경우
      Offset center = Offset(size.width / 2, size.height / 2);
      canvas.drawCircle(center, radius, paint);
    } else if(sweepAngle < 0){

    } else {
      Path path = Path()
        ..moveTo(centerX, centerY) // 중심으로 이동
        ..arcTo(
          Rect.fromCircle(center: Offset(centerX, centerY), radius: radius),
          startAngle,
          sweepAngle,
          false,
        )
        ..close(); // 닫힌 도형으로 만듦
      canvas.drawPath(path, paint);
    }

    // // 중심점
    Paint innerPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    Paint outerPaint = Paint()
      ..color = Colors.black26
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;
    //
    double innerRadius = radius / 15;
    //
    Offset center = Offset(size.width / 2, size.height / 2);
    canvas.drawCircle(center, innerRadius, innerPaint);
    canvas.drawCircle(center, innerRadius, outerPaint);


    /// 남은 시간 표시
    if(timerModel.remainTimeStyle == 1){  /// 남은 시간 표시 여부 (0 : 표시안함, 1 : hh:mm:ss, 2 : 00%)
      // TextPainter 설정
      final textPainter = TextPainter(
        text: TextSpan(
          text: utils.parseTimeString(timerModel.timeUnit, setupTime),
          style: TextStyle(
            color: Colors.white,
            fontSize: size.width / 10,
          ),
        ),
        textDirection: TextDirection.ltr, // 텍스트 방향
      );

      textPainter.layout(minWidth: 0, maxWidth: size.width);

      // 배경 박스 먼저 그리기
      // const double padding = 15.0;
      double padding = size.width * 0.04;
      final textRect = Rect.fromLTWH(
        (size.width - textPainter.width) / 2 - padding,
        (size.height - textPainter.height) / 2  + 70 - size.width * 0.02, // 상단 패딩
        textPainter.width + padding * 2, // 텍스트 너비 + 좌우 패딩
        textPainter.height + padding, // 텍스트 높이 + 상하 패딩
      );

      RRect textrRect = RRect.fromRectAndRadius(textRect, Radius.circular(15));
      final textRectPaint = Paint()..color = Colors.blueGrey.withOpacity(0.5);
      canvas.drawRRect(textrRect, textRectPaint);

      final offset = Offset( // 텍스트 그릴 위치 계산
        (size.width - textPainter.width) / 2,  // 수평 중앙 정렬
        (size.height - textPainter.height) / 2 + 70, // 수직 중앙 정렬
      );

      textPainter.paint(canvas, offset); // 텍스트 그리기
    }


  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class PizzaTypeBase extends StatefulWidget {
  Size safeSize;
  PizzaTypeBase({required this.safeSize,super.key});

  @override
  State<StatefulWidget> createState() {
    return _PizzaTypeStateBase();
  }
}

class _PizzaTypeStateBase extends State<PizzaTypeBase> {
  @override
  Widget build(BuildContext context) {
    Size safeSize = SizeUtil.get.safeSize;
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

    // 원의 중심과 반지름 설정
    final Offset center = Offset(size.width / 2, size.height / 2);
    // final double radius = 50.0;

    // Path에 원(oval) 추가
    final Rect circleRect = Rect.fromCircle(center: center, radius: radius);
    final Path circlePath = Path()..addOval(circleRect);

    // 1) 그림자 먼저 그리기
    //    매개변수: (Path path, Color color, double elevation, bool transparentOccluder)
    //    - elevation이 클수록 그림자가 강하게(멀리) 나타납니다.
    canvas.drawShadow(circlePath, Colors.blueGrey.withOpacity(0.1), 10.0, true);

    // 2) 실제 원 그리기
    final Paint circlePaint = Paint()..color = Colors.white70;
    // canvas.drawPath(circlePath, circlePaint);



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