import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/timer_model.dart';
import '../provider/create_timer_controller.dart';
import '../utils/app_utils.dart';
import '../utils/common_values.dart';
import '../utils/size_util.dart';
import 'dialog/select_time_config_dialog.dart';


class CreateTimerToolbar extends StatefulWidget {
  const CreateTimerToolbar({Key? key}) : super(key: key);

  @override
  State<CreateTimerToolbar> createState() => _CreateTimerToolbarState();
}

class _CreateTimerToolbarState extends State<CreateTimerToolbar> {

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
    int idxForRemainTimeStyle = timerModel.remainTimeStyle;

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

    return Row(children: [
      Container(
        // color: Colors.red.withOpacity(0.1),
        width: SizeUtil.get.sw * 0.2,
        child: IconButton(
          onPressed: () {
            idxForTimerMode = (idxForTimerMode + 1) % 2;

            context.read<CreateTimerController>().refreshTimerModel(timerModel.copyWith(timerMode: idxForTimerMode));
            showOverlayInfo(context,"타이머 모드 변경");

            if(idxForTimerMode == 0){

            } else {

            }

            // idxForTimeUnit = (idxForTimeUnit + 1) % 3;
            // context.read<CreateTimerController>().refreshTimerModel(timerModel.copyWith(timeUnit: idxForTimeUnit));
          },
          icon: Icon(Icons.cached_rounded,size: 41,),
          color: Colors.grey,
        ),
      ),
      SizedBox(
        width: SizeUtil.get.sw * 0.6,
        child: Container(
          height: SizeUtil.get.sh * 0.1 * 0.7,
          width: SizeUtil.get.sw * 0.6,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.3),
            borderRadius: BorderRadius.circular(50.0),
            border: Border.all(
                color: Colors.blueGrey.withOpacity(0.9), width: 0.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black26.withOpacity(0.05),
                spreadRadius: 1,
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: InkWell(
            onTap: (){
              if(idxForTimerMode == 0){ // 기본형
                SelectTimeConfigDialog().show(context);
              } else { // 시각형
                _showTimePicker();
              }

              // // "가득 찬 상태로 타이머 시작" 옵션이 활성화 되어있는 경우, 최대 설정 시간과 관계 없이 가득 찬 상태로 타이머가 시작됩니다.
            },
            // child: Align(child: Text("120 min Timer",style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black54), textAlign: TextAlign.center),),
            child: Align(child: Text(_selectedTimeText,style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.black54), textAlign: TextAlign.center),),
          ),
        ),
      ),
      Container(
        // color: Colors.blue.withOpacity(0.1),
        width: SizeUtil.get.sw * 0.2,
        child: IconButton(
          onPressed: () {
            idxForRemainTimeStyle = (idxForRemainTimeStyle + 1) % 3;
            context.read<CreateTimerController>().refreshTimerModel(timerModel.copyWith(remainTimeStyle: idxForRemainTimeStyle));

            showOverlayInfo(context,"남은 시간 표시");
          },
          icon: Icon(Icons.visibility_off_outlined,size: 41,),
          // icon: Icon(MaterialCommunityIcons.eye_off, size: 41,),
          color: Colors.grey,
        ),
      ),

    ],);
  }
}