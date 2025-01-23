import 'package:my_time_timer/manager/prefs_manager.dart';
import 'package:my_time_timer/models/group_model.dart';
import 'package:my_time_timer/models/preset_model.dart';
import 'dart:convert';

import '../models/timer_model.dart';
import '../manager/db_manager.dart';

/// TimerRepository
class TimerRepository {
  final DbManager dbManager = DbManager.instance;
  final PrefsManager prefsManager = PrefsManager.instance;

  TimerRepository();

  /// SharedPreferences에서 최근 사용 타이머 정보를 불러온다
  TimerModel getRecentFromPrefs()  {
    Map<String, dynamic> recentTimer = prefsManager.getRecentTimer();
    print(recentTimer);
    return TimerModel.fromMap(recentTimer);
  }

  /// mft_group 및 mft_timer 테이블의 모든 데이터를 PresetModel로 반환한다
  Future<PresetModel?> getPresetFromDb() async {
    final groupDate =  await dbManager.getGroupData();
    final timerData =  await dbManager.getTimerData();
    return PresetModel.fromMap(groupDate,timerData);
  }

  /// mft_group에 새 그룹을 생성한다
  Future<void> insertGroup(Map<String, dynamic> data) async {
    await dbManager.insertGroup(data);
  }

  /// mft_group에 새 그룹을 생성하기 위한 sortOrder 값을 반환한다
  Future<List<Map<String, dynamic>>> getSortOrderGroup() async {
    return await dbManager.getSortOrderGroup();
  }

  /// mft_group에서 그룹을 삭제한다
  Future<void> deleteGroup(int groupId) async {
    await dbManager.deleteGroup(groupId);
  }

  /// mft_timer에서 groupId에 해당하는 타이머를 삭제한다
  Future<void> deleteTimerByGroupId(int groupId) async {
    await dbManager.deleteTimerByGroupId(groupId);
  }






}