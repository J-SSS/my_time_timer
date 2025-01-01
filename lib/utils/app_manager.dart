import 'dart:async';

import 'package:flutter/material.dart';

class AppManager {
  // static late IsolateTimerRunner isolateTimer;
  // static IsolateTimerRunner isolateTimer = await IsolateTimerRunner.create();
  // static int safeSize2 = 1;

  /// 로그 출력용
  static void log(String message, {String? type}){
    int length = (26 - message.length~/2);
    String guideStr = '#' * length;

    switch(type){
      case ('T') : {
        return debugPrint('\x1B[33m[ $guideStr $message $guideStr ]\x1B[0m');
      }
      default : {
        return debugPrint('\x1B[31m[ $guideStr $message $guideStr ]\x1B[0m');
      }
    }
  }
}