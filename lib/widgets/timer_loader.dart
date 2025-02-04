
import 'package:flutter/material.dart';
import 'package:my_time_timer/manager/app_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:my_time_timer/widgets/timer/pizza_type.dart';
import 'package:my_time_timer/widgets/timer/pizza_type_b.dart';
import 'package:provider/provider.dart';

import '../provider/app_config_controller.dart';
import '../provider/timer_controller.dart';
import '../utils/app_utils.dart';
import '../utils/common_values.dart';
import '../utils/size_util.dart';
import '../viewModels/timer_view_model.dart';
import 'timer/battery_type.dart';
import 'package:my_time_timer/utils/timer_utils.dart' as utils;

class TimerLoader {

  /// 타이머 생성 및 수정 화면에서 사용
  Widget timerLoaderWithGesture(BuildContext context, String theme, TimerScreenType screenType){
    Size safeSize = SizeUtil().safeSize; // 미디어 사이즈 초기화
    int? beforeTime;

    // child:  Padding(
    //   padding: EdgeInsets.fromLTRB(mainLRPadding, 0, mainLRPadding, 0), // 좌우 7.5%씩 합 15%
    //   child: Center(
    //       child: TimerLoader().timerLoaderWithGesture(context, timerModel.theme, TimerScreenType.create)
    //   ),
    if(theme == "pizza"){
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
          PizzaTypeBase(),
          PizzaType(screenType: screenType,),
        ]),
      );
    } else if(theme == "pizzaB"){
      return GestureDetector(
        onPanUpdate: (point) {
          Offset clickPoint = point.localPosition;
          int clickToTime = utils.clickToTimePizza(clickPoint, safeSize, 60);
          if(beforeTime == null || (beforeTime != null && beforeTime != clickToTime)){
            // showOverlayText(context,safeSize,clickToTime.toString());
            context.read<TimerController>().setSetupTime = clickToTime;
            beforeTime = clickToTime;
          }
        },
        child: Stack(children: [
          PizzaTypeBaseB(),
          PizzaTypeB(screenType: screenType,),
        ]),
      );
    } else if(theme == "battery"){
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
          PizzaTypeBase(),
          PizzaType(screenType: screenType,),
        ]),
      );
    }
  }


  /// 타이머 생성 및 수정 화면에서 사용
  Widget timerLoader(BuildContext context, String theme, TimerScreenType screenType){
    Size safeSize = SizeUtil().safeSize; // 미디어 사이즈 초기화
    int? beforeTime;
    if(theme == "pizza"){
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
        // child: FutureBuilder(
        //       // future: TimerViewModel().loadPresetDb3(),
        //       future: TimerViewModel.loadPresetDb2(),
        //       // future: context.read<TimerViewModel>().loadRecentFromPrefs(),
        //       builder: (context, snapshot) {
        //         if (snapshot.connectionState == ConnectionState.waiting) {
        //           return CircularProgressIndicator();
        //         } else {
        //           final data = snapshot.data;
        //         return Stack(children: [
        //                 PizzaTypeBase(safeSize: safeSize),
        //                 PizzaType(safeSize: safeSize, screenType: screenType,),
        //               ]);
        //         }
        //       }),
        child: Stack(children: [
          PizzaTypeBase(),
          PizzaType(screenType: screenType,),
        ]),
      );
    } else if(theme == "pizzaB"){
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
          PizzaTypeBaseB(),
          PizzaTypeB(screenType: screenType,),
        ]),
      );
    } else if(theme == "battery"){
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
          PizzaTypeBase(),
          PizzaType(screenType: screenType,),
        ]),
      );
    }
  }

  /// 타이머 실행 중 사용
  Widget onTimer(BuildContext context, String theme){
    Size safeSize = SizeUtil().safeSize; // 미디어 사이즈 초기화
    // Size safeSize = MediaQuery.of(context).size; // 미디어 사이즈
    // Size inf = Size(double.infinity, double.infinity);
    // print(inf);
    if(theme == "pizza"){
      return Stack(children: [
        PizzaTypeBase(),
        PizzaType(screenType: TimerScreenType.timer),
      ]);
    } else if(theme == "battery"){
      return Stack(children: [
        BatteryTypeBase(safeSize: safeSize),
        BatteryType(safeSize: safeSize)
        // BatteryTypeBase(safeSize: inf),
        // BatteryType(safeSize: inf)
      ]);
    } else {
      return Stack(children: [
        PizzaTypeBase(),
        PizzaType(screenType: TimerScreenType.timer),
      ]);
    }
  }

  /// 테마 선택 화면용
  Widget sampleTimerLoader(BuildContext context, String theme, Size cardSize){
    if(theme == "pizza"){
      return Stack(children: [
        PizzaTypeBase(),
        PizzaType(screenType: TimerScreenType.theme),
      ]);
    } else if(theme == "battery"){
      return Stack(children: [
        BatteryTypeBase(safeSize: cardSize),
        BatteryType(safeSize: cardSize, screenType:TimerScreenType.theme)
      ]);
    } else if(theme == "pizzaB"){
      return Stack(children: [
        PizzaTypeBaseB(),
        PizzaTypeB(screenType: TimerScreenType.theme,),
      ]);
    } else {
      return Stack(children: [
        PizzaTypeBase(),
        PizzaType(screenType:TimerScreenType.theme),
      ]);
    }
  }
}