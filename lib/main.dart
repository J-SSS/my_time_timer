import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_time_timer/my_app.dart';

Future<void> main() async {
  CustomWidgetsBinding();  // CustomBinding 사용 - 뭔지 모름

  WidgetsFlutterBinding.ensureInitialized(); // jdi 찾아보기 : 비동기 환경에서 초기화를 보장한다? // SystemChrome 설정 전에 호출
  final prefs = await SharedPreferences.getInstance();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp, // 세로로 고정
  ]).then((_) {
    runApp(MyApp(prefs: prefs));
  });
  // runApp(MyApp(prefs: prefs));
}


class CustomWidgetsBinding extends WidgetsFlutterBinding {
  /*
  WidgetsFlutterBinding은 Flutter에서 위젯 시스템과 Flutter 엔진 간의 브리지 역할을 하는 클래스입니다.
  이 클래스는 위젯 트리 초기화, 앱 라이프사이클 관리, 플랫폼 이벤트 처리, 화면 렌더링 등과 같은 Flutter의 핵심적인 기능을 관리합니다.
  */
  @override
  void initInstances() {
    super.initInstances();
    // 커스텀 초기화 작업
    print('CustomWidgetsBinding initialized!');
  }

  @override
  void handleAppLifecycleStateChanged(AppLifecycleState state) {
    super.handleAppLifecycleStateChanged(state);
    // 앱 라이프사이클 이벤트를 감지하고 처리
    print('AppLifecycleState changed: $state');
  }
}