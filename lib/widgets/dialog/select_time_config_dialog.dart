import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_time_timer/models/timer_model.dart';
import 'package:my_time_timer/provider/create_timer_controller.dart';
import 'package:my_time_timer/utils/size_util.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:provider/provider.dart';
import '../../provider/app_config_controller.dart';
import '../../utils/app_utils.dart';
import '../../utils/common_values.dart';


class SelectTimeConfigDialog {

    void show(BuildContext context) {
    Size safeSize = SizeUtil.get.safeSize;
    double dialogInnerPadding = safeSize.width * 0.8 * 0.05;
    double dialogSafeWidth = safeSize.width * 0.8 - safeSize.width * 0.8 * 0.1;
    // double dialogHeight40 = safeSize.height * 0.7 * 0.4;
    // double dialogHeight60 = safeSize.height * 0.7 * 0.6;
    // double dialogHeight80 = safeSize.height * 0.7 * 0.8;
    // double dialogSafeHeight = dialogHeight80 - safeSize.width * 0.8 * 0.1;
    // double dialogSafeHeight80 = dialogHeight80 - safeSize.width * 0.8 * 0.1;
    // double dialogSafeHeight60 = dialogHeight60 - safeSize.width * 0.8 * 0.1;

    double dialogHeight40 = safeSize.height * 0.7 * 0.4;
    double dialogSafeHeight40 = dialogHeight40 - safeSize.width * 0.8 * 0.1;

    showDialog( // 여기서부터 리빌드됨
      context: context,
      barrierDismissible: true, // 배경 터치로 닫기 여부
      builder: (BuildContext context) {

        return Dialog(
          insetPadding: const EdgeInsets.all(0), // 기본값 변경 가능
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Container(
            width: safeSize.width * 0.8,
            height: dialogHeight40,
            padding: EdgeInsets.all(dialogInnerPadding),
            child: Column(
              children: [
                SizedBox(
                  width: dialogSafeWidth,
                  height: dialogSafeHeight40,
                  child: const TimerConfigSelector()
                ),
              ],
            ),
          ),
          );
      },
    );
  }
}

class TimerConfigSelector extends StatefulWidget {
  const TimerConfigSelector({super.key});

  @override
  State<TimerConfigSelector> createState() => _TimerConfigSelectorState();
}

class _TimerConfigSelectorState extends State<TimerConfigSelector> {
  TimeOfDay? _selectedTime;
  late String _selectedTimeString;
  int _selectedSection = 0; // 타이머모드 (0 : 최대 시간, 1 : 목표 시각) todo 이거 지워야함
  late int _maxTime; // 최대 시간
  late int _timeUnit; // 시간 단위 (0 : 초, 1 : 분)

  // maxTime을 증가 시킨다
  void increaseMaxTime(TimerModel timerModel) {
    if (_maxTime < 720) {
      _maxTime += 60;
    } else {
      _maxTime = 60;
    }
    context.read<CreateTimerController>().refreshTimerModel(timerModel.copyWith(maxTime: _maxTime));
    setState(() {
      _maxTime = _maxTime;
    });
  }

