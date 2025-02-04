import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons_null_safety/flutter_icons_null_safety.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../models/timer_model.dart';
import '../../provider/create_timer_controller.dart';
import '../../utils/app_utils.dart';
import '../../utils/common_values.dart';
import '../../utils/size_util.dart';
import '../dialog/select_color_dialog.dart';
import '../dialog/select_time_config_dialog.dart';


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

    return  Container(
      // color: Colors.blue.withOpacity(0.15),// 임시
      width: SizeUtil().sw,
      height: SizeUtil().sh * 0.1,
      alignment: Alignment.center,
      child: Container(
          width: SizeUtil().sw,
          height: SizeUtil().sh10 * 0.9,
          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
          decoration: BoxDecoration(
            color: Colors.white,
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
              TextButton( /** 타이머 모드 변경 */
                  onPressed: () {
                    idxForTimerMode = (idxForTimerMode + 1) % 2;

                    context.read<CreateTimerController>().refreshTimerModel(timerModel.copyWith(timerMode: idxForTimerMode));
                    showOverlayInfo(context,"타이머 모드 변경");

                    if(idxForTimerMode == 0){

                    } else {

                    }
                  },
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(0.0),
                    // fixedSize: Size(55.0, 55.0),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(MaterialCommunityIcons.cached,size: 35,),//format_paint
                      Text("Mode",style: TextStyle(color: Colors.deepPurple,fontSize: 12),)
                    ]
                    ,)
              ),

              TextButton( /** 알람 버튼 */
                  onPressed: () {
                    if(idxForTimerMode == 0){ // 기본형
                      SelectTimeConfigDialog().show(context);
                    } else { // 시각형
                      _showTimePicker();
                    }

                    // // "가득 찬 상태로 타이머 시작" 옵션이 활성화 되어있는 경우, 최대 설정 시간과 관계 없이 가득 찬 상태로 타이머가 시작됩니다.
                  },
                  style: ElevatedButton.styleFrom(
                    // shape: const CircleBorder(),
                    // padding: EdgeInsets.all(10.0),
                    // fixedSize: Size(55.0, 55.0),
                      shadowColor: Colors.grey.withOpacity(0.1),
                      backgroundColor: Colors.white,
                      side: BorderSide(
                          color: Colors.blueGrey.withOpacity(0.2), // 테두리 색상
                          width: 1, // 테두리 두께
                        ),
                    elevation: 1,
                    // fixedSize : Size.fromHeight(50) // todo 수정하기
                  ),
                  child: Align(child: Text(_selectedTimeText,style: TextStyle(fontSize: SizeUtil().sh10/2.5, fontWeight: FontWeight.bold, color: Colors.blueGrey), textAlign: TextAlign.center),),
              ),
              // ElevatedButton(onPressed: (){}, child: SizedBox()),

              TextButton( /** 남은 시간 표시 여부 */
                  onPressed: () {
                    idxForRemainTimeStyle = (idxForRemainTimeStyle + 1) % 3;
                    context.read<CreateTimerController>().refreshTimerModel(timerModel.copyWith(remainTimeStyle: idxForRemainTimeStyle));

                    showOverlayInfo(context,"남은 시간 표시");
                  },
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(0.0),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(MaterialCommunityIcons.eye_off,size: 35,),
                      Text("None",style: TextStyle(color: Colors.deepPurple,fontSize: 12),)
                    ]
                    ,)
              ),





            ],
          )
      ),

    );
  }
}