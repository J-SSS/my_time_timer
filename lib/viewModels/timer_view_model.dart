import 'package:flutter/material.dart';
import 'package:my_time_timer/models/group_model.dart';
import 'package:my_time_timer/models/timer_model.dart';
import 'package:my_time_timer/models/preset_model.dart';
import 'package:my_time_timer/repository/timer_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// TimerViewModel
class TimerViewModel extends ChangeNotifier {
  final TimerRepository _timerRepository = TimerRepository();

  PresetModel? _presetModel;
  PresetModel? get presetModel => _presetModel;

  late TimerModel _recent;
  TimerModel get recent => _recent;

  /// SharedPreferences에서 최근 사용 타이머 정보를 불러온다
  TimerModel loadRecentFromPrefs() {
    TimerModel recentTimer = _timerRepository.getRecentFromPrefs();
    return recentTimer;
  }

  /// mft_timer에 새 타이머를 생성한다
  Future<void> insertTimer (TimerModel model) async {
    await _timerRepository.insertTimer(model.toMap());
    // todo insert 후
    // print(model.toMap());
    final loadedPreset = await _timerRepository.getPresetFromDb();
    _presetModel = loadedPreset;
  }

  /// mft_timer의 타이머를 업데이트 한다
  Future<void> updateTimer (TimerModel model) async {
    await _timerRepository.updateTimer(model.toMap());
    // final loadedPreset = await _timerRepository.getPresetFromDb();
    // _presetModel = loadedPreset;
  }

  /// mft_group에 새 그룹을 생성한다
  Future<void> createGroup (GroupModel model) async {
    List<Map<String, dynamic>> sortOrder = await _timerRepository.getSortOrderGroup();
    model.sortOrder = sortOrder[0]['sortOrder'];
    await _timerRepository.insertGroup(model.toMap());
    final loadedPreset = await _timerRepository.getPresetFromDb();
    _presetModel = loadedPreset;
    notifyListeners();
  }

  /// mft_group에서 그룹을 삭제한다
  Future<void> deleteGroup (int groupId) async {
    await _timerRepository.deleteGroup(groupId); // 그룹 삭제
    await _timerRepository.deleteTimerByGroupId(groupId); // 타이머 삭제
    final loadedPreset = await _timerRepository.getPresetFromDb();
    _presetModel = loadedPreset;
    notifyListeners();
  }

  /// mft_group 및 mft_timer 테이블의 모든 데이터를 PresetModel로 반환한다
  Future<void> loadPresetFromDb() async {
    final loadedPreset = await _timerRepository.getPresetFromDb();
    _presetModel = loadedPreset;
    notifyListeners();
  }

  // FutureBuilder 테스트용, 3초 지연 코드
  static Future<String> loadPresetDb2() async {
    await Future.delayed(const Duration(seconds: 3));
    print('??');
    return 'Hello from the Future!';
  }
}