  // maxTime을 감소 시킨다
  void decreaseMaxTime(TimerModel timerModel) {
    if (_maxTime > 60) {
      _maxTime -= 60;
    } else {
      _maxTime = 720;
    }
    context.read<CreateTimerController>().refreshTimerModel(timerModel.copyWith(maxTime: _maxTime));
    setState(() {
      _maxTime = _maxTime;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size safeSize = SizeUtil.get.safeSize;

    TimerModel timerModel = context.select((CreateTimerController T) => T.timerModel);



    // _selectedSection = timerModel.timerMode; // 타이머모드 todo 이거 지워야함
    _maxTime = timerModel.maxTime; // 최대 시간
    _timeUnit = timerModel.timeUnit; // 타이머 단위

        double dialogInnerPadding = safeSize.width * 0.8 * 0.05;
    // print(dialogInnerPadding);
    double dialogSafeWidth = safeSize.width * 0.8 - safeSize.width * 0.8 * 0.1;
    double dialogHeight40 = safeSize.height * 0.7 * 0.4;
    double dialogSafeHeight40 = dialogHeight40 - safeSize.width * 0.8 * 0.1;


    // TimeOfDay를 DateTime으로 변환
    final now = DateTime.now(); // 현재 시각(UTC가 아닌, 기기의 로컬 시간)
    DateTime dateTime;
    if (_selectedTime != null) {
      dateTime = DateTime(
        now.year,
        now.month,
        now.day,
        _selectedTime!.hour,
        _selectedTime!.minute,
      );
    } else {
      dateTime = DateTime.now();
    }
    _selectedTimeString = DateFormat('hh:mm a').format(dateTime);

    return SizedBox(
      width: dialogSafeWidth,
      height: dialogSafeHeight40,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
              decoration: BoxDecoration(
                color: _selectedSection == 0 ? Colors.white : Colors.blueGrey
                    .withOpacity(0.2),
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                    color: Colors.blueGrey.withOpacity(0.5), width: 0.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blueGrey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              padding: EdgeInsets.all(dialogInnerPadding / 2),
              height: dialogSafeHeight40 * 0.4,
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: IconButton(
                      onPressed: () {
                        decreaseMaxTime(timerModel);
                      },
                      icon: Icon(Icons.arrow_back_ios, size: 20,),
                      color: Colors.blueGrey,
                    ),
                  ),
                  Expanded(
                    flex: 6,
                    child:FittedBox( // todo AutoSizeText로 바꾸기
                      fit: BoxFit.contain, // 텍스트 크기를 박스 크기에 맞게 조정
                      child: Text("${_maxTime.toString()} ${TimeUnit
                          .values[_timeUnit].name}",
                        style: const TextStyle(fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueGrey),
                        textAlign: TextAlign.center,)
                    )
                  ),
                  Expanded(
                    flex: 2,
                    child: IconButton(
                      onPressed: () {
                        increaseMaxTime(timerModel);
                      },
                      icon: Icon(Icons.arrow_forward_ios, size: 20,),
                      color: Colors.blueGrey,
                    )
                  ),
                ],
              )
          ),

          SizedBox(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  width: dialogSafeWidth * 0.30,
                  height: dialogSafeHeight40 * 0.25,
                  decoration: BoxDecoration(
                    color: _selectedSection == 0 ? Colors.white : Colors.blueGrey
                        .withOpacity(0.2),
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(
                        color: Colors.blueGrey.withOpacity(0.5), width: 0.5),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blueGrey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: TextButton(onPressed: (){
                    context.read<CreateTimerController>().refreshTimerModel(timerModel.copyWith(timeUnit: 0));
                    setState(() {
                      _timeUnit = 0;
                    });
                  }, child: FittedBox( // todo AutoSizeText로 바꾸기
                      fit: BoxFit.contain, // 텍스트 크기를 박스 크기에 맞게 조정
                      child: Text(TimeUnit.values[0].name,style: TextStyle(fontSize: 35,fontWeight: FontWeight.bold))
                  ),
                  ),
                ),

                Container(
                  width: dialogSafeWidth * 0.30,
                  height: dialogSafeHeight40 * 0.25,
                  decoration: BoxDecoration(
                    color: _selectedSection == 0 ? Colors.white : Colors.blueGrey
                        .withOpacity(0.2),
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(
                        color: Colors.blueGrey.withOpacity(0.5), width: 0.5),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blueGrey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: TextButton(onPressed: (){
                    context.read<CreateTimerController>().refreshTimerModel(timerModel.copyWith(timeUnit: 1));
                    setState(() {
                      _timeUnit = 1;
                    });
                  }, child: FittedBox( // todo AutoSizeText로 바꾸기
                      fit: BoxFit.contain, // 텍스트 크기를 박스 크기에 맞게 조정
                      child: Text(TimeUnit.values[1].name,style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold))
                  ),
                  ),
                ),

                Container(
                  width: dialogSafeWidth * 0.30,
                  height: dialogSafeHeight40 * 0.25,
                  decoration: BoxDecoration(
                    color: _selectedSection == 0 ? Colors.white : Colors.blueGrey
                        .withOpacity(0.2),
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(
                        color: Colors.blueGrey.withOpacity(0.5), width: 0.5),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blueGrey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: TextButton(onPressed: (){
                    context.read<CreateTimerController>().refreshTimerModel(timerModel.copyWith(timeUnit: 2));
                    setState(() {
                      _timeUnit = 2;
                    });
                  }, child: FittedBox( // todo AutoSizeText로 바꾸기
                      fit: BoxFit.contain, // 텍스트 크기를 박스 크기에 맞게 조정
                      child: Text(TimeUnit.values[2].name,style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold))
                  ),
                  )
                ),

            ],
            ),
          )

        ],
      ),
    );
  }
}