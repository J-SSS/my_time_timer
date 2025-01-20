import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:my_time_timer/models/folder_model.dart';
import 'package:my_time_timer/models/timer_model.dart';

/// mft_folder 및 mft_timer를 맵핑하기 위한 Model
class PresetModel {
  // late List<FolderModel> folderList;
  Map<int, FolderModel> folderMap = {};

  PresetModel._(this.folderMap);

  factory PresetModel.fromDb(List<Map<String, dynamic>> folderData, List<Map<String, dynamic>>timerData) {
    Map<int, FolderModel> folderMap = {};

    for (var f in folderData) {
      FolderModel folderModel = FolderModel.fromDb(folderData);
      int folderId = folderModel.folderId;
      folderMap[folderId] = folderModel;
    }

    for (var t in timerData) {
      TimerModel timerModel = TimerModel.fromDb(timerData);
      int folderId = timerModel.folderId;
      folderMap[folderId]?.timerList.add(timerModel);
    }


    // todo sortOrder에 따른 정렬 추가해야함
    return PresetModel._(folderMap);
  }
}
