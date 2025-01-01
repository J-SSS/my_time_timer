import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math' as math;
import 'package:provider/provider.dart';
import 'package:my_time_timer/my_app.dart';
import 'dart:developer';

import 'package:my_time_timer/provider/app_config_controller.dart';
import 'package:my_time_timer/provider/timer_controller.dart';

/** 원형 타입에서 클릭 위치를 1/60 시간 단위로 변환 */
int clickToTimePizza(Offset clickPoint, Size size, int maxUnit) {

  double centerX = (size.width - (size.width * 0.075).roundToDouble() * 2) / 2; // 좌우패딩 7.5%씩 보정
  double centerY = size.height * 0.7 / 2; // 중간 섹션 높이 70& 보정
  double radius = size.width / 2;
  // 페인터 내부 사이즈 : Size(349.4, 486.4)
  // print("계산 : ${(size.width - (size.width * 0.075).roundToDouble() * 2)},${size.height * 0.7}");

  double startAngle = -math.pi / 2; // 12시 방향에서 시작
  double clickAngle = math.atan2(clickPoint.dy - centerY, clickPoint.dx - centerX);
  double sweepAngle;

  // print(2 * math.pi/60); // 0.10471975511965977
  // print(sweepAngle/(2 * math.pi/60));

  // print('내림각도 : ${(sweepAngle/(2 * math.pi/60)).floor()}, 원본각도 : ${(sweepAngle/(2 * math.pi/60))}');
  // print( '시작각 : ${startAngle} , 클릭각 : ${clickAngle}, 차이각 : ${sweepAngle}, 임시 : ${(math.pi/2-clickAngle)} ');

  // print(clickPoint);
  // print(clickPoint.direction);

  if (clickAngle > -math.pi && clickAngle < startAngle) {
    // 180 ~ -90(270)도
    sweepAngle = 2 * math.pi + clickAngle - startAngle;
  } else {
    // -90 ~ 180도
    sweepAngle = clickAngle - startAngle;
  }

  int angleToUnit;
  angleToUnit = (sweepAngle / (2 * math.pi / maxUnit)).floor(); //
  angleToUnit == 0 ? angleToUnit = maxUnit : angleToUnit;

  return angleToUnit;
}

int clickToTimeBattery(Offset clickPoint, Size size, int maxUnit) {
  int angleToMin;

  double sizeH = size.height * 0.7;
  double strokeW = (sizeH * 0.03).floorToDouble(); // 선 굵기 3프로

  double netH = sizeH - (strokeW * 3); // 배경 여백 밑 테두리 제외한 높이 좌표
  double netLength = sizeH - (strokeW * 6); // 상, 하 여백 밑 테두리 제외한 빈공간 절대높이

  // print('섹션 갭 ${sectionGap}, 네트 높이 :  $netLength, 가용공간 : ${netLength - sectionGap * 9}',);
  // print('섹션높이 : ${(netLength - sectionGap * 9)/10}',);
  // print('네트높이 : ${netLength}, 시간 : ${clickToMin}, 클릭Y : ${clickPoint.dy}, 최대좌표 : ${netH}, 상단여백 : ${strokeW*2.5}');

  double sectionGap = (sizeH * 0.015).floorToDouble(); // 섹션 사이의 거리 // ex) 7
  double sectionLength = (netLength - sectionGap * 9) / 10; // ex) 33.231428571428566
  double sectionAmount = sectionLength + sectionGap; // gap 포함한 섹션 크기 ex) 40정도
  double clickY = clickPoint.dy;

  int drawCnt = 0;
  int pointToMin = 0;

  /** 클릭 위치에 따른 draw 좌표를 도출한다 */
  if(strokeW * 3 >= clickY){
    angleToMin = 60;
  } else if(netH <= clickY){
    angleToMin = 0;
  } else {
    for(int i = 0 ; i<10 ; i++){
      if(clickY < netH - (sectionAmount * i) && clickY > netH - (sectionAmount * (i+1))){
        double btm = netH - (sectionAmount * i);
        double top = netH - (sectionAmount * (i+1) - sectionGap);
        double gap = (btm-top)/6;
        double min = ((btm - clickY)/gap).floor()+1;

        if(min > 0 && min < 6){
          pointToMin = min.toInt();
        } else {
          pointToMin = 6;
        }
        drawCnt = i;
      }
    }
    angleToMin = (drawCnt * 6) + pointToMin;
  }
  return angleToMin;
}

// OverlayEntry? overlayEntryTime;
// OverlayEntry? overlayEntry;

const TextStyle overlayTextStyle = TextStyle(color: Colors.white, fontSize: 25 * 1, fontWeight: FontWeight.w800);

OverlayEntry? _overlayEntryTime; // 오버레이를 저장할 변수
Timer? _timerForTime; // 타이머를 저장할 변수
Timer? _overlayEntryTimer; // 타이머를 저장할 변수

