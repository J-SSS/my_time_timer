import 'dart:async';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_time_timer/main.dart';
import 'dart:isolate';
import 'package:my_time_timer/utils/timer_utils.dart' as utils;

import '../models/timer_model.dart';
import '../manager/app_manager.dart';


class IsolateManager extends ChangeNotifier {
  static final IsolateManager instance = IsolateManager._();

  IsolateManager._() {
    AppManager.log('Isolate Timer 초기화',type: "S");
    init(); // isolate 생성
  }

  late SendPort _sendPort;
  late ReceivePort _receivePort;
  late Isolate _isolate;

  int setupTime = 1;
  int _remainTime = 1;


  /// Isolate 타이머 실행
  void run() {
    _sendPort.send({
      'cmd': 'run',
      'setupTime': setupTime,
      'callback': '',
    });
  }

  /// Isolate 타이머 정지
  void cancel() {
    _sendPort.send({
      'cmd': 'cancel',
      'callback': '',
    });
  }

  /// Isolate 타이머 일시정지
  void pause() {
    _sendPort.send({
      'cmd': 'pause',
      'setupTime': setupTime,
      'callback': '',
    });
  }

  /// Isolate 타이머 시간 수정
  void update() {
    _sendPort.send({
      'cmd': 'update',
      'setupTime': setupTime,
      'callback': '',
    });
  }

  /** isolate 생성 & 메시지 수신시 처리 */
  void init() async {
    final ReceivePort receivePort = ReceivePort();
    final isolate = await Isolate.spawn(_isolateTimer, receivePort.sendPort); // Isolate를 생성하고 receivePort 전달
    receivePort.listen((msg) {
      if (msg is SendPort) {
        _sendPort = msg;
      } else {
        if (msg is Map && msg.containsKey('cmd')) {
          switch (msg['cmd']) {
            case ('run'):
              {
                _remainTime = msg['remainTime'];
              }
            case ('cancel'):
              {
                print('정지');
              }
          }
        }
        notifyListeners();
      }
    }, onDone: () {
      print('Isolate가 종료됨');
    }
    );

    _isolate = isolate;
    _receivePort = receivePort;


    // port.close(); todo 포트를 닫거나 kill로 없애줘야함
    // isolate.kill(priority: Isolate.immediate);

    // if (receivePort.isClosed) {

    // todo 안쓰는 경우 종료 코드 추가
    // Future.delayed(Duration(seconds: 3), () {
    //   isActive = false;
    //   receivePort.close();
    //   isolate.kill(priority: Isolate.immediate);
    //   print('Isolate가 비활성화됨: $isActive');
    // });

    // final now = DateTime.now();
    //
    // // 날짜와 시간 포맷팅
    // final formattedDate = DateFormat('yyyy-MM-dd').format(now);
    // final formattedTime = DateFormat('HH:mm:ss').format(now);
    //
    // print("포맷된 날짜: $formattedDate"); // 예: 2025-01-13
    // print("포맷된 시간: $formattedTime"); // 예: 14:30:45
    //
    //
    // final earlier = now.subtract(Duration(days: 1, hours: 3, minutes: 45)); // 과거 시간
    // final later = now.add(Duration(hours: 5, minutes: 30)); // 미래 시간
    // final end = DateTime(2025, 1, 13, 14, 5, 30);
    //
    // // final difference = now.difference(earlier);
    // final difference = later.difference(now); // 시간 차이를 계산
    //
    // final days = difference.inDays;
    // final hours = difference.inHours % 24; // 하루를 기준으로 나머지 계산
    // final minutes = difference.inMinutes % 60;
    // final seconds = difference.inSeconds % 60;
    //
    // print('시간 차이: ${days}일 ${hours}시간 ${minutes}분 ${seconds}초');

  }

  void _isolateTimer(SendPort sendPort) {
    final receivePort = ReceivePort();
    sendPort.send(receivePort.sendPort); // 메인 앱에 isolateTimer의 sendPort 보냄

    Timer? timer;
    int remainTime = 60;

    receivePort.listen((msg) {
      if (msg is Map && msg.containsKey('cmd')) {
        switch (msg['cmd']) {
          case ('run'):
            {
              if (timer == null || !timer!.isActive) {
                remainTime = msg['setupTime'].toInt();

                timer = Timer.periodic(Duration(seconds: 1), (timer) {
                  debugPrint('\x1B[33m[ ${--remainTime} 초  ]\x1B[0m');

                  sendPort.send({
                    'cmd': 'run',
                    'remainTime': remainTime,
                  });

                  if(remainTime < -1){
                    timer.cancel();
                  }
                });
              }
            }
          case ('cancel'):
            {
              sendPort.send({
                'cmd': 'cancel',
                'remainTime': remainTime,
              });
              timer?.cancel();

            }
        }
      }
    });
  }
}
