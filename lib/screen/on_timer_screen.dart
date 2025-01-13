import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/services.dart';
import 'package:my_time_timer/my_app.dart';
import 'package:my_time_timer/provider/app_config_controller.dart';
import 'package:my_time_timer/provider/timer_controller.dart';
import 'package:my_time_timer/utils/app_manager.dart';
import 'package:my_time_timer/utils/timer_utils.dart' as utils;
import 'package:my_time_timer/viewModels/timer_view_model.dart';
import 'package:my_time_timer/widgets/timer_loader.dart';
import 'package:provider/provider.dart';
import 'package:my_time_timer/widgets/pizza_type.dart';

class OnTimerScreen extends StatefulWidget {
  const OnTimerScreen({super.key});

  @override
  State<OnTimerScreen> createState() => _OnTimerScreenState();
}

class _OnTimerScreenState extends State<OnTimerScreen> {
  bool isVisible = true;

  @override
  Widget build(BuildContext context) {
    Size safeSize = context.read<AppConfigController>().safeSize; // 미디어 사이즈 초기화
    print('빌드');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // print('온타이머'); // jdi : 본 위젯에 대한 콜백함수임
      // context.read<TimerController>().runTimer();
    });
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive); // 상태 표시줄과 네비게이션 바 숨기기 (스와이프로 일시적으로 표시 가능)
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack); // 숨김 // GestureDetector에 덮혀있어서 수정해야함
    // SystemChrome.setSystemUIChangeCallback((systemOverlaysAreVisible) async {
    //   print(systemOverlaysAreVisible);
    //   print('숨김중 터치');
    //   Future.delayed(Duration(seconds: 2), () {
    //     print('숨김중 터2치');
    //     // SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.top]);
    //   });
    // });
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge); // 복원
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky); // 화면전환가능
    // SystemUiMode.immersive: 상태 표시줄과 네비게이션 바 숨기기 (스와이프로 일시적으로 표시 가능).
    // SystemUiMode.leanBack: 간단한 숨김 모드.
    // SystemUiMode.edgeToEdge: 상태 표시줄과 네비게이션 바 복원.\

    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            // isVisible = false;
            // context.read<AppConfigController>().setOnTimerBottomView = true;
            AppManager.log("온타이머 화면 터치", type: "G");
            // utils.showOverlayBottomBar(context);
            // setState(() {
            //   !isVisible;
            //   });
          },
          child: Container(
            color: Colors.redAccent.withOpacity(0.11),
            child: Stack(
                children: [
                  Positioned(
                    top: 0,// todo 수정필요
                    child: TimerLoader().onTimer(context, "battery")
                    // child: TimerLoader().onTimer(context, "pizza")
                  ),
                  Positioned(
                    bottom: 0,// todo 수정필요
                    child: OnTimerBottomBar(),
                  ),
                ],
              ),
          )
        ),
      ),
    );
  }
}


class OnTimerBottomBar extends StatefulWidget {

  // const OnTimerBottomBar({Key? key}) : super(key: key);
  const OnTimerBottomBar({super.key});

  void testFunc(){
    print('키!');
  }

  @override
  State<StatefulWidget> createState() => _onTimerBottomBarState();
}

class _onTimerBottomBarState extends State<OnTimerBottomBar> with WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print(state);
    switch (state) {
      case AppLifecycleState.resumed:
        print("앱이 표시되고 사용자 입력에 응답합니다");
        break;
      case AppLifecycleState.inactive:
        print("앱이 비활성화 상태이고 사용자의 입력을 받지 않습니다");
        break;
      case AppLifecycleState.detached:
        print("모든 뷰가 제거되고 플러터 엔진만 동작 중이며 앱이 종료되기 직전에 실행됩니다");
        break;
      case AppLifecycleState.paused:
        print("앱이 현재 사용자에게 보이지 않고, 사용자의 입력을 받지 않으며, 백그라운드에서 동작 중입니다");
        break;
      default :;
    }
  }
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);
  }
  @override
  void dispose() {
    super.dispose();

    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    Size safeSize = context.read<AppConfigController>().safeSize; // 미디어 사이즈 초기화
    return Visibility(
      // visible: context.watch<AppConfigController>().isOnTimerBottomViewYn,
      visible: true,
      child: Container(
        color: Colors.blueGrey.withOpacity(0.2),
        width: safeSize.width,
        height: safeSize.height * 0.2,
        child: Stack(
          children: <Widget>[
            Positioned( /** 하단 사각 영역 */
              top: safeSize.height * 0.2 * 0.25,
              left: safeSize.width * 0.225,
              child: Container(
                  width: safeSize.width * 0.55,
                  height: safeSize.height * 0.2 * 0.5,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(50),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blueGrey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton( /** 좌버튼 */
                        onPressed: () {
                          context.read<TimerController>().cancelTimer();
                          // Navigator.pop(context); // 닫기
                        },
                        style: ElevatedButton.styleFrom(
                          shape: CircleBorder(),
                          padding: EdgeInsets.all(10.0),
                          fixedSize: Size(65.0, 65.0),
                        ),
                        child:  Image.asset(
                          'assets/icon/btm_theme.png',
                        ),
                      ),
                      TextButton( /** 우버튼 */
                        onPressed: () {

                        },
                        style: ElevatedButton.styleFrom(
                          shape: CircleBorder(),
                          padding: EdgeInsets.all(10.0),
                          fixedSize: Size(65.0, 65.0),
                        ),
                        child:  Image.asset(
                          'assets/icon/${context.select((TimerController t) => t.loopBtn)}.png',
                        ),
                      ),
                    ],
                  )
              ),
            ),
            Positioned( /** 재생버튼 */
                left : safeSize.width * 0.4,
                child: Container(
                  width: safeSize.width * 0.2,
                  height: safeSize.width * 0.2,
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
                      context.read<TimerController>().runTimer();

                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: CircleBorder(),
                      padding: EdgeInsets.all(10.0),
                      // fixedSize: Size(90.0, 90.0),
                    ),
                    child:  Image.asset(
                      'assets/icon/${context.select((TimerController t) => t.playBtn)}.png',
                    ),
                  ),
                )
            ),
          ],
        ),
      ),
    );
  }
}
