import 'package:my_time_timer/models/timer_model.dart';

/// mft_group 테이블을 맵핑하기 위한 Model
class GroupModel {
  /// 그룹 고유아이디
  late int groupId;
  /// 그룹 이름
  late String groupName;
  /// 그룹 정렬 순서
  late int sortOrder;
  /// 타이머 목록
  List<TimerModel> timerList = [];

  GroupModel(
      this.groupId,
      this.groupName,
      this.sortOrder,
      // this.timerList
      );

  /// 객체를 Map으로 변환
  Map<String, dynamic> toMap() {
    return {
      'groupId': groupId,
      'groupName': groupName,
      'sortOrder': sortOrder,
    };
  }


  factory GroupModel.fromMap(Map<String, dynamic> groupData) {
    return GroupModel(
      groupData['groupId'],
      groupData['groupName'],
      groupData['sortOrder'],
      // folderData['timer_List'],
    );
  }


}
