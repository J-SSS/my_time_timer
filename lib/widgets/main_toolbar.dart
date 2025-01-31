import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons_null_safety/flutter_icons_null_safety.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/timer_model.dart';
import '../provider/create_timer_controller.dart';
import '../utils/app_utils.dart';
import '../utils/common_values.dart';
import '../utils/size_util.dart';
import 'dialog/select_color_dialog.dart';
import 'dialog/select_time_config_dialog.dart';


class MainToolbar extends StatefulWidget {
  const MainToolbar({Key? key}) : super(key: key);

  @override
  State<MainToolbar> createState() => _MainToolbarState();
}

class _MainToolbarState extends State<MainToolbar> {

  TimeOfDay? _selectedTime;
  String _selectedTimeText = "";

  int _maxTime = 60; // 최대 시간
  int _timeUnit = 0; // 시간 단위 (0 : 초, 1 : 분)

  Future<void> _showTimePicker() async {
    final newTime = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );

    if (newTime != null) {
      setState(() {
        _selectedTime = newTime;
      });
    }
  }


  @override
  Widget build(BuildContext context) {

    TimerModel timerModel = context.select((CreateTimerController T) => T.timerModel);
    int idxForTimeUnit = timerModel.timeUnit;
    int idxForTimerMode = timerModel.timerMode;  /// 타이머 모드 (0 : 타이머형, 1 : 알람형)

    // List<String> timerModeStr = ["타이머 모드","목표 시각 "];

    if(idxForTimerMode == 0){
      _selectedTimeText = "${timerModel.maxTime} ${TimeUnit.values[timerModel.timeUnit].name} Timer";
    } else {
      // TimeOfDay를 DateTime으로 변환
      final now = DateTime.now(); // 현재 시각(UTC가 아닌, 기기의 로컬 시간)
      DateTime newDateTime;
      if (_selectedTime != null) {
        newDateTime = DateTime(
          now.year,
          now.month,
          now.day,
          _selectedTime!.hour,
          _selectedTime!.minute,
        );
      } else {
        newDateTime = DateTime.now();
      }
      _selectedTimeText = "Until ${DateFormat('hh:mm a').format(newDateTime)}"; // HH : 24시간타입
    }

    return Container(
          width: SizeUtil.get.sw * 0.9,
          height: SizeUtil.get.sh075 * 0.8,
          // alignment: Alignment.topCenter,
          decoration: BoxDecoration(
            color: Colors.white,
            // color: Colors.red,
            borderRadius: BorderRadius.circular(50),
            boxShadow: [
              BoxShadow(
                color: Colors.blueGrey.withOpacity(0.3),
                spreadRadius: 3,
                blurRadius: 1,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child : Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton( /** 좌 버튼 */
                  onPressed: () {
                  },
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    // padding: EdgeInsets.all(10.0),
                    // fixedSize: Size(55.0, 55.0),
                  ),
                // child: Icon(MaterialCommunityIcons.chevron_left_circle,size: 35,),
                child: Icon(MaterialCommunityIcons.chevron_left,size: 35,),
              ),

              Align(child: Text(_selectedTimeText,style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.blueGrey), textAlign: TextAlign.center),),

              TextButton( /** 우 버튼 */
                  onPressed: () {
                  },
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    // padding: EdgeInsets.all(10.0),
                    // fixedSize: Size(55.0, 55.0),
                  ),
                  // child: Icon(MaterialCommunityIcons.chevron_right_circle,size: 35,),
                  child: Icon(MaterialCommunityIcons.chevron_right,size: 35,),
              ),





            ],
          )
      );
  }
}