/** 설정한 시간을 Overlay 위젯으로 표시 */
void showOverlayText(BuildContext context, Size size, String msg) {
  TextPainter textPainter = getTextPainter("${msg} mins",TextStyle(
      color: Colors.white,
      fontSize: 25,
      fontWeight: FontWeight.bold));

  // print(textPainter.);
  /* 기존 overlayEntry 있으면 삭제 */
  if(_overlayEntryTime != null){
    _overlayEntryTime?.remove();
    _overlayEntryTime = null;
    _timerForTime?.cancel();
  }

  /* 새 overlayEntry 등록 */
  _overlayEntryTime = OverlayEntry(
    builder: (context) => Center(
      child: Material( // todo Material 제거해도될듯
        color: Colors.transparent,
        child: Container(
          width: size.width * 0.35,
          height: size.height * 0.07,
          decoration: BoxDecoration(
            color: Colors.blueGrey.withOpacity(0.7),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Center(
            child: Text(
              "${msg} mins",
              style: overlayTextStyle,
            ),
          ),
        ),
      ),
    ),
  );

  Overlay.of(context).insert(_overlayEntryTime!);
  _timerForTime = Timer(Duration(milliseconds: 500), () {
    _overlayEntryTime?.remove();
    _overlayEntryTime = null;
  });


  // 업데이트 시 `overlayEntry.markNeedsBuild()` 호출
  // overlayEntry.markNeedsBuild();
}

/** TextPainter 얻기 */
TextPainter getTextPainter(String text, TextStyle style) {
  // TextSpan 생성
  TextSpan textSpan = TextSpan(text: text, style: style);

  // TextPainter 생성 및 설정
  TextPainter textPainter = TextPainter(
    text: textSpan,
    textDirection: TextDirection.ltr, // 텍스트 방향
  );
  // 텍스트 레이아웃 계산
  textPainter.layout();
  // painter.layout(maxWidth: 200); // 최대 너비를 설정
  return textPainter;
}


/** 정보를 Overlay 위젯으로 표시 */
void showOverlayInfo(BuildContext context, Size size, String msg) {
  TextPainter textPainter = getTextPainter("${msg} mins",TextStyle(
      color: Colors.white,
      fontSize: 25,
      fontWeight: FontWeight.bold));

  // print(textPainter.);
  /* 기존 overlayEntry 있으면 삭제 */
  if(_overlayEntryTime != null){
    _overlayEntryTime?.remove();
    _overlayEntryTime = null;
    _timerForTime?.cancel();
  }

  /* 새 overlayEntry 등록 */
  _overlayEntryTime = OverlayEntry(
    builder: (context) => Center(
      child: Material( // todo Material 제거해도될듯
        color: Colors.transparent,
        child: Container(
          width: size.width * 0.35,
          height: size.height * 0.07,
          decoration: BoxDecoration(
            color: Colors.blueGrey.withOpacity(0.7),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Center(
            child: Text(
              "${msg}",
              style: overlayTextStyle,
            ),
          ),
        ),
      ),
    ),
  );

  Overlay.of(context).insert(_overlayEntryTime!);
  _timerForTime = Timer(Duration(milliseconds: 700), () {
    _overlayEntryTime?.remove();
    _overlayEntryTime = null;
  });


  // 업데이트 시 `overlayEntry.markNeedsBuild()` 호출
  // overlayEntry.markNeedsBuild();
}


// // 제네릭 함수를 사용하여 특정 타입의 위젯을 찾기
// T? findWidgetByKey<T>(BuildContext context, Key key) {
//   return context.findAncestorWidgetOfExactType<T>();
// }



//   final customTimer = CustomTimer(duration: Duration(seconds: 5));
//   customTimer.start();
//
//   // 3초 후에 타이머 일시 정지
//   Future.delayed(Duration(seconds: 3), () {
//     customTimer.pause();
//     print('Timer paused at 3 seconds');
//   });
//
//   // 6초 후에 타이머 재개
//   Future.delayed(Duration(seconds: 6), () {
//     customTimer.resume();
//     print('Timer resumed at 6 seconds');
//   });
// }

/** 베이스 타이머 */
class BaseTimer {
  final Duration duration;
  late StreamController<int> _controller;
  late StreamSubscription<int> _subscription;

  BaseTimer({required this.duration}) {
    _controller = StreamController<int>();
    _subscription = _controller.stream.listen((event) {
      print('Timer tick: $event');
    });
  }

  void start() {
    int tick = 0;
    Timer.periodic(Duration(seconds: 1), (timer) {
      tick++;
      _controller.add(tick);
      if (tick == duration.inSeconds) {
        timer.cancel();
      }
    });
  }

  void pause() {
    _subscription.pause();
  }

  void resume() {
    _subscription.resume();
  }
}

/** 미디어쿼리 너비,높이 */
double mediaWidth(BuildContext context, double scale) => MediaQuery.of(context).size.width * scale;
double mediaHeight(BuildContext context, double scale) => MediaQuery.of(context).size.height * scale;
