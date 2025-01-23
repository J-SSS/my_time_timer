import 'dart:convert';
import 'dart:math';

/// mft_timer 테이블을 맵핑하기 위한 Model
class TimerModel {
  /// 타이머 고유아이디
  final int timerId;
  /// 폴더 고유아이디
  final int groupId;
  /// 타이머 이름
  final String timerName;
  /// 타이머 정렬 순서
  final int sortOrder;
  /// 설정시간
  int setupTime = 45;
  /// 타이머 타입 (0 : 타이머형, 1 : 알람형)
  final int timeType = 0;
  /// 시간 단위 (0 : 초, 1 : 분, 2 : 시간)
  final int timeUnit;
  /// 최대 시간
  final int maxTime; // OK
  /// 남은 시간 표시 여부 (0 : 표시안함, 1 : hh:mm:ss, 2 : 00%)
  final int remainTimeStyle;
  /// 무음/진동/알람 (0 : 무음, 1 : 진동, 2 : 소리)
  final int alarmType = 0;
  /// 타이머 색상 리스트 (최대 5개)
  final List<int> timerColorList;

  //
  //
  // TimerModel.fromSharedPreferences(Map<String, dynamic> recentTimer){ // SharedPreferences 사용하는 경우
  //   _recentTimer = recentTimer;
  //   // return TimerModel();
  // }


  Map<String, dynamic> _recentTimer = {}; // 최근 타이머
  get recentTimer => _recentTimer;

  // List<int> get timerColorList => _timerColorList;
  //
  // set timerColorList(List<int> value) {
  //   _timerColorList = value;
  // }

  TimerModel(
    {
    this.timerId = 0,
    this.groupId = 0,
    this.timerName = "새 타이머",
    this.sortOrder = 0,
    this.timeUnit = 0,
    this.maxTime = 60,
    this.remainTimeStyle = 0,
    this.timerColorList = const [0],
    }
      );

  // TimerModel.dflt();
  // List<int> timerColorList

  // copyWith 메서드
  TimerModel copyWith({
    int? timerId,
    int? groupId,
    String? timerName,
    int? sortOrder,
    int? timeUnit,
    int? maxTime,
    int? remainTimeStyle,
    List<int>? timerColorList,
  }) {
    print('타이머카피');
    return TimerModel(
      timerId : timerId ?? this.timerId,
      groupId : groupId ?? this.groupId,
      timerName : timerName ?? this.timerName,
      sortOrder : sortOrder ?? this.sortOrder,
      timeUnit : timeUnit ?? this.timeUnit,
      maxTime : maxTime ?? this.maxTime,
      remainTimeStyle : remainTimeStyle ?? this.remainTimeStyle,
      timerColorList : timerColorList ?? this.timerColorList,
    );
  }


  factory TimerModel.fromMap(Map<String, dynamic> timerData) {
    return TimerModel(
        timerId : timerData['timerId'],
        groupId : timerData['groupId'],
        timerName: timerData['timerName'],
        sortOrder: timerData['sortOrder']
    );
  }

// 'timerId': "", // 타이머 고유아이디
// 'groupId': "", // 폴더 고유아이디
// 'timerName': "", // 타이머 이름
// 'sortOrder': "", // 타이머 정렬 순서
// 'setupTime': 45, // 설정 시간
// 'uiType': 'pizza', // 디자인 타입
// 'timeType': 0, // 타이머 타입 (0 : 타이머형, 1 : 알람형)
// 'maxTime': 60, // 최대 시간
// 'timeUnit': 0, // 시간 단위 (0 : 초, 1 : 분, 2 : 시간)
// 'remainTimeStyle': 'false', // 남은 시간 표시 여부 (0 : 표시안함, 1 : hh:mm:ss, 2 : 00%)
// 'alarmType': 0, // 무음/진동/알람 (0 : 무음, 1 : 진동, 2 : 소리)
// 'timerColorList': [0], // 타이머 색상 리스트 (최대 5개)


// 'dismissAlarm': '', // 한 번, 버튼 클릭
// 'isInterNotif': '', // 중간 알림
// 'notifUnit': '', // 중간 알림
// 'notifGap': '', // 알림 간격
// 'notifType': '', // 알림 타입 무음 / 진동 / 소리
// bool? startFull; // 100%부터 시작 여부

// bool? omitAlarm; // 다음 타이머가 있을 때 알람 생략
// String? alarmType; // 알림 스타일 (소리 / 진동 / 무음)
// String? alarmEffect; // 알림시 화면 효과 // todo 필요 없을 수 있음
// String? alarmExit; // 알림 종료(자동, 정지 할 때 까지)

// String? interAlarmType; // 중간 알림 (설정 안함 / 분 / 초)
// String? interAlarmEffect; // 중간 알림 스타일 (소리 / 진동 / 무음)
// String? interAlarm; // 종료임박시 깜빡임 (설정 안함 / 분 / 초) // todo 더 생각해보기

// 마지막 1분 타이머 ★★
// 종료 후에도 카운트


/**
 * 기본 타이머 / 목표 시간 타이머
 * 최대 시간 / 목표 시간
 * (최대 mm min) / To hh:mm 까지
 *
 *
 * ### 기본 타이머
 * - 초
 * 최소 단위 : 5초
 * 최소 값 : 5초
 * 최대 값 : 360초 = 6분
 *
 * - 분
 * 최소 단위 : 1분
 * 최소 값 : 1분
 * 최대 값 : 360분 = 6시간
 *
 * ### 스케쥴 타이머
 * 오전/오후
 * 시/분
 */


}



