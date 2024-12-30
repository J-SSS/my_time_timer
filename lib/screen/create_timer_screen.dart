import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_time_timer/provider/app_config_controller.dart';
import 'package:provider/provider.dart';
import 'package:my_time_timer/screen/select_item_screen.dart';
import 'package:my_time_timer/utils/timer_utils.dart' as utils;

import '../provider/timer_controller.dart';
import '../widgets/battery_type.dart';
import '../widgets/pizza_type.dart';
import '../widgets/timer_loader.dart';

class CreateTimerScreen extends StatelessWidget {
  final Size safeSize;
  CreateTimerScreen(this.safeSize, {super.key});

  @override
  Widget build(BuildContext context) {
    print('빌드');
    print("가로 : ${safeSize.width}, 세로 : ${safeSize.height}");
    // print(safeSize.height * 0.7);
    return Scaffold(
        appBar: AppBar(
          title: Text('내 리스트_1'),
          // toolbarHeight: 56,
          centerTitle: true,
        ),
        body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container( // 임시
                  height: safeSize.height * 0.1,
                  color: Colors.green.withOpacity(0.05),
                ),
                SizedBox(
                    height: safeSize.height * 0.7,
                    child: Center(
                        child: TimerLoader().timerLoader(context, "pizza")
                      // child: TimerLoader().timerLoader(context, "battery")
                    )),
                Container(
                    color: Colors.blue.withOpacity(0.05),// 임시
                    width: safeSize.width,
                    height: safeSize.height * 0.2,
                    child: Column(
                      children: [
                        Container(
                          width: safeSize.width * 0.85,
                          height: safeSize.height * 0.1,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(50.0),
                            border: Border.all(
                                color: Colors.grey.withOpacity(0.5), width: 0.1),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26.withOpacity(0.1),
                                spreadRadius: 1,
                                blurRadius: 5,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              // _ItemBtnTimeUnit(context), // 시간 단위
                              // _ItemBtnMaxTime(context), // 최대 시간
                              // _ItemBtnRemainTime(context), // 남은 시간 표시
                              // _ItemBtnTimerColor(context), // 색상(3단)
                              // _ItemBtnAlarmType(context), // 무음/진동/알람
                              _ItemBtn(context,"timeUnit"), // 시간 단위
                              _ItemBtn(context,"maxTime"), // 최대 시간
                              _ItemBtn(context,"remainTime"), // 남은 시간 표시
                              _ItemBtn(context,"timerColor"), // 색상(3단)
                              _ItemBtn(context,"alarmType"), // 무음/진동/알람
                            ],
                          ),
                        ),
                        SizedBox(
                          // height: safeSize.height * 0.02,
                        ),
                        Container(
                          width: safeSize.width * 0.3,
                          height: safeSize.height * 0.08,
                          color: Colors.transparent, // Container의 배경색
                          child: ElevatedButton(
                            onPressed: () {
                              // 버튼이 클릭되었을 때의 동작 추가
                              print('Button clicked!');
                            },
                            style: ElevatedButton.styleFrom( // 버튼 색상 지웠음 확인해보기
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(10.0), // 모서리를 둥글게 만듭니다.
                              ),
                            ),
                            child: Text(
                              'SAVE',
                              style: TextStyle(
                                color: Colors.grey, // 텍스트 색상
                                fontSize: 20.0,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )),
              ],
            )));
  }

  Widget _ItemBtn(BuildContext context, String btnType) {
    // timeUnit 시간 단위
    // maxTime 최대 시간
    // remainTime 남은 시간 표시
    // timerColor 색상(3단)
    // alarmType 무음/진동/알람

    String type = btnType;
    int idx = context.select((AppConfigController a) => a.timeUnit);

    return Material(
      color: Colors.grey.withOpacity(0.2),
      shape: CircleBorder(), // 동그랗게 그림자를 만듭니다.
      child: InkWell(
        borderRadius: BorderRadius.circular(50),
        onTap: () {
          switch (type){
            case "timeUnit" : { // timeUnit 시간 단위
              idx = (idx + 1) % 3;
              context.read<AppConfigController>().setTimeUnit = idx;
            }
            case "maxTime" : { // maxTime 최대 시간

            }
            case "remainTime" : { // remainTime 남은 시간 표시

            }
            case "timerColor" : { // timerColor 색상(3단)

            }
            case "alarmType" : { // alarmType 무음/진동/알람

            }
            default : CustomDialog.show(context);
          }
        },
        child: Container(
          width: safeSize.height * 0.125 * 0.5, // 가로 크기 (높이의 반)
          height: safeSize.height * 0.125 * 0.5, // 세로 크기
          alignment: Alignment.center, // 텍스트를 중앙에 배치
          child: _itemBtnIcon(context, type)
        ),
      ),
    );
  }

  Widget _itemBtnIcon(BuildContext context, String btnType) {
    switch (btnType){
      case "timeUnit" : {
        return Text(
          TimeUnit.values[context.select((AppConfigController a) => a.timeUnit)].name,
          style: TextStyle(
            color: Colors.grey, // 텍스트 색상
            fontSize: 16, // 텍스트 크기
            fontWeight: FontWeight.bold, // 텍스트 두께
          ),
        );
      }
      case "maxTime" : { // maxTime 최대 시간
        return Text(
          "120",
          style: TextStyle(
            color: Colors.grey, // 텍스트 색상
            fontSize: 16, // 텍스트 크기
            fontWeight: FontWeight.bold, // 텍스트 두께
          ),
        );
      }
      case "remainTime" : { // remainTime 남은 시간 표시
        return Icon(
          Icons.textsms_outlined,
          color: Colors.grey.withOpacity(0.5),
          size: safeSize.height * 0.125 * 0.5,
        );
      }
      case "timerColor" : { // timerColor 색상(3단)
        return Icon(
          Icons.color_lens,
          color: Colors.grey.withOpacity(0.5),
          size: safeSize.height * 0.125 * 0.5,
        );
      }
      case "alarmType" : { // alarmType 무음/진동/알람
        return Icon(
          Icons.alarm,
          color: Colors.grey.withOpacity(0.5),
          size: safeSize.height * 0.125 * 0.5,
        );
      }
      default : {
        return Icon(
          Icons.add_circle_rounded,
          color: Colors.grey.withOpacity(0.5),
          size: safeSize.height * 0.125 * 0.5,
        );
      }
    }
  }

}

