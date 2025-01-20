import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:my_time_timer/models/timer_model.dart';

class FolderModel {
  /// 폴더 고유아이디
  late int folderId;
  /// 폴더 이름
  late String folderName;
  /// 폴더 정렬 순서
  int? sortOrder;

  FolderModel();

  factory FolderModel.fromDb(List<Map<String, dynamic>> folderData) {
    return FolderModel();
  }

  late List<TimerModel> timerList;
  // List<Map<String, dynamic>>? _folderPresetDb = []; // 폴더(DB)
  // List<Map<String, dynamic>>? _timerPresetDb = []; // 타이머(DB)
  //
  // get folderPresetDb => _folderPresetDb;
  // get timerPresetDb => _timerPresetDb;
  //
  // FolderModel.list(folderData, timerData){
  //   _folderPresetDb = folderData;
  //   _timerPresetDb = timerData;
  // }
  //
  // /// mft_folder 및 mft_timer 테이블의 모든 데이터를 조회한다.
  // factory FolderModel.fromDb(List<Map<String, dynamic>> folderData, List<Map<String, dynamic>>timerData) {
  //   return FolderModel.list(folderData, timerData);
  // }
}
