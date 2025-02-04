import 'dart:core';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:my_time_timer/provider/create_timer_controller.dart';
import 'dart:async';
import 'dart:math' as math;
import 'package:provider/provider.dart';
import 'package:my_time_timer/provider/timer_controller.dart';
import 'package:my_time_timer/provider/app_config_controller.dart';

import 'package:my_time_timer/utils/timer_utils.dart' as utils;

import '../../utils/common_values.dart';
import '../../utils/size_util.dart';


// double 타입 소수점 n자리 까지
extension DoubleExtension on double {
  double toFixed(int fractionDigits) {
    double mod = pow(10.0, fractionDigits).toDouble();
    return ((this * mod).round()) / mod; // 버림
  }
}

class PizzaTypeB extends StatefulWidget {
  TimerScreenType screenType;
  PizzaTypeB({super.key, this.screenType = TimerScreenType.main});

  @override
  State<StatefulWidget> createState() {
    return _PizzaTypeBState();
  }
}

class _PizzaTypeBState extends State<PizzaTypeB> {
  _PizzaTypeBState();
  Timer? _timer; // 타이머 객체
  int setupTime = 45;

  Map<String,dynamic> uiData = { // 기본 값
    "timeUnit" : 0, // 시간 단위 (0 : 초, 1 : 분, 2 : 시간)
    "maxTime" : 60, // 최대 시간
    "remainTimeStyle" : 1, // 남은 시간 표시 여부 (0 : 표시안함, 1 : hh:mm:ss, 2 : 00%)
    "alarmType" : 1, // 무음/진동/알람 (0 : 무음, 1 : 진동, 2 : 소리)
    "timerColorList" : [0,1,2,3,4], // 타이머 색상 리스트 (최대 5개)
  };

  @override
  Widget build(BuildContext context) {
    if(widget.screenType == TimerScreenType.main){ /// 메인 화면
      setupTime = context.select((TimerController T) => T.setupTime);
    } else if(widget.screenType == TimerScreenType.timer) { /// 타이머 작동 중
      setupTime = context.select((TimerController T) => T.remainTime);
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
      //     setupTime--; // 값 증가
      //   });
      // });
    } else if(widget.screenType == TimerScreenType.create) { // 타이머 디자인 화면
      setupTime = context.select((TimerController T) => T.setupTime);

    }
    // widget.isOnTimer ? context.select((TimerController T) => T.remainTime) : context.select((TimerController T) => T.setupTime),
    print('피자 리빌드');
    // print(setupTime);
    Size safeSize = SizeUtil().safeSize;
    // print(safeSize);
    return CustomPaint(
      size: safeSize,
      // size: Size(double.infinity,double.infinity), // 원하는 크기로 지정
      painter: PizzaTypePainter(
        setupTime: setupTime,
        uiData : uiData,
      ),
    );
  }
}

class PizzaTypePainter extends CustomPainter {
  int setupTime;
  Map<String,dynamic> uiData;

  int _timeUnit ;  /// 시간 단위 (0 : 초, 1 : 분, 2 : 시간)
  int _maxTime ; /// 최대 시간
  int _remainTimeStyle;  /// 남은 시간 표시 여부 (0 : 표시안함, 1 : hh:mm:ss, 2 : 00%)
  int _alarmType; /// 무음/진동/알람 (0 : 무음, 1 : 진동, 2 : 소리)
  List<int> _timerColorList; /// 타이머 색상 리스트 (최대 5개)

  PizzaTypePainter({
    required this.setupTime,
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

    int ratio = (setupTime / _maxTime * 100).round();

    // 색상 지정
    int colorIdx = _timerColorList[assignColorIndex(ratio)];
    paint.color = colorList[colorIdx];

    // print("페인터 내부 사이즈 : " + size.toString());

    double centerX = size.width / 2;
    double centerY = size.height / 2;
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
    } else {
      var rect = Rect.fromCircle(center: Offset(centerX, centerY), radius: radius);
      Path path = Path();

      for (var i = 0; i < setupTime; i++) {
        path.moveTo(centerX, centerY); // 중심으로 이동
        var startAngle2 = startAngle + sweepAngleOne * i + 0.02;
        var sweepAngleOn2 = sweepAngleOne - 0.02;
        path.arcTo(rect, startAngle2, sweepAngleOn2, false);
      }
      path.close(); // 닫힌 도형으로 만듦
      canvas.drawPath(path, paint);

      Paint innerPaint = Paint()
        ..style = PaintingStyle.fill // 채우기로 변경
      ..color = Colors.white.withOpacity(0.8);

      Path path2 = Path()
        ..moveTo(centerX, centerY) // 중심으로 이동
        ..arcTo(
          Rect.fromCircle(center: Offset(centerX, centerY), radius: radius / 10 * 8),
          startAngle,
          sweepAngle,
          false,
        )
        ..close(); // 닫힌 도형으로 만듦
      // paint.color = paint.color.withOpacity(0.5);

      canvas.drawPath(path2, paint); // 칸 구분 없는 80% 사이즈 반투명 원으로 채움 // todo 한방에 그리도록 개선 필요
      canvas.drawPath(path2, innerPaint); // 흰색 부분

      canvas.drawCircle(Offset(centerX, centerY), radius / 10 * 6.5, innerPaint);
    }

    /// 남은 시간 표시
    if(_remainTimeStyle == 1){  /// 남은 시간 표시 여부 (0 : 표시안함, 1 : hh:mm:ss, 2 : 00%)
      // TextPainter 설정
      final textPainter = TextPainter(
        text: TextSpan(
          text: utils.parseTimeString(_timeUnit, setupTime),
          style: TextStyle(
            color: Colors.white,
            fontSize: size.width / 7,
            fontWeight: FontWeight.bold
          ),
        ),
        textDirection: TextDirection.ltr, // 텍스트 방향
      );

      textPainter.layout(minWidth: 0, maxWidth: size.width);

      // 배경 박스 먼저 그리기
      double padding = size.width * 0.04;
      final textRect = Rect.fromLTWH(
        (size.width - textPainter.width) / 2 - padding,
        (size.height - textPainter.height) / 2 - padding, // 상단 패딩
        textPainter.width + padding * 2, // 텍스트 너비 + 좌우 패딩
        textPainter.height + padding * 2, // 텍스트 높이 + 상하 패딩
      );

      RRect textrRect = RRect.fromRectAndRadius(textRect, Radius.circular(15));
      final textRectPaint = Paint()..color = Colors.blueGrey.withOpacity(0.8);
      canvas.drawRRect(textrRect, textRectPaint);

      final offset = Offset( // 텍스트 그릴 위치 계산
        (size.width - textPainter.width) / 2,  // 수평 중앙 정렬
        (size.height - textPainter.height) / 2, // 수직 중앙 정렬
      );

      textPainter.paint(canvas, offset); // 텍스트 그리기
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class PizzaTypeBaseB extends StatefulWidget {
  PizzaTypeBaseB({super.key});

  @override
  State<StatefulWidget> createState() {
    return _PizzaTypeBStateBase();
  }
}

class _PizzaTypeBStateBase extends State<PizzaTypeBaseB> {
  @override
  Widget build(BuildContext context) {
    Size safeSize = SizeUtil().safeSize;
    return CustomPaint(
      size: safeSize, // 원하는 크기로 지정
      painter: pizzaTypeBBasePainter(
        context: context,
      ),
    );
  }
}

class pizzaTypeBBasePainter extends CustomPainter {
  BuildContext context;

  pizzaTypeBBasePainter({required this.context});

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