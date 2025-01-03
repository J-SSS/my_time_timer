import 'package:flutter/material.dart';
import 'package:my_time_timer/provider/app_config_controller.dart';
import 'package:my_time_timer/widgets/dialog/number_picker_dialog.dart';
import 'package:provider/provider.dart';
import 'package:my_time_timer/widgets/dialog/select_color_dialog.dart';
import '../provider/timer_controller.dart';
import '../utils/app_utils.dart';
import '../widgets/timer_loader.dart';

class CreateTimerScreen extends StatelessWidget {
  final Size safeSize;
  CreateTimerScreen(this.safeSize, {super.key});

  @override
  Widget build(BuildContext context) {
    double verticalDividerIndent = safeSize.height * 0.1 * 0.5 * 0.3;
    print('리빌드');
    print("가로 : ${safeSize.width}, 세로 : ${safeSize.height}");
    double mainLRPadding = (safeSize.width * 0.075).roundToDouble(); // 가로 411 기준 약 31
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
                showOverlayInfo(context,safeSize,"타이틀 숨김");
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
                  height: safeSize.height * 0.1,
                  width: safeSize.width,
                  color: Colors.green.withOpacity(0.15),
                  alignment: Alignment.center,
                  child: Container(
                    height: safeSize.height * 0.1 * 0.5,
                    width: safeSize.width * 0.50,
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
                    height: safeSize.height * 0.7,
                    child:  Padding(
                      padding: EdgeInsets.fromLTRB(mainLRPadding, 0, mainLRPadding, 0), // 좌우 7.5%씩 합 15%
                      child: Center(
                          child: TimerLoader().timerLoader(context, "pizza")
                        // child: TimerLoader().timerLoader(context, "battery")
                      ),
                    )),
                Container(
                    color: Colors.blue.withOpacity(0.15),// 임시
                    width: safeSize.width,
                    height: safeSize.height * 0.2,
                    child: Stack(
                      children: <Widget>[
                        Positioned( /** 상단 반원 영역 */
                            left : safeSize.width * 0.39,
                            top: 0,
                            child: Container(
                              width: safeSize.width * 0.22,
                              height: safeSize.width * 0.22,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(50.00),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black26.withOpacity(0.1),
                                    spreadRadius: 1,
                                    blurRadius: 1,
                                    offset: Offset(0, 0),
                                  ),
                                ],
                              ),
                            )
                        ),
                        Positioned( /** 하단 사각 영역 */
                          top: safeSize.height * 0.2 * 0.25,
                          left: safeSize.width * 0.2,
                          child: Container(
                              width: safeSize.width * 0.6,
                              height: safeSize.height * 0.2 * 0.5,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(50.00),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black26.withOpacity(0.1),
                                    spreadRadius: 1,
                                    blurRadius: 5,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              child : Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  TextButton( /** 좌버튼 */
                                    onPressed: () {
                                      SelectColorDialog.show(context,safeSize);
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
                                    child:  Image.asset(
                                      'assets/icon/btn_color.png',
                                    ),
                                  ),
                                  SizedBox(width: 100,),
                                  TextButton( /** 우버튼 */
                                    onPressed: () {
                                      showOverlayInfo(context,safeSize,"초기화");
                                    },
                                    style: ElevatedButton.styleFrom(
                                      shape: CircleBorder(),
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
                            left : safeSize.width * 0.39,
                            top: 0,
                            child: Container(
                              width: safeSize.width * 0.22,
                              height: safeSize.width * 0.22,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(50.00),
                              ),
                              child: TextButton(
                                onPressed: () {
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  shape: CircleBorder(),
                                  padding: EdgeInsets.all(10.0),
                                  fixedSize: Size(90.0, 90.0),
                                ),
                                child:  Image.asset(
                                  'assets/icon/${context.select((TimerController t) => t.playBtn)}.png',
                                  // width: safeSize.width,
                                  // height: 120.0,
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
    int idx = context.select((AppConfigController a) => a.timeUnit);
    int idx2 = context.select((AppConfigController a) => a.remainTimeStyle);

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
              idx = (idx + 1) % 3;
              context.read<AppConfigController>().setTimeUnit = idx;
            }
            case "maxTime" : { // maxTime 최대 시간
              NumberPickerDialog().show(context,safeSize);
// "가득 찬 상태로 타이머 시작" 옵션이 활성화 되어있는 경우, 최대 설정 시간과 관계 없이 가득 찬 상태로 타이머가 시작됩니다.
            }
            case "remainTimeStyle" : { // remainTime 남은 시간 표시
              idx2 = (idx2 + 1) % 3;
              context.read<AppConfigController>().setRemainTimeStyle = idx2;
            }
            case "timerColor" : { // timerColor 색상(3단)

            }
            case "alarmType" : { // alarmType 무음/진동/알람

            }
            default : SelectColorDialog.show(context, safeSize);
          }
        },
        child: Container(
          width: safeSize.width * 0.15, // 가로 크기 (15%)
          height: safeSize.height * 0.1 * 0.5, // 세로 크기
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
          RemainTimeStyle.values[context.select((AppConfigController a) => a.remainTimeStyle)].name,
          style: TextStyle(
            color: Colors.blueGrey, // 텍스트 색상
            fontSize: 14, // 텍스트 크기
            fontWeight: FontWeight.w700, // 텍스트 두께
          ),
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

