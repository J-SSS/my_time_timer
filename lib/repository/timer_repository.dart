import 'package:my_time_timer/manager/prefs_manager.dart';
import 'package:my_time_timer/models/preset_model.dart';
import 'dart:convert';

import '../models/timer_model.dart';
import '../manager/db_manager.dart';

class TimerRepository {
  final DbManager dbManager = DbManager.instance;
  final PrefsManager prefsManager = PrefsManager.instance;

  TimerRepository();

  /// SharedPreferences에서 최근 사용 타이머 정보를 불러온다
  TimerModel getRecentFromPrefs()  {
    Map<String, dynamic> recentTimer = prefsManager.getRecentTimer();
    return TimerModel.fromSharedPreferences(recentTimer);
  }

  /// mft_group 및 mft_timer 테이블의 모든 데이터를 PresetModel로 반환한다
  Future<PresetModel?> getPresetFromDb() async {
    final groupDate =  await dbManager.getGroupData();
    final timerData =  await dbManager.getTimerData();
    return PresetModel.fromDb(groupDate,timerData);
  }
}