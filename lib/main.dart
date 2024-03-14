import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_time_timer/base_timer.dart';

// log('[ ########### IsolateTimer 생성 ########### ]',name:"SYSTEM");
// print('\x1B[31m[ ##### IsolateTimer 생성 ##### ]\x1B[0m');

// debugPrint('\x1B[31m[ ########### $message ########### ]\x1B[0m')

class AppManager {
  // static late IsolateTimerRunner isolateTimer;
  // static IsolateTimerRunner isolateTimer = await IsolateTimerRunner.create();

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

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // jdi 찾아보기 : 비동기 환경에서 초기화를 보장한다?
  final prefs = await SharedPreferences.getInstance();
  runApp(MyApp(prefs: prefs));
}
