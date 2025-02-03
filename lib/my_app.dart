import 'package:flutter/material.dart';
import 'package:flutter_icons_null_safety/flutter_icons_null_safety.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_time_timer/main.dart';
import 'package:my_time_timer/provider/create_timer_controller.dart';
import 'dart:developer';

import 'package:my_time_timer/provider/timer_controller.dart';
import 'package:my_time_timer/provider/app_config_controller.dart';

import 'package:my_time_timer/manager/app_manager.dart';
import 'package:my_time_timer/screen/setting_screen.dart';
import 'package:my_time_timer/utils/common_values.dart';
import 'package:my_time_timer/manager/db_manager.dart';

import 'package:my_time_timer/temp/isolate_timer.dart';
import 'package:my_time_timer/utils/size_util.dart';
import 'package:my_time_timer/viewModels/timer_view_model.dart';
import 'package:my_time_timer/repository/timer_repository.dart';
import 'package:my_time_timer/widgets/create_timer_toolbar.dart';
import 'package:my_time_timer/widgets/main_toolbar.dart';
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

    // todo 프로바이더는 리빌드 안됨 > 초기화 메서드들 옮기기

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
            fontFamily: 'Pretendard',
            dividerColor: Colors.transparent,
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

    // AppManager.log("SQLite 프리셋 초기화",type: "S");
    context.read<TimerViewModel>().loadPresetFromDb();

    // SharedPreferences에서 최근 사용 타이머 셋팅
    context.read<TimerController>().setCurrentTimer = TimerViewModel().loadRecentFromPrefs();

    /**
     * 현재 프레임이 끝난 후, 위젯 트리가 완전히 렌더링된 뒤 실행
     * UI와 충돌하는 것 방지(ex.이전 스크롤 위치로 이동..)
     */
    WidgetsBinding.instance.addPostFrameCallback((_) {}); // print('초기화');

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
      // appBar: MyAppBar(safeSize: safeSize),
      // appBar: AppBar(
      //   leading: const SizedBox(),
      //   title: ConstrainedBox(
      //     constraints: BoxConstraints(maxWidth: 200), // 최대 너비 제한
      //     child: FittedBox( // todo AutoSizeText로 바꾸기
      //         fit: BoxFit.contain, // 텍스트 크기를 박스 크기에 맞게 조정
      //         child: Text("New Timer",
      //             maxLines: 1, // 최대 한 줄로 제한
      //             overflow: TextOverflow.ellipsis, // 넘치는 텍스트를 생략(...)
      //             style: TextStyle(
      //               fontSize: 25,
      //               fontWeight: FontWeight.bold,
      //               color: Colors.black54,
      //               shadows: [
      //                 Shadow(
      //                   offset: Offset(0, 3), // 그림자의 x, y 위치
      //                   blurRadius: 1.0, // 그림자 흐림 정도
      //                   color: Colors.grey.withOpacity(0.2), // 그림자 색상
      //                 ),
      //               ],))),
      //   ),
      //
      //   // toolbarHeight: 56,
      //   centerTitle: true,
      //   actions: [
      //     IconButton(
      //       onPressed: () {
      //         Navigator.push(
      //           context,
      //           MaterialPageRoute(builder: (context) => SettingScreen()), // 설정 화면
      //         );
      //       },
      //       // icon: Icon(Icons.settings),
      //       icon: Icon(MaterialCommunityIcons.settings,size: 19,),
      //       color: Colors.grey,
      //     ),
      //   ],
      // ),
      body: SafeArea(
          child: Column(

            children: [
              Container( // 임시
                  height: SizeUtil.get.sh075,
                  // color: Colors.green.withOpacity(0.15),
                  alignment: Alignment.center,
                  child: const MainToolbar()
              ),
              Container( // 임시
                  height: SizeUtil.get.sh075,
                  width: SizeUtil.get.sw,
                  // color: Colors.blue.withOpacity(0.1),
                  // alignment: Alignment.bottomCenter,
                  alignment: Alignment.center,
                  child:  Text("WorkOut 60 min!" * 1, // todo AutoSizeText로 바꾸기
                      maxLines: 1, // 최대 한 줄로 제한
                      overflow: TextOverflow.ellipsis, // 넘치는 텍스트를 생략(...)
                      style: TextStyle(
                        fontSize: SizeUtil.get.sh075 / 2,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
                        shadows: [
                          Shadow(
                            offset: Offset(0, 3), // 그림자의 x, y 위치
                            blurRadius: 1.0, // 그림자 흐림 정도
                            color: Colors.grey.withOpacity(0.2), // 그림자 색상
                          ),
                        ],
                      )
                  )
              ),

              Container(
                // color: Colors.blue.withOpacity(0.05),
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
                height: SizeUtil.get.sh15,
                child: BottomBarWidget(safeSize: safeSize),
              ),
            ],
          ),
      )



    );
  }
}