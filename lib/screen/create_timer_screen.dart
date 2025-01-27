import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_icons_null_safety/flutter_icons_null_safety.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_time_timer/manager/app_manager.dart';
import 'package:my_time_timer/utils/size_util.dart';

import 'package:provider/provider.dart';
import 'package:my_time_timer/widgets/dialog/select_color_dialog.dart';
import '../models/timer_model.dart';
import '../provider/create_timer_controller.dart';
import '../provider/timer_controller.dart';
import '../utils/app_utils.dart';
import '../utils/common_values.dart';
import '../utils/timer_utils.dart';
import '../viewModels/timer_view_model.dart';
import '../widgets/create_timer_toolbar.dart';
import '../widgets/timer_loader.dart';

class CreateTimerScreen extends StatelessWidget {
  CreateTimerScreen({super.key});

  final TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    AppManager.log("타이머생성",type: "B");
    TimerModel timerModel = context.select((CreateTimerController T) => T.timerModel); // 여기서만 select 해주면 될 듯?

    print("타이머 아이디 : ${timerModel.timerId}");
    _textController.text = timerModel.timerName; // TextEditingController에 timerName 초기화

    int groupId = context.read<CreateTimerController>().groupId;
    print('그룹 아이디 : $groupId');

    // print(SizeUtil.get.sw * 0.2);

    double verticalDividerIndent = SizeUtil.get.sh * 0.1 * 0.5 * 0.3;
    double mainLRPadding = SizeUtil.get.sw075.roundToDouble(); // 가로 411 기준 약 31
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: FittedBox( // todo AutoSizeText로 바꾸기
              fit: BoxFit.contain, // 텍스트 크기를 박스 크기에 맞게 조정
              child: Text(timerModel.timerName,style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold))
          ),

          // toolbarHeight: 56,
          centerTitle: true,

          actions: [
            IconButton(
              onPressed: () {
                _showModifyTimerNamePopup(context,timerModel);
              },
              icon: Icon(Icons.mode_edit),
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
                  child: const CreateTimerToolbar()
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
                    color: Colors.blue.withOpacity(0.15),// 임시
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
                                onPressed: () async {
                                  if(timerModel.timerId == -1){ // 신규 생성인 경우
                                    timerModel = timerModel.copyWith(timerId: getUtc()); // 타이머아이디
                                    await context.read<TimerViewModel>().insertTimer(timerModel);
                                    // await asyncTest();
                                  } else { // 업데이트 하는 경우
                                    context.read<TimerViewModel>().updateTimer(timerModel);
                                  }
                                  Navigator.pop(context); // 닫기 todo 메인으로 돌아가게 해야함
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

  void _showModifyTimerNamePopup(BuildContext context, TimerModel model) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('타이머 이름'),
          content: TextField(
            controller: _textController,
            decoration: InputDecoration(
              hintText: '타이머 이름을 입력하세요.',
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                if (!(_textController.text ?? '').isNotEmpty) {
                  Fluttertoast.showToast(
                    msg: "타이머 이름을 입력하세요",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    fontSize: 16.0,
                  );
                } else {
                  print(_textController.text);
                  // _textController.text
                  // GroupModel model = GroupModel(getUtc(), _textController.text, 0);
                  context.read<CreateTimerController>().refreshTimerModel(model.copyWith(timerName: _textController.text));
                  Navigator.pop(context);
                }
              },
              child: Text('수정'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // 다이얼로그 닫기
              },
              child: Text('닫기'),
            ),
          ],
        );
      },
    );
  }

}

