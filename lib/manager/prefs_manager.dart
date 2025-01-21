import 'dart:async';
import 'dart:convert';
import 'package:my_time_timer/manager/app_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/preset_model.dart';

class PrefsManager {
  PrefsManager._();
  static final PrefsManager instance = PrefsManager._();

  late SharedPreferences _prefs;

  /// SharedPreferences 초기화
  Future<void> init() async {
    AppManager.log("SharedPreferences 초기화", type: "S");
    _prefs = await SharedPreferences.getInstance();
    var recent = _prefs.getString('recent');
    if (recent == null) {
      await saveDefaultAndLoad();
    }
  }

  /// 최근 사용 타이머 정보를 반환한다
  Map<String, dynamic> getRecentTimer() {
    var jsonString = _prefs.getString('recent');
    // print(jsonString);
    Map<String, dynamic> recent = json.decode(jsonString!);
    return recent;
  }

  /// 최근 사용 타이머가 없을 경우, 기본 값을 저장하고 반환한다.
  Future<Map<String, dynamic>> saveDefaultAndLoad() async {
    const Map<String,dynamic> defaultUiData = {
      "type" : "pizza",
      "timeUnit" : 0, // 시간 단위 (0 : 초, 1 : 분, 2 : 시간)
      "maxTime" : 60, // 최대 시간
      "remainTimeStyle" : 1, // 남은 시간 표시 여부 (0 : 표시안함, 1 : hh:mm:ss, 2 : 00%)
      "alarmType" : 1, // 무음/진동/알람 (0 : 무음, 1 : 진동, 2 : 소리)
      "timerColorList" : [0,1,2,3,4], // 타이머 색상 리스트 (최대 5개)
    };

    String defaultTimerString = json.encode(defaultUiData);

    await _prefs.setString('recent', defaultTimerString);
    return defaultUiData;
  }

  /// deprecated
  Future<void> clearPrefs() async {
    await _prefs.remove('recent');
  }
}
