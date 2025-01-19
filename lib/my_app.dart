import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_time_timer/main.dart';
import 'package:my_time_timer/provider/create_timer_controller.dart';
import 'dart:developer';

import 'package:my_time_timer/provider/timer_controller.dart';
import 'package:my_time_timer/provider/app_config_controller.dart';

import 'package:my_time_timer/utils/app_manager.dart';
import 'package:my_time_timer/utils/common_values.dart';
import 'package:my_time_timer/utils/db_manager.dart';

import 'package:my_time_timer/utils/isolate_timer.dart';
import 'package:my_time_timer/utils/size_util.dart';
import 'package:my_time_timer/viewModels/timer_view_model.dart';
import 'package:my_time_timer/repository/timer_repository.dart';
import 'package:my_time_timer/widgets/my_app_bar.dart';
import 'package:my_time_timer/widgets/timer_loader.dart';

import 'package:provider/provider.dart';

import 'package:my_time_timer/widgets/bottom_bar.dart';
import 'package:my_time_timer/widgets/timer/pizza_type.dart';
import 'package:my_time_timer/widgets/timer/battery_type.dart';


import 'package:my_time_timer/utils/timer_utils.dart' as utils;
import 'package:shared_preferences/shared_preferences.dart';

class MyApp extends StatelessWidget {

  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => TimerViewModel(), lazy: false,), // shared preference & sqlite // todo 얘는 프로바이더 안써도될거같음
        ChangeNotifierProvider(create: (context) => TimerController(), lazy: false), // isolate timer
        ChangeNotifierProvider(create: (context) => AppConfigController()),
        ChangeNotifierProvider(create: (context) => CreateTimerController()), // 타이머 생성 및 수정 화면
      ],
      child: MaterialApp(
        title: 'My Time Timer',
          theme: ThemeData(
              fontFamily: 'Pretendard'
            // fontFamily: 'NanumSquareNeo'
            // expansionTileTheme: ExpansionTileThemeData(
            //   // tilePadding : EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
            //   // childrenPadding : EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
            //   backgroundColor: Colors.grey[200],
            //   textColor: Colors.blue,
            // ),
          ),
        home:  const MyAppMain()),
    );
  }
}


class MyAppMain extends StatelessWidget {
  const MyAppMain({super.key});

  @override
  Widget build(BuildContext context) {
    SizeUtil().init(context); // SizeUtil 초기화

    AppManager.log('메인 생성', type : 'S');

    context.read<AppConfigController>().setMediaQuery = MediaQuery.of(context); // 미디어 쿼리 자주 호출하면 안됨


    Size safeSize = SizeUtil.get.safeSize;
    double mainLRPadding = (SizeUtil.get.sw * 0.075).roundToDouble(); // 가로 411 기준 약 31

    // print(MyAppBar(mainSize: safeSize).preferredSize.height); // AppBar 높이 확인

    context.read<TimerViewModel>().loadPresetDb();
    // AppManager.log("SQLite 프리셋 초기화",type: "S");

    // SharedPreferences에서 최근 사용 타이머 셋팅
    context.read<TimerController>().setCurrentTimer = TimerViewModel().loadRecentFromPrefs();

    /**
     * 현재 프레임이 끝난 후, 위젯 트리가 완전히 렌더링된 뒤 실행
     * UI와 충돌하는 것 방지(ex.이전 스크롤 위치로 이동..)
     */
    WidgetsBinding.instance.addPostFrameCallback((_) {}); // print('초기화');

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: MyAppBar(safeSize: safeSize),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container( // 임시
              height: SizeUtil.get.sh10,
              color: Colors.green.withOpacity(0.15),
            ),
            Container(
              color: Colors.blue.withOpacity(0.05),
                height: SizeUtil.get.sh70,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(mainLRPadding, 0, mainLRPadding, 0), // 좌우 7.5%씩 합 15%
                  child: Center(
                    child: TimerLoader().timerLoader(context, "pizza",TimerScreenType.main)
                    // child: TimerLoader().timerLoader(context, "battery",TimerScreenType.main)
                    // child: TimerLoader().timerLoader(context, "pizzaB",TimerScreenType.main)
                  ),
                )),
            SizedBox(
              height: SizeUtil.get.sh20,
              child: BottomBarWidget(safeSize: safeSize),
            ),
          ],
        ),
      ),
    );
  }
}