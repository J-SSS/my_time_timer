

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
    if(type == "pizza"){
      return GestureDetector(
        onPanUpdate: (point) {
          utils.showOverlayText(context);
          Offset clickPoint = point.localPosition;
          int clickToMin = utils.angleToMin(clickPoint, Size(350, 350));
          context.read<TimerController>().setSetupTime = clickToMin;
        },
        child: Stack(children: [
          PizzaTypeBase(size: Size(350, 350)),
          PizzaType(
            size: Size(350, 350),
            isOnTimer: false,
            setupTime: context.read<TimerController>().setupTime,
          ),
        ]),
      );
    } else if(type == "battery"){
      return GestureDetector(
        onPanUpdate: (point) {
          utils.showOverlayText(context);
          Offset clickPoint = point.localPosition;
          int clickToMin = utils.clickToMin2(clickPoint, safeSize);
          context.read<TimerController>().setSetupTime = clickToMin;
        },
        child: Stack(children: [
          BatteryTypeBase(
              size: Size(safeSize.width, safeSize.height)),
          BatteryType(
              size: Size(safeSize.width, safeSize.height),
              isOnTimer: false,
              setupTime:
              context.read<TimerController>().setupTime),
        ]),
      );
    } else {
      return GestureDetector(
        onPanUpdate: (point) {
          utils.showOverlayText(context);
          Offset clickPoint = point.localPosition;
          int clickToMin = utils.angleToMin(clickPoint, Size(350, 350));
          context.read<TimerController>().setSetupTime = clickToMin;
        },
        child: Stack(children: [
          PizzaTypeBase(size: Size(350, 350)),
          PizzaType(
            size: Size(350, 350),
            isOnTimer: false,
            setupTime: context.read<TimerController>().setupTime,
          ),
        ]),
      );
    }
  }
}