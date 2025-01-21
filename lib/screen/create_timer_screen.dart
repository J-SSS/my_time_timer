import 'package:flutter/material.dart';
import 'package:my_time_timer/manager/app_manager.dart';
import 'package:my_time_timer/utils/size_util.dart';
import 'package:my_time_timer/widgets/dialog/number_picker_dialog.dart';
import 'package:provider/provider.dart';
import 'package:my_time_timer/widgets/dialog/select_color_dialog.dart';
import '../provider/create_timer_controller.dart';
import '../provider/timer_controller.dart';
import '../utils/app_utils.dart';
import '../utils/common_values.dart';
import '../widgets/timer_loader.dart';

class CreateTimerScreen extends StatelessWidget {
  CreateTimerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Timer.a;

    double verticalDividerIndent = SizeUtil.get.sh * 0.1 * 0.5 * 0.3;
    AppManager.log("타이머생성",type: "B");
    double mainLRPadding = SizeUtil.get.sw075.roundToDouble(); // 가로 411 기준 약 31
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: TextField(
            decoration: InputDecoration(
              // labelText: '타이머 이름',
              border:  InputBorder.none // 외곽선 스타일
            ),textAlign: TextAlign.left,
          ),
          // toolbarHeight: 56,
          // centerTitle: false,
          actions: [
            IconButton(
              onPressed: () {
                showOverlayInfo(context,"타이틀 숨김");
              },
              icon: Icon(Icons.settings),
              color: Colors.grey,
            ),
          ],
        ),

        body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container( // 임시
                  height: SizeUtil.get.sh * 0.1,
                  width: SizeUtil.get.sw,
                  color: Colors.green.withOpacity(0.15),
                  alignment: Alignment.center,
                  child: Container(
                    height: SizeUtil.get.sh * 0.1 * 0.5,
                    width: SizeUtil.get.sw * 0.50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(50.0),
                      border: Border.all(
                          color: Colors.grey.withOpacity(0.9), width: 0.5),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26.withOpacity(0.05),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _ItemBtn(context,"maxTime"), // 최대 시간
                        VerticalDivider(
                          color: Colors.blueGrey.withOpacity(0.3), // 선 색상
                          thickness: 1.5, // 선 두께
                          width: 1, // Divider 전체 영역의 너비
                          indent: verticalDividerIndent, // 시작 부분 여백
                          endIndent: verticalDividerIndent, // 끝 부분 여백
                        ),
                        _ItemBtn(context,"timeUnit"), // 시간 단위
                        VerticalDivider(
                          color: Colors.blueGrey.withOpacity(0.3), // 선 색상
                          thickness: 1.5, // 선 두께
                          width: 1, // Divider 전체 영역의 너비
                          indent: verticalDividerIndent, // 시작 부분 여백
                          endIndent: verticalDividerIndent, // 끝 부분 여백
                        ),
                        _ItemBtn(context,"remainTimeStyle"), // 시간 표시 여부
                      ],
                    ),
                  ),
                ),
                SizedBox(
                    height: SizeUtil.get.sh * 0.7,
                    child:  Padding(
                      padding: EdgeInsets.fromLTRB(mainLRPadding, 0, mainLRPadding, 0), // 좌우 7.5%씩 합 15%
                      child: Center(
                          child: TimerLoader().timerLoader(context, "pizza", TimerScreenType.create)
                        // child: TimerLoader().timerLoader(context, "battery", "C")
                      ),
                    )),
                Container(
                    // color: Colors.blue.withOpacity(0.15),// 임시
                    width: SizeUtil.get.sw,
                    height: SizeUtil.get.sh * 0.2,
                    child: Stack(
                      children: <Widget>[
                        Positioned( /** 하단 사각 영역 */
                          top: SizeUtil.get.sh * 0.2 * 0.25,
                          left: SizeUtil.get.sw * 0.225,
                          child: Container(
                              width: SizeUtil.get.sw * 0.55,
                              height: SizeUtil.get.sh * 0.2 * 0.45,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(50),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.blueGrey.withOpacity(0.1),
                                    spreadRadius: 1,
                                    blurRadius: 5,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child : Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  TextButton( /** 좌버튼 */
                                    onPressed: () {
                                      SelectColorDialog.show(context);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(50), // 둥근 모서리
                                        // side: BorderSide(
                                        //   color: Colors.blueGrey, // 테두리 색상
                                        //   width: 1, // 테두리 두께
                                        // ),
                                      ),
                                      padding: EdgeInsets.all(0.0),
                                      fixedSize: Size(50.0, 50.0),
                                    ),
                                    child: Image.asset(
                                      'assets/icon/btn_color.png',
                                      // width: 30,
                                      // height: 30,
                                    ),
                                  ),
                                  TextButton( /** 우버튼 */
                                    onPressed: () {
                                      showOverlayInfo(context,"초기화");
                                    },
                                    style: ElevatedButton.styleFrom(
                                      shape: const CircleBorder(),
                                      padding: EdgeInsets.all(10.0),
                                      fixedSize: Size(55.0, 55.0),
                                    ),
                                    child:  Image.asset(
                                      'assets/icon/btn_reset.png',
                                    ),
                                  ),
                                ],
                              )
                          ),
                        ),
                        Positioned( /** 재생버튼 */
                            left : SizeUtil.get.sw * 0.4,
                            child: Container(
                              width: SizeUtil.get.sw * 0.2,
                              height: SizeUtil.get.sw * 0.2,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(50),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.blueGrey.withOpacity(0.1),
                                    offset: const Offset(0, -1),
                                  ),
                                ],
                              ),
                              child: TextButton(
                                onPressed: () {
                                  Navigator.pop(context); // 닫기
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  shape: CircleBorder(),
                                  // padding: EdgeInsets.all(13.0),
                                  padding: EdgeInsets.all(10.0),
                                  // fixedSize: Size(90.0, 90.0),
                                ),
                                child:  Image.asset(
                                  'assets/icon/btn_save.png',
                                  // width: 200,
                                  // height: 200.0,
                                ),
                              ),
                            )
                        ),
                      ],
                    )
                ),
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

    context.read<CreateTimerController>().initTimerModel();

    int idxForTimeUnit = context.select((CreateTimerController a) => a.timeUnit);
    int idxForRemainTimeStyle = context.select((CreateTimerController a) => a.remainTimeStyle);

    return Material(
      color: Colors.transparent,
      // shape: CircleBorder(), // 동그랗게 그림자를 만듭니다.
      child: InkWell(
        // splashColor: Colors.grey, // 스플래시 효과 제거
        // highlightColor: Colors.purple, // 하이라이트 효과 제거
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          switch (type){
            case "timeUnit" : { // timeUnit 시간 단위
              idxForTimeUnit = (idxForTimeUnit + 1) % 3;
              context.read<CreateTimerController>().setTimeUnit = idxForTimeUnit;
              // context.read<CreateTimerController>().assignTimerUIData();
            }
            case "maxTime" : { // maxTime 최대 시간
              NumberPickerDialog().show(context);
// "가득 찬 상태로 타이머 시작" 옵션이 활성화 되어있는 경우, 최대 설정 시간과 관계 없이 가득 찬 상태로 타이머가 시작됩니다.
            }
            case "remainTimeStyle" : { // remainTime 남은 시간 표시 여부
              idxForRemainTimeStyle = (idxForRemainTimeStyle + 1) % 3;
              context.read<CreateTimerController>().setRemainTimeStyle = idxForRemainTimeStyle;
              // context.read<CreateTimerController>().assignTimerUIData();
            }
            case "alarmType" : {} // alarmType 무음/진동/알람}
          }
        },
        child: Container(
          width: SizeUtil.get.sw * 0.15, // 가로 크기 (15%)
          height: SizeUtil.get.sh * 0.1 * 0.5, // 세로 크기
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
          TimeUnit.values[context.select((CreateTimerController a) => a.timeUnit)].name,
          style: TextStyle(
            color: Colors.blueGrey, // 텍스트 색상
            fontSize: 18, // 텍스트 크기
            fontWeight: FontWeight.w700, // 텍스트 두께
          ),
        );
      }
      case "maxTime" : { // maxTime 최대 시간
        return Text(
          "60",
          style: TextStyle(
            color: Colors.blueGrey, // 텍스트 색상
            fontSize: 18, // 텍스트 크기
            fontWeight: FontWeight.w700, // 텍스트 두께
          ),
        );
      }
      case "remainTimeStyle" : { // remainTime 남은 시간 표시
        return  Text(
          RemainTimeStyle.values[context.select((CreateTimerController a) => a.remainTimeStyle)].name,
          style: TextStyle(
            color: Colors.blueGrey, // 텍스트 색상
            fontSize: 14, // 텍스트 크기
            fontWeight: FontWeight.w700, // 텍스트 두께
          ),
        );
      }
      case "alarmType" : { // alarmType 무음/진동/알람
        return Icon(
          Icons.alarm,
          color: Colors.grey.withOpacity(0.5),
          size: SizeUtil.get.sh * 0.125 * 0.5,
        );
      }
      default : {
        return SizedBox();
      }
    }
  }

}

