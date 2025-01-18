import 'dart:convert';

import 'package:flutter/cupertino.dart';

class PresetModel {
  List<Map<String, dynamic>>? _folderPresetDb = []; // 폴더(DB)
  List<Map<String, dynamic>>? _timerPresetDb = []; // 타이머(DB)

  get folderPresetDb => _folderPresetDb;
  get timerPresetDb => _timerPresetDb;

  PresetModel.list(folderData, timerData){
    _folderPresetDb = folderData;
    _timerPresetDb = timerData;
  }

  /// mft_folder 및 mft_timer 테이블의 모든 데이터를 조회한다.
  factory PresetModel.fromDb(List<Map<String, dynamic>> folderData, List<Map<String, dynamic>>timerData) {
    return PresetModel.list(folderData, timerData);
  }
}
