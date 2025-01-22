import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:my_time_timer/models/group_model.dart';
import 'package:my_time_timer/models/timer_model.dart';

/// mft_group 및 mft_timer 테이블을 맵핑하기 위한 Model
class PresetModel {
  List<GroupModel> groupList = [];

  PresetModel._(this.groupList);

  factory PresetModel.fromMap(List<Map<String, dynamic>> groupDataList, List<Map<String, dynamic>> timerDataList) {
    List<GroupModel> groupList = [];

    // todo 불변이라 sort 안돼서 리스트 복사 후 사용해야할듯함
    // groupDataList.sort((a, b) => a['sortOrder'].compareTo(b['sortOrder']));

    for (var groupData in groupDataList) {
      GroupModel groupModel = GroupModel.fromMap(groupData);
      int groupId = groupModel.groupId;

      List<Map<String, dynamic>> filteredList = timerDataList.where((ele) => ele['groupId'] == groupId).toList();
      filteredList.sort((a, b) => a['sortOrder'].compareTo(b['sortOrder']));
      filteredList.forEach((ele){groupModel.timerList.add(TimerModel.fromMap(ele));});

      groupList.add(groupModel);
    }

    return PresetModel._(groupList);
  }
}
