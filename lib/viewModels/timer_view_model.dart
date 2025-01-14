import 'package:flutter/material.dart';
import 'package:my_time_timer/models/config_model.dart';
import 'package:my_time_timer/models/preset_model.dart';
import 'package:my_time_timer/repository/timer_repository.dart';

class TimerViewModel extends ChangeNotifier {
  final TimerRepository _timerRepository;

  TimerViewModel(this._timerRepository);

  ConfigModel? _config;
  ConfigModel? get config => _config;

  PresetModel? _preset;
  PresetModel? get preset => _preset;

  /// mft_folder 및 mft_timer 테이블의 모든 데이터를 조회한다.
  Future<void> loadPresetDb() async {
    final loadedPreset = await _timerRepository.getPresetDb();
    _preset = loadedPreset;
    notifyListeners();
  }






  /// deprecated
  Future<void> saveConfig(String id, String name) async {
    final newConfig = ConfigModel(id: id, name: name);
    await _timerRepository.saveConfig(newConfig);
    _config = newConfig;
    notifyListeners();
  }

  /// deprecated
  Future<void> loadConfig() async {
    final loadedConfig = await _timerRepository.getConfig();
    _config = loadedConfig;
    print('로드타이머 : ${loadedConfig}');
    notifyListeners();
  }

  /// deprecated
  Future<void> clearConfig() async {
    await _timerRepository.clearConfig();
    _config = null;
    notifyListeners();
  }

  /// deprecated
  Future<void> savePreset() async {
    final newPreset = PresetModel.fromSharedPreferences(null,null);
    await _timerRepository.savePreset(newPreset);
    _preset = newPreset;
    notifyListeners();
  }

  /// deprecated
  Future<void> addFolder(String folderName, String type) async {
    if(type == 'F') { // 폴더 추가시
      // _preset!.folderPreset?[UniqueKey().toString()]={'nodeName' : folderName};
      _preset!.addFolderPreset(folderName);
    } else { // 타이머 추가시

    }
    await _timerRepository.savePreset(_preset!);
    print('에드프리셋 : ${_preset}');
    notifyListeners();
  }

  /// deprecated
  Future<void> addPreset(String folderName, String type) async {
    if(type == 'F') { // 폴더 추가시
      // _preset!.folderPreset?[UniqueKey().toString()]={'nodeName' : folderName};
      _preset!.addFolderPreset(folderName);
    } else { // 타이머 추가시

    }
    await _timerRepository.savePreset(_preset!);
    print('에드프리셋 : ${_preset}');
    notifyListeners();
  }

  /// deprecated
  Future<void> deletePreset(String id, String type) async {
    if(type == 'F'){ // 폴더 삭제시
      _preset!.folderPreset?.remove(id);

      // 삭제할 키들을 기록할 Set
      Set<String> keysToRemove = {};

      // 특정 조건을 만족하는 키를 찾아 Set에 추가
      _preset!.timerPreset.forEach((key, value) {
        if(value['parentNodeId'] == id){
          keysToRemove.add(key);
        }
      });

      // Set에 있는 키들을 사용하여 entry 삭제
      keysToRemove.forEach((key) {
        _preset!.timerPreset.remove(key);
      });

    } else if (type == 'T'){ // 타이머 삭제시

    }
    await _timerRepository.savePreset(_preset!);
    notifyListeners();
  }

  /// deprecated
  Future<void> loadPreset() async {
     final loadedPreset = await _timerRepository.getPreset();
    _preset = loadedPreset;
    // print('로드프리셋 : ${loadedPreset?.preset}');
    notifyListeners();
  }
  /// deprecated
  Future<void> clearPreset() async {
    await _timerRepository.clearPreset();
    _preset = null;
    notifyListeners();
  }
}
