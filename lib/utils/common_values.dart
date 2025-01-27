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
// ..color = Color(0xFF56B5B7) // 진한 민트
//   ..color = Color.fromRGBO(106, 211, 211, 1.0) // 민트
/// 진행도 비교용 값 리스트
const colorAssignList = [
  [0], // ["~100%"],
  [50, 0], // ["~100%", "~50%"],
  [66, 33, 0], // [ "~100%", "~66%", "~33%"]
  [75, 50, 25, 0], // [ "~100%", "~75%", "~50%", "~25%"],
  [80, 60, 40, 20, 0] // ["~100%", "~80%", "~60%", "~40%", "~20%"]
];

// todo 사용 코드 추가하기
const remainTimeIconist = [
  Icon(Icons.mode_edit),
  Icon(Icons.mode_edit),
  Icon(Icons.mode_edit)
];


enum TimerStyle {a,b,c}
enum TimerScreenType {main, timer, theme, create } /// 타이머 타입 (메인, 온타이머, 테마선택, 타이머 생성)
enum TimeUnit { sec, min, hour } /// 시간 단위
enum RemainTimeStyle { none, hms, per } /// 잔여 시간 표시 스타일