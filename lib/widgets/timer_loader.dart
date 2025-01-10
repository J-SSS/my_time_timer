
import 'package:my_time_timer/utils/app_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:my_time_timer/widgets/pizza_type.dart';
import 'package:provider/provider.dart';

import '../provider/app_config_controller.dart';
import '../provider/timer_controller.dart';
import '../utils/app_utils.dart';
import '../utils/common_values.dart';
import 'battery_type.dart';
import 'package:my_time_timer/utils/timer_utils.dart' as utils;

class TimerLoader {

  /// 타이머 생성 및 수정 화면에서 사용
  Widget timerLoader(BuildContext context, String type, TimerScreenType screenType){
    Size safeSize = context.read<AppConfigController>().safeSize; // 미디어 사이즈 초기화
    int? beforeTime;
    if(type == "pizza"){
      return GestureDetector(
        onPanUpdate: (point) {
          Offset clickPoint = point.localPosition;
          int clickToTime = utils.clickToTimePizza(clickPoint, safeSize, 60);
          if(beforeTime == null || (beforeTime != null && beforeTime != clickToTime)){
            showOverlayText(context,safeSize,clickToTime.toString());
            context.read<TimerController>().setSetupTime = clickToTime;
            beforeTime = clickToTime;
          }
        },
        child: Stack(children: [
          PizzaTypeBase(safeSize: safeSize),
          PizzaType(safeSize: safeSize, screenType: screenType,),
        ]),
      );
    } else if(type == "battery"){
      return GestureDetector(
        onPanUpdate: (point) {
          Offset clickPoint = point.localPosition;
          int clickToTime = utils.clickToTimeBattery(clickPoint, safeSize, 60);
          if(beforeTime == null || (beforeTime != null && beforeTime != clickToTime)){
            showOverlayText(context,safeSize,clickToTime.toString());
            context.read<TimerController>().setSetupTime = clickToTime;
            beforeTime = clickToTime;
          }
        },
        child: Stack(children: [
          BatteryTypeBase(safeSize: safeSize),
          BatteryType(safeSize: safeSize,)
        ]),
      );
    } else {
      return GestureDetector(
        onPanUpdate: (point) {
          Offset clickPoint = point.localPosition;
          int clickToTime = utils.clickToTimePizza(clickPoint, safeSize, 60);
          showOverlayText(context,safeSize,clickToTime.toString());
          context.read<TimerController>().setSetupTime = clickToTime;
        },
        child: Stack(children: [
          PizzaTypeBase(safeSize: safeSize),
          PizzaType(safeSize: safeSize, screenType: screenType),
        ]),
      );
    }
  }

  /// 타이머 실행 중 사용
  Widget onTimer(BuildContext context, String type){
    Size safeSize = context.read<AppConfigController>().safeSize; // 미디어 사이즈 초기화
    // Size safeSize = MediaQuery.of(context).size; // 미디어 사이즈 초기화
    if(type == "pizza"){
      return Stack(children: [
        PizzaTypeBase(safeSize: safeSize),
        PizzaType(safeSize: safeSize),
      ]);
    } else if(type == "battery"){
      return Stack(children: [
        BatteryTypeBase(safeSize: safeSize),
        BatteryType(safeSize: safeSize)
      ]);
    } else {
      return Stack(children: [
        PizzaTypeBase(safeSize: safeSize),
        PizzaType(safeSize: safeSize),
      ]);
    }
  }

  /// 테마 선택 화면용
  Widget sampleTimerLoader(BuildContext context, String type, Size cardSize){
    if(type == "pizza"){
      return Stack(children: [
        PizzaTypeBase(safeSize: cardSize),
        PizzaType(safeSize: cardSize, screenType:TimerScreenType.theme),
      ]);
    } else if(type == "battery"){
      return Stack(children: [
        BatteryTypeBase(safeSize: cardSize),
        BatteryType(safeSize: cardSize, screenType:TimerScreenType.theme)
      ]);
    } else {
      return Stack(children: [
        PizzaTypeBase(safeSize: cardSize),
        PizzaType(safeSize: cardSize, screenType:TimerScreenType.theme),
      ]);
    }
  }
}