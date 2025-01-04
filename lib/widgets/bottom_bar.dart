import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math' as math;
import 'package:provider/provider.dart';
import 'package:my_time_timer/my_app.dart';
import 'package:my_time_timer/screen/on_timer_screen.dart' as on_timer_screen;
import 'package:my_time_timer/screen/select_theme_screen.dart' as theme_screen;
import 'package:my_time_timer/screen/setting_screen.dart' as setting_screen;
import 'package:my_time_timer/provider/timer_controller.dart';
import 'package:my_time_timer/provider/app_config_controller.dart';

import '../utils/app_utils.dart';
import '../utils/timer_utils.dart';
import 'package:my_time_timer/utils/app_manager.dart';

class BottomBarWidget extends StatefulWidget{
  final Size safeSize;
  const BottomBarWidget({super.key, required this.safeSize});

  @override
  State<StatefulWidget> createState() => _BottomBarWidgetState();
}

class _BottomBarWidgetState extends State<BottomBarWidget>{
  late Timer _timer; // 타이머
  var _time = 60; // 실제 늘어날 시간
  var _isPause = false;
  late Size safeSize;

  @override
  Widget build(BuildContext context) {
    safeSize = context.read<AppConfigController>().safeSize; // 미디어 사이즈 초기화
    return Stack(
      children: <Widget>[
        Positioned( /** 하단 사각 영역 */
          top: safeSize.height * 0.2 * 0.25,
          left: safeSize.width * 0.225,
          child: Container(
              width: safeSize.width * 0.55,
              height: safeSize.height * 0.2 * 0.45,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(50),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blueGrey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton( /** 좌버튼 */
                    onPressed: () {
                      // _reset();
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => theme_screen.SelectThemeScreen(safeSize : safeSize)),
                        // MaterialPageRoute(builder: (context) => setting_screen.MySettingScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      shape: CircleBorder(),
                      padding: EdgeInsets.all(10.0),
                      fixedSize: Size(65.0, 65.0),
                    ),
                    child:  Image.asset(
                      'assets/icon/btm_theme.png',
                    ),
                  ),
                  TextButton( /** 우버튼 */
                    onPressed: () {
                      context.read<TimerController>().setLoopBtn = 'set';
                      showOverlayInfo(context,safeSize,"메시지");
                    },
                    style: ElevatedButton.styleFrom(
                      shape: CircleBorder(),
                      padding: EdgeInsets.all(10.0),
                      fixedSize: Size(65.0, 65.0),
                    ),
                    child:  Image.asset(
                      'assets/icon/${context.select((TimerController t) => t.loopBtn)}.png',
                    ),
                  ),
                ],
              )
          ),
        ),
        Positioned( /** 재생버튼 */
            left : safeSize.width * 0.4,
            child: Container(
              width: safeSize.width * 0.2,
              height: safeSize.width * 0.2,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(50),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    offset: const Offset(0, -1),
                  ),
                ],
              ),
              child: TextButton(
                onPressed: () {
                  // _click(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => on_timer_screen.OnTimerScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: CircleBorder(),
                  padding: EdgeInsets.all(10.0),
                  fixedSize: Size(90.0, 90.0),
                ),
                child:  Image.asset(
                  'assets/icon/${context.select((TimerController t) => t.playBtn)}.png',
                ),
              ),
            )
        ),
      ],
    );
  }

  // void _click(BuildContext context) {
  //   var _isPlaying = !context.read<TimerController>().isPlaying;
  //
  //   if(_isPlaying) {
  //     context.read<TimerController>().isPlaying = true;
  //     context.read<TimerController>().isPause = false;
  //     context.read<TimerController>().ableEdit = false;
  //     context.read<TimerController>().setPlayBtn = 'btn_pause';
  //
  //     _start(context);
  //   } else {
  //     context.read<TimerController>().isPlaying = false;
  //     context.read<TimerController>().isPause = true;
  //     context.read<TimerController>().ableEdit = true;
  //     context.read<TimerController>().setPlayBtn = 'btn_play';
  //
  //     _pause();
  //   }
  // }

  // 타이머 시작
  // void _start(BuildContext context) {
  //   _timer = Timer.periodic(Duration(seconds: 1), (timer) {
  //     _time--;
  //     context.read<TimerController>().setSetupTime = _time;
  //   });
  //
  // }
  //
  // // 타이머 정지
  // void _pause() {
  //   _timer?.cancel();
  // }
  //
  // // 초기화
  // void _reset() {
  //   context.read<TimerController>().setPlayBtn = 'btn_play';
  //   context.read<TimerController>().isPlaying = false;
  //   context.read<TimerController>().setSetupTime = 60;
  //
  //   _timer?.cancel();
  // }
}