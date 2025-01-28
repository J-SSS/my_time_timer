import 'package:flutter/material.dart';
import 'package:flutter_icons_null_safety/flutter_icons_null_safety.dart';
import 'dart:async';
import 'dart:math' as math;
import 'package:provider/provider.dart';
import 'package:my_time_timer/my_app.dart';
import 'package:my_time_timer/screen/on_timer_screen.dart' as on_timer_screen;
import 'package:my_time_timer/screen/select_theme_screen.dart' as theme_screen;
import 'package:my_time_timer/screen/setting_screen.dart' as setting_screen;
import 'package:my_time_timer/provider/timer_controller.dart';
import 'package:my_time_timer/provider/app_config_controller.dart';

import '../screen/create_timer_screen.dart';
import '../screen/preset_screen.dart';
import '../utils/app_utils.dart';
import '../utils/size_util.dart';
import '../utils/timer_utils.dart';
import 'package:my_time_timer/manager/app_manager.dart';

class BottomBarWidget extends StatefulWidget{
  final Size safeSize;
  const BottomBarWidget({super.key, required this.safeSize});

  @override
  State<StatefulWidget> createState() => _BottomBarWidgetState();
}

class _BottomBarWidgetState extends State<BottomBarWidget>{
  // late Timer _timer; // 타이머
  var _time = 60; // 실제 늘어날 시간
  var _isPause = false;
  // late Size safeSize;

    @override
    Widget build(BuildContext context){
      return Container(
        // color: Colors.red.withOpacity(0.55),// 임시
        width: SizeUtil.get.sw,
        height: SizeUtil.get.sh * 0.15,
        alignment: Alignment.center,
        child: Container(
            width: SizeUtil.get.sw * 0.9,
            height: SizeUtil.get.sh * 0.15 * 0.65,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(50),
              boxShadow: [
                BoxShadow(
                  color: Colors.blueGrey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child:
                  SizedBox(
                    // width: SizeUtil.get.sw * 0.8 * 0.7,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        TextButton( /** 리스트 버튼 */
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => PresetScreen()), // 프리셋 화면
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              shape: const CircleBorder(),
                              // padding: EdgeInsets.all(10.0),
                              // fixedSize: Size(55.0, 55.0),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(MaterialCommunityIcons.format_list_bulleted_type,size: 30,),//format_paint
                                Text("List")
                              ]
                              ,)
                        ),
                        TextButton( /** 칼라 버튼 */
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => CreateTimerScreen()),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50), // 둥근 모서리
                                // side: BorderSide(
                                //   color: Colors.blueGrey, // 테두리 색상
                                //   width: 1, // 테두리 두께
                                // ),
                              ),
                              padding: EdgeInsets.all(0.0),
                              fixedSize: Size(65.0, 65.0),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Image.asset(
                                //   'assets/icon/btm_theme.png',
                                //   width: 30,
                                //   height: 30,
                                // ), circle-edit-outline
                                Icon(MaterialCommunityIcons.circle_edit_outline,size: 30,),
                                // wrench-clock clock-edit-outline
                                // Icon(MaterialCommunityIcons.edit,size: 30,),
                                Text("Edit")
                              ]
                              ,)
                        ),
                        TextButton( /** 루프 설정 버튼 */
                            onPressed: () {
                              context.read<TimerController>().setLoopBtn = 'set';
                              showOverlayInfo(context,"메시지");
                              showOverlayInfo(context,"초기화");
                            },
                            style: ElevatedButton.styleFrom(
                              shape: const CircleBorder(),
                              padding: EdgeInsets.all(0.0),
                              fixedSize: Size(65.0, 65.0),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Image.asset(
                                //   'assets/icon/${context.select((TimerController t) => t.loopBtn)}.png',
                                //   width: 30,
                                //   height: 30,
                                // ),
                                Icon(MaterialCommunityIcons.repeat,size: 30,),//format_paint
                                Text("Repeat")
                              ]
                              ,)
                        ),
                      ],
                    ),
                  ),
                ),
                Container( // 재생버튼 부분
                  // color: Colors.redAccent.withOpacity(0.1),
                  // width: SizeUtil.get.sw * 0.8 * 0.3,
                  width: SizeUtil.get.sh * 0.2 * 0.5,
                  child: TextButton(
                    onPressed: () async {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => on_timer_screen.OnTimerScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: CircleBorder(),
                      // padding: EdgeInsets.all(13.0),
                      padding: EdgeInsets.all(0.0),
                      // fixedSize: Size(90.0, 90.0),
                    ),
                    child:  Image.asset(
                      'assets/icon/${context.select((TimerController t) => t.playBtn)}.png',fit: BoxFit.fill,

                    ),
                  ),
                ),


              ],
            )
        ),

      );
    }
}