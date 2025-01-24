import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_time_timer/provider/create_timer_controller.dart';
import 'package:my_time_timer/utils/size_util.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:provider/provider.dart';
import '../../provider/app_config_controller.dart';
import '../../utils/app_utils.dart';
import '../../utils/common_values.dart';


class SelectTypeDialog {

    void show(BuildContext context) {
    Size safeSize = SizeUtil.get.safeSize;
    double dialogInnerPadding = safeSize.width * 0.8 * 0.05;
    double dialogSafeWidth = safeSize.width * 0.8 - safeSize.width * 0.8 * 0.1;
    double dialogHeight40 = safeSize.height * 0.7 * 0.4;
    double dialogHeight60 = safeSize.height * 0.7 * 0.6;
    double dialogHeight80 = safeSize.height * 0.7 * 0.8;
    double dialogSafeHeight = dialogHeight80 - safeSize.width * 0.8 * 0.1;
    double dialogSafeHeight80 = dialogHeight80 - safeSize.width * 0.8 * 0.1;
    double dialogSafeHeight60 = dialogHeight60 - safeSize.width * 0.8 * 0.1;
    double dialogSafeHeight40 = dialogHeight40 - safeSize.width * 0.8 * 0.1;

    showDialog( // 여기서부터 리빌드됨
      context: context,
      barrierDismissible: true, // 배경 터치로 닫기 여부
      builder: (BuildContext context) {

        int timeValue = 1;
      // int timeValue  = context.select((CreateTimerController T) => T.maxTime);
        return Dialog(
          insetPadding: const EdgeInsets.all(0), // 기본값 변경 가능
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Container(
            width: safeSize.width * 0.8,
            height: dialogHeight60 - dialogSafeHeight60 * 0.2,
            padding: EdgeInsets.all(dialogInnerPadding),
            child: Column(
              children: [
                SizedBox(
                  height: dialogSafeHeight60 * 0.1,
                  child: Row(
                    children: [
                      const Icon(Icons.timelapse),
                      const SizedBox(width: 8.0),
                      const Text(
                        "타이머 모드",
                        style: TextStyle(
                          color: Colors.blueGrey, // 텍스트 색상
                          fontSize: 18, // 텍스트 크기
                          fontWeight: FontWeight.w700, // 텍스트 두께
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: dialogSafeWidth,
                  height: dialogSafeHeight60 * 0.6,
                  child: const ModeSelector()
                ),
                SizedBox(
                  height: dialogSafeHeight60 * 0.1,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: () {
                        context.read<CreateTimerController>().refreshTimerModelWithColor();
                        Navigator.pop(context); // 다이얼로그 닫기
                      },
                      child: const Text('SAVE'),
                    ),
                  ),
                )
                // 닫기 버튼
              ],
            ),
          ),
          );
      },
    );
  }
}

class ModeSelector extends StatefulWidget {
  const ModeSelector({super.key});

  @override
  State<ModeSelector> createState() => _ModeSelectorState();
}

class _ModeSelectorState extends State<ModeSelector> {
  TimeOfDay? _selectedTime;
  String? _selectedTimeString;
  int _selectedSection = 0; // 타이머모드 (0 : 최대 시간, 1 : 목표 시각)
  int _maxTime = 60; // 최대 시간
  int _timeUnit = 0; // 시간 단위 (0 : 초, 1 : 분)

  // "시간 선택" 버튼을 눌렀을 때 동작
  Future<void> _pickTime() async {
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

  // maxTime을 증가 시킨다
  void increaseMaxTime() {
    if (_maxTime < 720) {
      _maxTime += 60;
    } else {
      _maxTime = 60;
    }
    setState(() {
      _maxTime = _maxTime;
    });
  }

  // maxTime을 감소 시킨다
  void decreaseMaxTime() {
    if (_maxTime > 60) {
      _maxTime -= 60;
    } else {
      _maxTime = 720;
    }
    setState(() {
      _maxTime = _maxTime;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size safeSize = SizeUtil.get.safeSize;

    double dialogInnerPadding = safeSize.width * 0.8 * 0.05;
    // print(dialogInnerPadding);
    double dialogSafeWidth = safeSize.width * 0.8 - safeSize.width * 0.8 * 0.1;
    double dialogHeight60 = safeSize.height * 0.7 * 0.6;
    double dialogHeight40 = safeSize.height * 0.7 * 0.4;
    double dialogHeight80 = safeSize.height * 0.7 * 0.8;
    double dialogSafeHeight = safeSize.height * 0.7 * 0.8 - safeSize.width * 0.8 * 0.1;
    double dialogSafeHeight60 = dialogHeight60 - safeSize.width * 0.8 * 0.1;
    double dialogSafeHeight40 = dialogHeight40 - safeSize.width * 0.8 * 0.1;

    double thisHeight = dialogSafeHeight40 * 0.8;

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
      height: dialogSafeHeight60 * 0.6,
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
              height: thisHeight * 0.45,
              child: Row(
                children: [
                  Expanded(
                      flex: 2,
                      child: Checkbox(value: _selectedSection == 0,
                          onChanged: (e) { // 최대 시간
                            if (_selectedSection != 0) {
                              showOverlayInfo(context, "기본 타이머");
                              setState(() {
                                _selectedSection = 0;
                              });
                            }
                          })
                  ),
                  Expanded(
                    flex: 6,
                    child:
                    SizedBox(
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 2,
                              child: _selectedSection == 0 ? IconButton(
                                onPressed: () {
                                  decreaseMaxTime();
                                },
                                icon: Icon(Icons.arrow_back_ios, size: 20,),
                                color: Colors.blueGrey,
                              ) : const SizedBox(),
                            ),
                            Expanded(
                              flex: 6,
                              child: Text("${_maxTime.toString()} ${TimeUnit
                                  .values[_timeUnit].name}",
                                style: const TextStyle(fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blueGrey),
                                textAlign: TextAlign.center,),
                            ),
                            Expanded(
                              flex: 2,
                              child: _selectedSection == 0 ? IconButton(
                                onPressed: () {
                                  increaseMaxTime();
                                },
                                icon: Icon(Icons.arrow_forward_ios, size: 20,),
                                color: Colors.blueGrey,
                              ) : const SizedBox(),),
                          ]
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: _selectedSection == 0 ?
                    IconButton(onPressed: () {
                      setState(() {
                        _timeUnit == 0 ? _timeUnit = 1 : _timeUnit = 0;
                      });
                    },
                      icon: const Icon(Icons.cached),
                      color: Colors.blueGrey,
                    ) : const SizedBox(),
                  ),
                ],
              )
          ),

          Container(
              decoration: BoxDecoration(
                color: _selectedSection == 1 ? Colors.white : Colors.blueGrey
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
              height: thisHeight * 0.45,
              child: Row(
                children: [
                  Expanded(
                      flex: 2,
                      child: Checkbox(
                          value: _selectedSection == 1, onChanged: (e) {
                        if (_selectedSection != 1) {
                          showOverlayInfo(context, "목표 시각 타이머");
                          setState(() {
                            _selectedSection = 1;
                          });
                        }
                      }) // 목표 시각
                  ),
                  Expanded(
                      flex: 6,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _selectedTimeString!,
                            style: const TextStyle(fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.blueGrey),
                          ),
                        ],)
                  ),
                  Expanded(
                    flex: 2,
                    child: _selectedSection == 1 ?
                    IconButton(onPressed: _pickTime,
                      icon: const Icon(Icons.settings),
                      color: Colors.blueGrey,
                    ) : const SizedBox(), // 목표 시각
                  ),
                ],
              )
          ),

        ],
      ),
    );
  }
}