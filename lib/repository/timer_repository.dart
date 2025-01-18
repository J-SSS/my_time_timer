import 'package:my_time_timer/utils/prefs_manager.dart';
import 'package:my_time_timer/models/preset_model.dart';
import 'dart:convert';

import '../models/timer_model.dart';
import '../utils/db_manager.dart';

class TimerRepository {
  final DbManager dbManager = DbManager.instance;
  final PrefsManager prefsManager = PrefsManager.instance;


  TimerRepository();

  /// SharedPreferences에서 최근 사용 타이머 정보를 불러온다
  Future<TimerModel> getRecentFromPrefs() async {
    final recentTimer =  await prefsManager.getRecentTimer();

    return TimerModel.fromSharedPreferences(recentTimer);
  }

  /// mft_folder 및 mft_timer 테이블의 모든 데이터를 조회한다.
  Future<PresetModel?> getPresetDb() async {
    final folderDate =  await dbManager.getFolderData();
    final timerData =  await dbManager.getTimerData();
    return PresetModel.fromDb(folderDate,timerData);
  }
}