import 'dart:convert';

class TimerModel {

  Map<String,dynamic> _timerUIData = {
    "timeUnit" : 0, // 시간 단위 (0 : 초, 1 : 분, 2 : 시간)
    "maxTime" : 60, // 최대 시간
    "remainTimeStyle" : 1, // 남은 시간 표시 여부 (0 : 표시안함, 1 : hh:mm:ss, 2 : 00%)
    "alarmType" : 1, // 무음/진동/알람 (0 : 무음, 1 : 진동, 2 : 소리)
    "timerColorList" : [0], // 타이머 색상 리스트 (최대 5개)
  };

  /// 시간 단위 (0 : 초, 1 : 분, 2 : 시간)
  int _timeUnit = 0;

  /// 최대 시간
  int _maxTime = 60; // OK

  /// 남은 시간 표시 여부 (0 : 표시안함, 1 : hh:mm:ss, 2 : 00%)
  int _remainTimeStyle = 1;

  /// 무음/진동/알람 (0 : 무음, 1 : 진동, 2 : 소리)
  int _alarmType = 0;

  /// 타이머 색상 리스트 (최대 5개)
  List<int> _timerColorList = [0];

  int _timerColorListSize = 0; /// 타이머 색상 리스트 사이즈 (최대 5개)

  List<Map<String,String>> _timerColorData = [{"colorIdx": "0", "msg": "~100%"}]; /// 타이머 색상 리스트 (최대 5개)

// 'setupTime': '45', // 설정 시간
// 'viewRemainTime': '', // 남은 시간 표시 여부
// 'viewDescript': 'false', // 설명 표시 여부
// 'descriptText': 'test', // 설명 텍스트
// 'isAlarmYn': 'N', // 알람 여부
// 'alarmType': '', // 알람 타입 무음/진동/소리
// 'dismissAlarm': '', // 한 번, 버튼 클릭
// 'dismissAlarm': '', // 한 번, 버튼 클릭
// 'isInterNotif': '', // 중간 알림
// 'notifUnit': '', // 중간 알림
// 'notifGap': '', // 알림 간격
// 'notifType': '', // 알림 타입 무음 / 진동 / 소리
// bool? startFull; // 100%부터 시작 여부

// bool? omitAlarm; // 다음 타이머가 있을 때 알람 생략
//
// String? alarmType; // 알림 스타일 (소리 / 진동 / 무음)
// String? alarmEffect; // 알림시 화면 효과 // jdi 필요 없을 수 있음
// String? alarmExit; // 알림 종료(자동, 정지 할 때 까지)
//
// String? interAlarmType; // 중간 알림 (설정 안함 / 분 / 초)
// String? interAlarmEffect; // 중간 알림 스타일 (소리 / 진동 / 무음)
//
// String? interAlarm; // 종료임박시 깜빡임 (설정 안함 / 분 / 초) // jdi 더 생각해보기

  Map<String, dynamic> _recentTimer = {}; // 최근 타이머
  get recentTimer => _recentTimer;

  TimerModel.fromSharedPreferences(Map<String, dynamic> recentTimer){ // SharedPreferences 사용하는 경우
    _recentTimer = recentTimer;
  }


  /**
   * Java에서 Lombok 등을 사용해 Getter/Setter, equals, hashCode를 자동화하는 것처럼, Dart에도 아래와 같은 라이브러리를 사용할 수 있습니다:

      freezed : 불변 모델, copyWith, JSON 변환 등을 자동 생성
      json_serializable : fromJson, toJson 메서드를 자동 생성
      예를 들어, freezed를 사용하면 다음과 같이 짧게 작성할 수 있고, 빌드 시점에 복잡한 보일러플레이트 코드를 만들어 줍니다.


      User({
      required this.name,
      required this.age,
      });

      factory User.fromJson(Map<String, dynamic> json) {
      return User(
      name: json['name'] as String,
      age: json['age'] as int,
      );
      }

      Map<String, dynamic> toJson() {
      return {
      'name': name,
      'age': age,
      };
      }
   */

}



