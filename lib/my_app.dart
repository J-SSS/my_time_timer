import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_time_timer/main.dart';
import 'package:my_time_timer/provider/create_timer_controller.dart';
import 'dart:developer';

import 'package:my_time_timer/provider/timer_controller.dart';
import 'package:my_time_timer/provider/app_config_controller.dart';
import 'package:my_time_timer/utils/app_manager.dart';
import 'package:my_time_timer/utils/common_values.dart';

import 'package:my_time_timer/utils/isolate_timer.dart';
import 'package:my_time_timer/utils/size_util.dart';
import 'package:my_time_timer/viewModels/timer_view_model.dart';
import 'package:my_time_timer/repository/timer_repository.dart';
import 'package:my_time_timer/widgets/my_app_bar.dart';
import 'package:my_time_timer/widgets/timer_loader.dart';

import 'package:provider/provider.dart';

import 'package:my_time_timer/widgets/bottom_bar.dart';
import 'package:my_time_timer/widgets/pizza_type.dart';
import 'package:my_time_timer/widgets/battery_type.dart';

import 'package:my_time_timer/widgets/list_drawer.dart';
import 'package:my_time_timer/utils/timer_utils.dart' as utils;
import 'package:shared_preferences/shared_preferences.dart';

class MyApp extends StatelessWidget {
  final SharedPreferences prefs;
  const MyApp({super.key, required this.prefs});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => TimerViewModel(TimerRepository(prefs)), lazy: false,), // shared preference
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

// GlobalKey 생성
  // final GlobalKey<_PizzaTypeState> pizzaTypeKey = GlobalKey<_PizzaTypeState>();

  @override
  Widget build(BuildContext context) {
    // SizeUtil.to.init(context); // SizeUtil 초기화
    SizeUtil().init(context); // SizeUtil 초기화
    AppManager.log('메인 생성', type : 'S');

    context.read<AppConfigController>().setMediaQuery = MediaQuery.of(context); // 미디어 쿼리 자주 호출하면 안됨
    Size safeSize = context.read<AppConfigController>().safeSize; // 미디어 사이즈 초기화
    double mainLRPadding = (safeSize.width * 0.075).roundToDouble(); // 가로 411 기준 약 31

    // print(MyAppBar(mainSize: safeSize).preferredSize.height); // AppBar 높이 확인
    // AppManager.log('앱 사이즈 확인');

    // 초기화
    context.read<TimerViewModel>().loadPreset();

    /**
     * 현재 프레임이 끝난 후, 위젯 트리가 완전히 렌더링된 뒤 실행
     * UI와 충돌하는 것 방지(ex.이전 스크롤 위치로 이동..)
     */
    WidgetsBinding.instance.addPostFrameCallback((_) {}); // print('초기화');
    // print(1.sw);
    // print(1.sh);
    // print(1.sp);
    // print(MediaQuery.of(context).size);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: MyAppBar(safeSize: safeSize),
      drawer: ListDrawer(), // 보조 화면
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container( // 임시
              height: SizeUtil().sh1,
              color: Colors.green.withOpacity(0.15),
            ),
            Container(
              color: Colors.blue.withOpacity(0.05),
                height: safeSize.height * 0.7,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(mainLRPadding, 0, mainLRPadding, 0), // 좌우 7.5%씩 합 15%
                  child: Center(
                    // child: TimerLoader().timerLoader(context, "pizza",TimerScreenType.main)
                    child: TimerLoader().timerLoader(context, "battery",TimerScreenType.main)
                  ),
                )),
            SizedBox(
              height: safeSize.height * 0.2,
              child: BottomBarWidget(safeSize: safeSize),
            ),
          ],
        ),
      ),
    );
  }
}