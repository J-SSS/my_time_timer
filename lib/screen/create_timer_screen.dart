import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_time_timer/provider/app_config_controller.dart';
import 'package:provider/provider.dart';
import 'package:my_time_timer/screen/select_item_screen.dart';

import '../provider/timer_controller.dart';
import '../widgets/pizza_type.dart';

class CreateTimerScreen extends StatelessWidget {
  final Size safeSize;
  CreateTimerScreen(this.safeSize, {super.key});

  @override
  Widget build(BuildContext context) {
    print('빌드');
    print(safeSize.width);
    print(safeSize.height);
    print(safeSize.height * 0.7);
    return Scaffold(
        appBar: AppBar(
          title: Text('타이틀을 입력 하세요.'),
          // toolbarHeight: 56,
          centerTitle: true,
        ),
        body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                    height: safeSize.height * 0.7,
                    child: Center(
                      child: Stack(
                        children: [
                          PizzaTypeBase(
                            size: Size(350, 350),
                          ),
                          PizzaType(
                              size: Size(350, 350),
                              isOnTimer: false,
                              setupTime:
                              context.read<TimerController>().setupTime),
                        ],
                      ),
                    )),
                SizedBox(
                    height: safeSize.height * 0.3,
                    child: Column(
                      children: [
                        Container(
                          width: safeSize.width * 0.85,
                          height: safeSize.height * 0.125,
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
                              _ItemBtn(context,"A"), // 시간 단위
                              _ItemBtn(context,"B"), // 최대 시간
                              _ItemBtn(context,"C"), // 남은 시간 표시
                              _ItemBtn(context,"D"), // 색상(3단)
                              _ItemBtn(context,"E"), // 무음/진동/알람
                            ],
                          ),
                        ),
                        SizedBox(
                          height: safeSize.height * 0.02,
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
                              'O K',
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

  Widget _ItemBtn(BuildContext context, String type) {
    // A 시간 단위
    // B 최대 시간
    // C 남은 시간 표시
    // D 색상(3단)
    // E 무음/진동/알람
    String btnType = type;

    return Material(
      color: Colors.grey.withOpacity(0.2),
      shape: CircleBorder(), // 동그랗게 그림자를 만듭니다.
      child: InkWell(
        borderRadius: BorderRadius.circular(40),
        onTap: () {
          CustomDialog.show(context);
        },
        child: Icon(
          Icons.add_circle_rounded,
          color: Colors.grey.withOpacity(0.5),
          size: safeSize.height * 0.125 * 0.55,
        ),
      ),
    );
  }
  Widget _ItemBtnTimeUnit(BuildContext context) {
    int idx = context.select((AppConfigController a) => a.timeUnit);
    return Material(
      color: Colors.grey.withOpacity(0.2),
      shape: CircleBorder(),
      child: InkWell(
        borderRadius: BorderRadius.circular(40),
        onTap: () {
          idx = (idx + 1) % 3;
          context.read<AppConfigController>().setTimeUnit = idx;
          // print(TimeUnit.values[idx].name);
          // context.select((AppConfigController a) => a.timeUnit)
        },
        child: Container(
          width: 40, // 가로 크기
          height: 40, // 세로 크기
          alignment: Alignment.center, // 텍스트를 중앙에 배치
          child: Text(
            TimeUnit.values[context.select((AppConfigController a) => a.timeUnit)].name,
            style: TextStyle(
              color: Colors.grey, // 텍스트 색상
              fontSize: 13, // 텍스트 크기
              fontWeight: FontWeight.bold, // 텍스트 두께
            ),
          ),
        ),
      ),
    );
  }
}

