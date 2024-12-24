import 'package:flutter/material.dart';
import 'package:my_time_timer/main.dart';
import 'dart:developer';

import 'package:my_time_timer/provider/timer_controller.dart';
import 'package:my_time_timer/provider/app_config_controller.dart';

import 'package:my_time_timer/utils/isolate_timer.dart';
import 'package:my_time_timer/viewModels/timer_view_model.dart';
import 'package:my_time_timer/repository/timer_repository.dart';
import 'package:my_time_timer/widgets/my_app_bar.dart';

import 'package:provider/provider.dart';

import 'package:my_time_timer/widgets/bottom_bar.dart';
import 'package:my_time_timer/widgets/pizza_type.dart';
import 'package:my_time_timer/widgets/battery_type.dart';

import 'package:my_time_timer/list_drawer.dart';
import 'package:my_time_timer/utils/timer_utils.dart' as utils;
import 'package:shared_preferences/shared_preferences.dart';

class ProviderTest extends StatelessWidget{
  ProviderTest(){
    print('이게되네?');
  }

  @override
  Widget build(BuildContext context) {
    return Container(width: 200, height: 200, color: Colors.red,child: Text('dddddddddddddd'),);
  }
}


class MyApp extends StatelessWidget {
  final SharedPreferences prefs;

  const MyApp({super.key, required this.prefs});

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    // print('크기 : ' + mediaQuery.size.toString()); // size	화면의 크기 (Size 객체로 가로와 세로 길이 포함).
    // print('방향 : ' + mediaQuery.orientation.toString()); // orientation	화면 방향 (Orientation.portrait 또는 Orientation.landscape).
    // print('패딩 : ' + mediaQuery.padding.toString()); // padding	디바이스의 안전 영역 패딩 (예: 노치 영역, 상태바, 하단 패딩 등).
    // print('픽셀 밀도 : ' + mediaQuery.devicePixelRatio.toString()); // devicePixelRatio	픽셀 밀도 (1dp가 몇 픽셀인지).
    // print('텍스트 스케일 : ' + mediaQuery.textScaleFactor.toString());  // textScaleFactor	시스템에서 설정된 텍스트 스케일 값.
    // print('밝기 몯, : ' + mediaQuery.platformBrightness.toString());// platformBrightness	시스템의 현재 밝기 모드 (Brightness.light 또는 Brightness.dark).
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => TimerViewModel(TimerRepository(prefs)), lazy: false,), // shared preference
        ChangeNotifierProvider(create: (context) => TimerController(), lazy: false), // isolate timer
        ChangeNotifierProvider(create: (context) => AppConfigController()),
      ],
      child: MaterialApp(
        title: 'My Time Timer',
          theme: ThemeData(
            // expansionTileTheme: ExpansionTileThemeData(
            //   // tilePadding : EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
            //   // childrenPadding : EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
            //   backgroundColor: Colors.grey[200],
            //   textColor: Colors.blue,
            // ),
          ),
        home:  MyTimeTimer()),
    );
  }
}



class MyTimeTimer extends StatelessWidget {
// GlobalKey 생성
  // final GlobalKey<_PizzaTypeState> pizzaTypeKey = GlobalKey<_PizzaTypeState>();

  late Size mediaSize;

  @override
  Widget build(BuildContext context) {
    AppManager.log('메인 생성', type : 'T');

    context.read<AppConfigController>().setMediaQuery = MediaQuery.of(context); // 미디어 쿼리 자주 호출하면 안됨
    mediaSize = MediaQuery.sizeOf(context); // MediaQuery.of(context);랑 다름

    // print(AppBar().preferredSize.height); // AppBar 높이 확인
    // AppManager.log('앱 사이즈 확인');

    // 초기화
    context.read<TimerViewModel>().loadPreset();
    late Size mainSize = MediaQuery.sizeOf(context);
    /**
     * 현재 프레임이 끝난 후, 위젯 트리가 완전히 렌더링된 뒤 실행
     * UI와 충돌하는 것 방지(ex.이전 스크롤 위치로 이동..)
     */
    WidgetsBinding.instance.addPostFrameCallback((_) {}); // print('초기화');

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: MyAppBar(mainSize: mediaSize),
      drawer: ListDrawer(), // 보조 화면
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
                height: mainSize.height * (6 / 10),
                child: Center(
                  child:
                  // GestureDetector(
                  //   onPanUpdate: (point) {
                  //     utils.showOverlayText(context);
                  //     Offset clickPoint = point.localPosition;
                  //     int clickToMin = utils.angleToMin(clickPoint, Size(350, 350));
                  //     context.read<TimerController>().setSetupTime = clickToMin;
                  //   },
                  //   child: Stack(children: [
                  //     PizzaTypeBase(size: Size(350, 350)),
                  //     PizzaType(
                  //       size: Size(350, 350),
                  //       isOnTimer: false,
                  //       setupTime: context.read<TimerController>().setupTime,
                  //     ),
                  //   ]),
                  // ),
                  GestureDetector(
                    onPanUpdate: (point) {
                      utils.showOverlayText(context);
                      Offset clickPoint = point.localPosition;
                      int clickToMin = utils.clickToMin2(clickPoint, mediaSize);
                      context.read<TimerController>().setSetupTime = clickToMin;
                    },
                    child: Stack(children: [
                      BatteryTypeBase(
                          size: Size(mainSize.width, mainSize.height)),
                      BatteryType(
                          size: Size(mainSize.width, mainSize.height),
                          isOnTimer: false,
                          setupTime:
                          context.read<TimerController>().setupTime),
                    ]),
                  ),
                )),
            SizedBox(
              height: mainSize.height * (2.0 / 10),
              child: ButtomBarWidget(),
            ),
          ],
        ),
      ),
    );
  }
}