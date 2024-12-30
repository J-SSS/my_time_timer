

import 'package:flutter/cupertino.dart';
import 'package:my_time_timer/widgets/pizza_type.dart';
import 'package:provider/provider.dart';

import '../provider/app_config_controller.dart';
import '../provider/timer_controller.dart';
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
          int clickToMin = utils.angleToMin(clickPoint, safeSize);
          if(beforeTime == null || (beforeTime != null && beforeTime != clickToMin)){
            utils.showOverlayText(context,safeSize,clickToMin.toString());
            context.read<TimerController>().setSetupTime = clickToMin;
            beforeTime = clickToMin;
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
          int clickToMin = utils.angleToMin(clickPoint, safeSize);
          if(beforeTime == null || (beforeTime != null && beforeTime != clickToMin)){
            utils.showOverlayText(context,safeSize,clickToMin.toString());
            context.read<TimerController>().setSetupTime = clickToMin;
            beforeTime = clickToMin;
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
          int clickToMin = utils.angleToMin(clickPoint, Size(350, 350));
          utils.showOverlayText(context,safeSize,clickToMin.toString());
          context.read<TimerController>().setSetupTime = clickToMin;
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