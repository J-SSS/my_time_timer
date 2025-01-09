import 'package:flutter/material.dart';

const colorList = [
  Colors.red,
  Colors.amber,
  Colors.deepOrangeAccent,
  Colors.tealAccent,
  Colors.blue,
  Colors.greenAccent,
  Colors.purpleAccent,
  Colors.lightBlueAccent,
  Colors.grey,
  Colors.indigoAccent,
];

enum TimerStyle {a,b,c}
enum TimerScreenType {main, timer, theme, create } /// 타이머 타입 (메인, 온타이머, 테마선택, 타이머 생성)
enum TimeUnit { sec, min, hour } /// 시간 단위
enum RemainTimeStyle { none, hms, per } /// 잔여 시간 표시 스타일