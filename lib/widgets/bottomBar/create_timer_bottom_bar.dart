import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons_null_safety/flutter_icons_null_safety.dart';
import 'package:provider/provider.dart';

import '../../models/timer_model.dart';
import '../../provider/create_timer_controller.dart';
import '../../screen/select_theme_screen.dart';
import '../../utils/app_utils.dart';
import '../../utils/size_util.dart';
import '../../utils/timer_utils.dart';
import '../../viewModels/timer_view_model.dart';
import '../dialog/select_color_dialog.dart';

class CreateTimerBottomBar extends StatefulWidget {
  const CreateTimerBottomBar({super.key});

  @override
  State<CreateTimerBottomBar> createState() => _CreateTimerBottomBarState();
}

class _CreateTimerBottomBarState extends State<CreateTimerBottomBar> {
  @override
  Widget build(BuildContext context) {
    TimerModel timerModel = context.read<CreateTimerController>().timerModel;
    return Stack(
      clipBehavior: Clip.none, // 버튼이 영역 밖에 배치되더라도 잘리지 않도록 함.
      children: [
        // 배경 박스
        BiteContainer(
          biteRadius: SizeUtil().sh15 * 0.4,
          elevation: 20.0,
          color: Colors.white,
          child: Container(
            // decoration: BoxDecoration(
            //   border: Border.all(
            //       color: Colors.blueGrey.withOpacity(0.5), width: 0.5),
            // ),
            width: SizeUtil().sw,
            height: SizeUtil().sh15 * 0.8,
            // padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.symmetric(horizontal:  BorderSide(color: Colors.blueGrey.withOpacity(0.5), width: 0.5)),
                  ),
                  // color: Colors.red.withOpacity(0.1),
                  width: SizeUtil().sw - (SizeUtil().sh15 * 1.08), // 플로팅버튼 부분과 구분해주기 위함(SizeUtil().sw - SizeUtil().sh15 * 0.6 - SizeUtil().sh15 * 0.48)
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
                          ),
                          padding: EdgeInsets.all(0.0),
                          // fixedSize: Size(55.0, 55.0),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/icon/btn_color.png',
                              width: 40,
                              height: 40,
                            ),
                            // Text("Colors")
                            Text("Theme",style: TextStyle(color: Colors.deepPurple,fontSize: 12),)

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
                          padding: EdgeInsets.all(0.0),
                          // fixedSize: Size(55.0, 55.0),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(MaterialCommunityIcons.cards,size: 40,),//format_paint
                            Text("Theme",style: TextStyle(color: Colors.deepPurple,fontSize: 12),)
                          ]
                          ,)
                    ),
                    TextButton( /** 알람 버튼 */
                        onPressed: () {
                          showOverlayInfo(context,"초기화");
                        },
                        style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          padding: EdgeInsets.all(0.0),
                          // fixedSize: Size(55.0, 55.0),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(MaterialCommunityIcons.alarm,size: 40,),//format_paint
                            Text("Alarm",style: TextStyle(color: Colors.deepPurple,fontSize: 12),)
                          ]
                          ,)
                    ),

                  ],
                ),
                )

              ],
            )


          ),
        ),
        Positioned(
          top: - SizeUtil().sh15 * 0.4,
          right: SizeUtil().sh15 * 0.2,
          child: RawMaterialButton(
              onPressed: () async {
                if(timerModel.timerId == -1){ // 신규 생성인 경우
                  timerModel = timerModel.copyWith(timerId: getUtc()); // 타이머아이디
                  await context.read<TimerViewModel>().insertTimer(timerModel);
                } else { // 업데이트 하는 경우
                  await context.read<TimerViewModel>().updateTimer(timerModel);
                }
                if (!context.mounted) return;
                Navigator.pop(context);
              },
            fillColor: Colors.blueGrey.withOpacity(0.5),
            constraints: BoxConstraints.tightFor(width: SizeUtil().sh15 * 0.8, height: SizeUtil().sh15 * 0.8), // 원하는 크기 지정
            shape: const CircleBorder(),
            child: Image.asset(
              'assets/icon/btn_save.png',fit: BoxFit.fill,
              width: SizeUtil().sh15 * 0.8,
              height: SizeUtil().sh15 * 0.8,
            ),
          ),
        ),
      ],
    );
  }
}


/// 사각형에서 오른쪽 상단에 있는 원형 영역을 빼는 클리퍼
class BiteClipper extends CustomClipper<Path> {
  final double biteRadius;

  BiteClipper({this.biteRadius = 30.0});

  @override
  Path getClip(Size size) {
    final rectPath = Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height)); // 기본 사각형 Path
    final biteCenter = Offset(size.width - biteRadius - biteRadius/2, 0); // 원 중심점
    final bitePath = Path()..addOval(Rect.fromCircle(center: biteCenter, radius: biteRadius * 1.2)); // addOval은 인자를 받아 원형 Path를 만든다

    return Path.combine(PathOperation.difference, rectPath, bitePath); // Path1에서 Path2를 뺀 Path 반환
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true; // todo false로 바꿔주기
}

/// 한 입 베어먹은 모양의 박스 (그림자 포함)
class BiteContainer extends StatelessWidget {
  final Widget child;
  final double biteRadius;
  final double elevation;
  final Color color;

  const BiteContainer({
    Key? key,
    required this.child,
    this.biteRadius = 30.0,
    this.elevation = 4.0,
    this.color = Colors.grey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // PhysicalShape를 사용하면 CustomClipper로 잘린 모양에 그림자(elevation)를 줄 수 있습니다.
    return PhysicalShape(
      clipper: BiteClipper(biteRadius: biteRadius),
      elevation: elevation,
      color: color,
      child: child,
      shadowColor: Colors.blueGrey,
    );
  }
}
