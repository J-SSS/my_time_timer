import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_icons_null_safety/flutter_icons_null_safety.dart';
import 'package:my_time_timer/manager/app_manager.dart';
import 'package:my_time_timer/utils/size_util.dart';

import 'package:provider/provider.dart';
import 'package:my_time_timer/widgets/dialog/select_color_dialog.dart';
import '../models/timer_model.dart';
import '../provider/create_timer_controller.dart';
import '../provider/timer_controller.dart';
import '../utils/app_utils.dart';
import '../utils/common_values.dart';
import '../widgets/create_timer_toolbar.dart';
import '../widgets/timer_loader.dart';

class CreateTimerScreen extends StatelessWidget {
  CreateTimerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AppManager.log("타이머생성",type: "B");

    int groupId = context.read<CreateTimerController>().groupId;
    print('현재그룹아이디 : $groupId');

    TimerModel timerModel = context.select((CreateTimerController T) => T.timerModel);

    // print(SizeUtil.get.sw * 0.2);

    double verticalDividerIndent = SizeUtil.get.sh * 0.1 * 0.5 * 0.3;
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
                  // color: Colors.green.withOpacity(0.2),
                  alignment: Alignment.center,
                  child: CreateTimerToolbar()
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
}

