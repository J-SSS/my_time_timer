import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:my_time_timer/models/group_model.dart';
import 'package:my_time_timer/models/timer_model.dart';

/// mft_group 및 mft_timer 테이블을 맵핑하기 위한 Model
class PresetModel {
  Map<int, GroupModel> groupMap = {};

  PresetModel._(this.groupMap);

  factory PresetModel.fromDb(List<Map<String, dynamic>> groupDataList, List<Map<String, dynamic>> timerDataList) {
    Map<int, GroupModel> groupMap = {};

    for (var groupData in groupDataList) {
      GroupModel groupModel = GroupModel.fromDb(groupData);
      int groupId = groupModel.groupId;
      groupMap[groupId] = groupModel;
    }

    for (var timerData in timerDataList) {
      TimerModel timerModel = TimerModel.fromDb(timerData);
      int groupId = timerModel.groupId;
      groupMap[groupId]?.timerList.add(timerModel);
    }

    // todo sortOrder에 따른 정렬 추가해야함
    return PresetModel._(groupMap);
  }
}
