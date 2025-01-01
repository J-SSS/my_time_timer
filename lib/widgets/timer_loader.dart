
import 'package:my_time_timer/utils/app_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:my_time_timer/widgets/pizza_type.dart';
import 'package:provider/provider.dart';

import '../provider/app_config_controller.dart';
import '../provider/timer_controller.dart';
import '../utils/app_utils.dart';
import 'battery_type.dart';
import 'package:my_time_timer/utils/timer_utils.dart' as utils;

class TimerLoader {

  Widget timerLoader(BuildContext context, String type){
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
          PizzaTypeBase(),
          PizzaType(
            isOnTimer: false,
          ),
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
          BatteryTypeBase(),
          BatteryType(isOnTimer: false)
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
          PizzaType(
            isOnTimer: false,
          ),
        ]),
      );
    }
  }
}