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
    TimerModel loadedPreset = _timerRepository.getRecentFromPrefs();
    _recent = loadedPreset;
    return _recent;
    // notifyListeners();
  }

  void createGroup (GroupModel model){

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
    return 'Hello from the Future!';
  }
}
