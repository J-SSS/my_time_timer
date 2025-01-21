import 'dart:async';

import 'package:flutter/material.dart';

class AppManager {
  // static late IsolateTimerRunner isolateTimer;
  // static IsolateTimerRunner isolateTimer = await IsolateTimerRunner.create();
  // static int safeSize2 = 1;

  /// 로그 출력용
  static void log(String message, {String? type}){
    // int length = (30 - message.length~/2);
    String guideStr = '#' * 5;

    switch(type){
      case ('S') : { // System
        return debugPrint('\x1B[33m$guideStr System : $message $guideStr\x1B[0m');
      }
      case ('G') : { // Gesture
        return debugPrint('\x1B[34m$guideStr Gesture : $message $guideStr\x1B[0m');
      }
      case ('B') : { // Build
        return debugPrint('\x1B[32m$guideStr Build : $message $guideStr\x1B[0m');
      }
      default : {
        return debugPrint('\x1B[32m$guideStr AppLog : $message $guideStr\x1B[0m');
      }
    }
  }
}