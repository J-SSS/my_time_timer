import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_time_timer/models/config_model.dart';
import 'package:my_time_timer/models/preset_model.dart';
import 'dart:convert';

import '../utils/db_manager.dart';

class TimerRepository {
  final SharedPreferences _prefs;
  final DbManager dbManager = DbManager.instance;

  TimerRepository(this._prefs);

  /// mft_folder 및 mft_timer 테이블의 모든 데이터를 조회한다.
  Future<PresetModel?> getPresetDb() async {
    final folderDate =  await dbManager.getFolderData();
    final timerData =  await dbManager.getTimerData();
    return PresetModel.fromDb(folderDate,timerData);
  }

  /// deprecated
  Future<void> saveConfig(ConfigModel config) async {
    final jsonString = config.toJson();
    print('저장값 : ${jsonString}');
    await _prefs.setString('config', jsonString);
  }

  /// deprecated
  Future<ConfigModel?> getConfig() async {
    final jsonString = _prefs.getString('config');
    if (jsonString != null) {
      print('로딩 값 : ${jsonString}');
      final Map<String, dynamic> jsonMap = json.decode(jsonString);
      return ConfigModel.fromJson(jsonMap);
    } else {
      print('default 값 반환');
      return ConfigModel.fromJson(null);
    }
  }

  /// deprecated
  Future<void> clearConfig() async {
    await _prefs.remove('config');
  }

  /// deprecated
  Future<void> savePreset(PresetModel preset) async {
    final jsonString = preset.toJson();
    print('저장값 : ${jsonString}');
    await _prefs.setString('preset', jsonString);
  }

  /// deprecated
  Future<PresetModel?> getPreset() async {
    final jsonString = _prefs.getString('preset');
    if (jsonString != null) {
      // print('로딩 값 : ${jsonString}');
      final Map<String, dynamic> jsonMap = json.decode(jsonString);
      return PresetModel.fromJson(jsonMap);
    } else {
      print('default 값 반환');
      return PresetModel.fromJson(null);
    }
  }

  /// deprecated
  Future<void> clearPreset() async {
    await _prefs.remove('preset');
  }
}