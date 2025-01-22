import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math' as math;
import 'package:provider/provider.dart';
import 'package:my_time_timer/my_app.dart';
import 'dart:developer';

import 'package:my_time_timer/provider/app_config_controller.dart';
import 'package:my_time_timer/provider/timer_controller.dart';


int getUtc() {
  // print('현재 유닉스 시간 (초 단위): ${getUnixTimeInSeconds()}'); // 예: 1672531200
  return DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000;
}

int getUnixTimeInSeconds() {
  // print('현재 유닉스 시간 (초 단위): ${getUnixTimeInSeconds()}'); // 예: 1672531200
  return DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000;
}

int getUnixTimeInMilliseconds() {
  // print('현재 유닉스 시간 (밀리초 단위): ${getUnixTimeInMilliseconds()}'); // 예: 1672531200000
  return DateTime.now().toUtc().millisecondsSinceEpoch;
}

/// 시간을 mm:ss 포멧 문자열로 변환
String parseTimeString(int timeUnit, int setupTime){
  String timeString = "";
  if(timeUnit == 0){ /// 시간 단위 (0 : 초, 1 : 분, 2 : 시간)
    // int mm = angleToMin ~/ 60;
    // int ss = angleToMin % 60;

    String mm = (setupTime ~/ 60).toString().padLeft(2,"0");
    String ss = (setupTime % 60).toString().padLeft(2,"0");
    timeString = "$mm:$ss";
    // if(timeUnit <= 59){
    //   // timeString = "${mm.toString().padLeft(2,"0")}:${ss.toString().padLeft(2,"0")}";
    // } else {
    //   timeString = "$mm:$ss";
    //   // timeString = "${mm.toString().padLeft(2,"0")}:${ss.toString().padLeft(2,"0")}";
    // }
  }
  return timeString;
}

/// 원형 타입에서 클릭 위치를 1/60 시간 단위로 변환
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
