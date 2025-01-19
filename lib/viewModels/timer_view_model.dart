import 'package:flutter/material.dart';
import 'package:my_time_timer/models/timer_model.dart';
import 'package:my_time_timer/models/preset_model.dart';
import 'package:my_time_timer/repository/timer_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TimerViewModel extends ChangeNotifier {
  final TimerRepository _timerRepository = TimerRepository();

  PresetModel? _preset;
  PresetModel? get preset => _preset;

  late TimerModel _recent;
  TimerModel get recent => _recent;

  /// SharedPreferences에서 최근 사용 타이머 정보를 불러온다
  TimerModel loadRecentFromPrefs() {
    TimerModel loadedPreset = _timerRepository.getRecentFromPrefs();
    _recent = loadedPreset;
    return _recent;
    // notifyListeners();
  }

  /// mft_folder 및 mft_timer 테이블의 모든 데이터를 조회한다.
  Future<void> loadPresetDb() async {
    final loadedPreset = await _timerRepository.getPresetDb();
    _preset = loadedPreset;
    notifyListeners();
  }

  static Future<String> loadPresetDb2() async {
    await Future.delayed(const Duration(seconds: 3));
    return 'Hello from the Future!';
  }

  Future<PresetModel?> loadPresetDb3() async {
    final loadedPreset = await _timerRepository.getPresetDb();
    return loadedPreset;
    // _preset = loadedPreset;
    // notifyListeners();
  }
}
