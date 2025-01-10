import 'dart:core';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:my_time_timer/provider/create_timer_controller.dart';
import 'dart:async';
import 'dart:math' as math;
import 'package:provider/provider.dart';
import 'package:my_time_timer/provider/timer_controller.dart';
import 'package:my_time_timer/provider/app_config_controller.dart';

import '../utils/common_values.dart';


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
  int angleToMin = 45;

  Map<String,dynamic> uiData = { // 기본 값
    "timeUnit" : 1, // 시간 단위 (0 : 초, 1 : 분, 2 : 시간)
    "maxTime" : 60, // 최대 시간
    "remainTimeStyle" : 1, // 남은 시간 표시 여부 (0 : 표시안함, 1 : hh:mm:ss, 2 : 00%)
    "alarmType" : 1, // 무음/진동/알람 (0 : 무음, 1 : 진동, 2 : 소리)
    "timerColorList" : [0], // 타이머 색상 리스트 (최대 5개)
  };

  @override
  Widget build(BuildContext context) {
    if(widget.screenType == TimerScreenType.main){ /// 메인 화면
      angleToMin = context.select((TimerController T) => T.setupTime);
    } else if(widget.screenType == TimerScreenType.timer) { /// 타이머 작동 중
      angleToMin = context.select((TimerController T) => T.remainTime);
    } else if(widget.screenType == TimerScreenType.theme) { /// 테마 선택 화면
      uiData = { // 기본값
        "timeUnit" : 0, // 시간 단위 (0 : 초, 1 : 분, 2 : 시간)
        "maxTime" : 60, // 최대 시간
        "remainTimeStyle" : 1, // 남은 시간 표시 여부 (0 : 표시안함, 1 : hh:mm:ss, 2 : 00%)
        "alarmType" : 0, // 무음/진동/알람 (0 : 무음, 1 : 진동, 2 : 소리)
        "timerColorList" : [0], // 타이머 색상 리스트 (최대 5개)
      };
      // Future.delayed(Duration(seconds: 1), () {
      //   setState(() {
      //     angleToMin--; // 값 증가
      //   });
      // });
    } else if(widget.screenType == TimerScreenType.create) { // 타이머 디자인 화면
      angleToMin = context.select((TimerController T) => T.setupTime);
      uiData = context.select((CreateTimerController T) => T.timerUIData);
    }
    // widget.isOnTimer ? context.select((TimerController T) => T.remainTime) : context.select((TimerController T) => T.setupTime),
    print('리빌드');
    // print(angleToMin);
    Size safeSize = context.read<AppConfigController>().safeSize;
    // print(safeSize);
    return CustomPaint(
      size: safeSize, // 원하는 크기로 지정
      painter: PizzaTypePainter(
        angleToMin: angleToMin,
        uiData : uiData,
      ),
    );
  }
}

class PizzaTypePainter extends CustomPainter {
  int angleToMin;
  Map<String,dynamic> uiData;

  int _timeUnit ;  /// 시간 단위 (0 : 초, 1 : 분, 2 : 시간)
  int _maxTime ; /// 최대 시간
  int _remainTimeStyle;  /// 남은 시간 표시 여부 (0 : 표시안함, 1 : hh:mm:ss, 2 : 00%)
  int _alarmType; /// 무음/진동/알람 (0 : 무음, 1 : 진동, 2 : 소리)
  List<int> _timerColorList; /// 타이머 색상 리스트 (최대 5개)

  PizzaTypePainter({
    required this.angleToMin,
    required this.uiData,
  }):
        _timeUnit = uiData['timeUnit'] ?? 0,
        _maxTime = uiData['maxTime'] ?? 60,
        _remainTimeStyle = uiData['remainTimeStyle'] ?? 0,
        _alarmType = uiData['alarmType'] ?? 0,
        _timerColorList = uiData['timerColorList'] ?? [0];

  /// 진행도에 따른 색상 인덱스 값을 찾는다
  int assignColorIndex (int ratio){
    List<int> colorRange = colorAssignList[_timerColorList.length-1];
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
    // ..color = Color(0xFF56B5B7) // 진한 민트
    //   ..color = Color.fromRGBO(106, 211, 211, 1.0) // 민트

    int ratio = (angleToMin / _maxTime * 100).round();

    // 색상 지정
    int colorIdx = _timerColorList[assignColorIndex(ratio)];
    paint.color = colorList[_timerColorList[colorIdx]];

    // print("페인터 내부 사이즈 : " + size.toString());

    double centerX = size.width / 2;
    double centerY = size.height / 2;
    double radius = size.width / 2;

    double startAngle = -math.pi / 2; // 12시 방향에서 시작
    // print(startAngle);
    var sweepAngle = (2 * math.pi) / 60 * angleToMin;
    // print(sweepAngle);
    // print(2 * math.pi);
    
    if (sweepAngle == 0.0 || sweepAngle.toFixed(2) == (2 * math.pi).toFixed(2)) {
      // print('여기');
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



    // _remainTimeStyle;

    String timeString = "";
    if(_timeUnit == 0){ /// 시간 단위 (0 : 초, 1 : 분, 2 : 시간)
      int mm;
      int ss;
      if(angleToMin <= 59){
        timeString = "00:${angleToMin.toString()}";
      } else {
        mm = angleToMin ~/ 60;
        timeString = "$mm:${angleToMin.toString()}";
      }
    }

    if(_remainTimeStyle == 1){  /// 남은 시간 표시 여부 (0 : 표시안함, 1 : hh:mm:ss, 2 : 00%)
      // TextPainter 설정 및 레이아웃
      final textPainter = TextPainter(
        text: TextSpan(
          text: timeString,
          // text: "가",
          style: TextStyle(
            color: Colors.white,
            fontSize: 40,
          ),
        ),
        textDirection: TextDirection.ltr, // 텍스트 방향
      );

      textPainter.layout(minWidth: 0, maxWidth: size.width);
      // print(textPainter.width);
      // print(textPainter.height);
      // 패딩 값 정의
      const double padding = 20.0;
      // // 배경 박스 그리기
      //   (size.width - textPainter.width) / 2,  // 수평 중앙 정렬
      // (size.height - textPainter.height) / 2 + 70, // 수직 중앙 정렬
      final rect = Rect.fromLTWH(
        (size.width - textPainter.width) / 2 - padding,
        (size.height - textPainter.height) / 2  + 60, // 상단 패딩
        textPainter.width + padding * 2, // 텍스트 너비 + 좌우 패딩
        textPainter.height + padding, // 텍스트 높이 + 상하 패딩
      );

      final paint2 = Paint()..color = Colors.blueGrey.withOpacity(0.5);
      RRect rRect = RRect.fromRectAndRadius(rect, Radius.circular(25));
      canvas.drawRRect(rRect, paint2);

      // 텍스트를 그릴 위치 계산 (패딩 포함)
      // final offset = Offset(padding, padding);

      final offset = Offset( // 텍스트 그릴 위치 계산
        (size.width - textPainter.width) / 2,  // 수평 중앙 정렬
        (size.height - textPainter.height) / 2 + 70, // 수직 중앙 정렬
      );

      // 텍스트 그리기
      textPainter.paint(canvas, offset);
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