import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_icons_null_safety/flutter_icons_null_safety.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_time_timer/manager/app_manager.dart';
import 'package:my_time_timer/screen/select_theme_screen.dart';
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
    //
    // // ① 우선 텍스트를 그려서 폭(width)을 측정할 준비
    // final defaultStyle = style ?? DefaultTextStyle.of(context).style;
    // final textSpan = TextSpan(text: text, style: defaultStyle);
    //
    // // ② 레이아웃 계산을 위해 LayoutBuilder 사용
    // return LayoutBuilder(
    //     builder: (context, constraints) {
    //       // ③ TextPainter로 실제 텍스트 크기 측정
    //       final textPainter = TextPainter(
    //         text: textSpan,
    //         textDirection: TextDirection.ltr,
    //         maxLines: 1,
    //       );
    //       textPainter.layout();  // 텍스트 레이아웃 계산
    //       final textWidth = textPainter.width;
    //
    //       // ④ 아이콘이 없다면 그냥 텍스트만 중앙 배치
    //       if (icon == null) {
    //         return Center(child: Text(text, style: defaultStyle));
    //       }
    //
    //       // ⑤ 아이콘이 있다면, 아이콘을 텍스트 오른쪽에 배치할 만큼 이동량 계산
    //       //    gap만큼 띄우고, 아이콘의 중심이 아닌 '아이콘 시작 위치'가 오도록 조절
    //       //    실제 아이콘 폭이 궁금하다면 Icon으로 한번 측정 과정을 거쳐야 하지만,
    //       //    일반 Material 아이콘은 고정 폭(24) 정도로 동작.
    //       const iconWidth = 24.0;
    //       final iconOffset = textWidth / 2 + gap; // 텍스트 끝에서 gap만큼 오른쪽
    //
    //       return Stack(
    //         children: [
    //           // ⑥ 텍스트는 화면 절대 중앙
    //           Center(child: Text(text, style: defaultStyle)),
    //
    //           // ⑦ 아이콘을 텍스트 오른쪽에 덧붙이되, 텍스트가 완전 중앙에 놓이도록
    //           Center(
    //             child: Transform.translate(
    //               offset: Offset(iconOffset, 0),
    //               child: Icon(icon, size: defaultStyle.fontSize ?? 24),
    //             ),
    //           ),
    //         ],
    //       );

    // print(SizeUtil.get.sw * 0.2);

    double verticalDividerIndent = SizeUtil.get.sh * 0.1 * 0.5 * 0.3;
    double mainLRPadding = SizeUtil.get.sw075.roundToDouble(); // 가로 411 기준 약 31
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
        // appBar: AppBar(
        //   leading: const SizedBox(),
        //   // leading: Container(color: Colors.red,),
        //   title: Row(
        //     mainAxisAlignment: MainAxisAlignment.center,
        //     children: [

        //
        //   // toolbarHeight: 56,
        //   centerTitle: true,
        // ),

        body: SafeArea(
            child:Column(
              children: [
                Container( // 임시
                    height: SizeUtil.get.sh * 0.075, // todo 여백 다시 맞추기
                    width: SizeUtil.get.sw,
                    // color: Colors.grey.withOpacity(0.55),
                    alignment: Alignment.center,
                    child: const CreateTimerToolbar()
                ),
                Container( // 임시
                    height: SizeUtil.get.sh * 0.075,
                    width: SizeUtil.get.sw,
                    // color: Colors.blue.withOpacity(0.1),
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                      ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: 200), // 최대 너비 제한
                        child: Text(timerModel.timerName,
                            maxLines: 1, // 최대 한 줄로 제한
                            overflow: TextOverflow.ellipsis, // 넘치는 텍스트를 생략(...)
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Colors.black54,
                              shadows: [
                                Shadow(
                                  offset: Offset(0, 3), // 그림자의 x, y 위치
                                  blurRadius: 1.0, // 그림자 흐림 정도
                                  color: Colors.grey.withOpacity(0.2), // 그림자 색상
                                ),
                              ],))
                      ),

                      IconButton(
                        onPressed: () {
                          _showModifyTimerNamePopup(context,timerModel);
                        },
                        icon: Icon(MaterialCommunityIcons.pencil,size: 20,color: Colors.blueGrey,),
                        // color: Colors.grey,
                      ),
                    ],)





                ),


                Container(
                    height: SizeUtil.get.sh * 0.7,
                    // color: Colors.red.withOpacity(0.1),
                    child:  Padding(
                      padding: EdgeInsets.fromLTRB(mainLRPadding, 0, mainLRPadding, 0), // 좌우 7.5%씩 합 15%
                      child: Center(
                          child: TimerLoader().timerLoader(context, "pizza", TimerScreenType.create)
                        // child: TimerLoader().timerLoader(context, "battery", TimerScreenType.create)
                      ),
                    )
                ),


                Container(
                  // color: Colors.red.withOpacity(0.55),// 임시
                  width: SizeUtil.get.sw,
                  height: SizeUtil.get.sh * 0.15,
                  alignment: Alignment.center,
                  child: Container(
                      width: SizeUtil.get.sw * 0.9,
                      height: SizeUtil.get.sh * 0.15 * 0.65,
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
                          Expanded(
                            child:
                            SizedBox(
                              // width: SizeUtil.get.sw * 0.8 * 0.7,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  TextButton( /** 칼라 버튼 */
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
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            'assets/icon/btn_color.png',
                                            width: 30,
                                            height: 30,
                                          ),
                                          Text("Colors")
                                        ]
                                        ,)
                                  ),
                                  TextButton( /** 테마 버튼 */
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => SelectThemeScreen()),
                                        );
                                        showOverlayInfo(context,"초기화");
                                      },
                                      style: ElevatedButton.styleFrom(
                                        shape: const CircleBorder(),
                                        // padding: EdgeInsets.all(10.0),
                                        // fixedSize: Size(55.0, 55.0),
                                      ),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(MaterialCommunityIcons.cards,size: 30,),//format_paint
                                          Text("Theme")
                                        ]
                                        ,)
                                  ),
                                  TextButton( /** 알람 버튼 */
                                      onPressed: () {
                                        showOverlayInfo(context,"초기화");
                                      },
                                      style: ElevatedButton.styleFrom(
                                        shape: const CircleBorder(),
                                        // padding: EdgeInsets.all(10.0),
                                        // fixedSize: Size(55.0, 55.0),
                                      ),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(MaterialCommunityIcons.alarm,size: 30,),//format_paint
                                          Text("Alarm",style: TextStyle(color: Colors.deepPurple),)
                                        ]
                                        ,)
                                  ),

                                ],
                              ),
                            ),
                          ),
                          Container( // 재생버튼 부분
                            // color: Colors.redAccent.withOpacity(0.1),
                            // width: SizeUtil.get.sw * 0.8 * 0.3,
                            width: SizeUtil.get.sh * 0.2 * 0.5,
                            child: TextButton(
                              onPressed: () async {
                                // if(timerModel.timerId == -1){ // 신규 생성인 경우
                                //   timerModel = timerModel.copyWith(timerId: getUtc()); // 타이머아이디
                                //   await context.read<TimerViewModel>().insertTimer(timerModel);
                                //   // await asyncTest();
                                // } else { // 업데이트 하는 경우
                                //   context.read<TimerViewModel>().updateTimer(timerModel);
                                // }
                                // Navigator.pop(context); // 닫기 todo 메인으로 돌아가게 해야함
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                shape: CircleBorder(),
                                // padding: EdgeInsets.all(13.0),
                                padding: EdgeInsets.all(0.0),
                                // fixedSize: Size(90.0, 90.0),
                              ),
                              child:  Image.asset(
                                'assets/icon/btn_save.png',fit: BoxFit.fill,
                                // width: 200,
                                // height: 200.0,
                              ),
                            ),
                          ),


                        ],
                      )
                  ),

                ),



              ],
            )
        )

    );
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

