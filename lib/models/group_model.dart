import 'package:my_time_timer/models/timer_model.dart';

/// mft_group 테이블을 맵핑하기 위한 Model
class GroupModel {
  /// 그룹 고유아이디
  late int groupId;
  /// 그룹 이름
  late String groupName;
  /// 그룹 정렬 순서
  int? sortOrder;
  /// 타이머 목록
  List<TimerModel> timerList = [];

  GroupModel(
      this.groupId,
      this.groupName,
      this.sortOrder,
      // this.timerList
      );


  factory GroupModel.fromDb(Map<String, dynamic> groupData) {
    return GroupModel(
      groupData['group_id'],
      groupData['group_name'],
      groupData['sort_order'],
      // folderData['timer_List'],
    );
  }
}
