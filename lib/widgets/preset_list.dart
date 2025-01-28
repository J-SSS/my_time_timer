import 'package:flutter/material.dart';
import 'package:flutter_icons_null_safety/flutter_icons_null_safety.dart';
import 'package:my_time_timer/models/group_model.dart';
import 'package:my_time_timer/models/timer_model.dart';

import 'package:my_time_timer/utils/size_util.dart';
import 'package:provider/provider.dart';

import '../models/preset_model.dart';
import '../provider/create_timer_controller.dart';
import '../screen/select_theme_screen.dart';
import '../utils/timer_utils.dart';
import '../viewModels/timer_view_model.dart';

class PresetList extends StatefulWidget {
  const PresetList({super.key});

  @override
  State<PresetList> createState() => _PresetListState();
}

class _PresetListState extends State<PresetList> {
  final TextEditingController _textController = TextEditingController();
  List<int> expandedKey = [];
  bool isExpanded = false; // ExpansionTile의 초기 상태

  late PresetModel _presetModel;


  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // FutureBuilder( todo FutureBuilder로 변경하기
    //     future: viewModel.loadUsers(),
    //     builder: (context, snapshot) {
    //       if (snapshot.connectionState == ConnectionState.waiting) {
    //         return CircularProgressIndicator();
    //       }
    //       return
    _presetModel = context.read<TimerViewModel>().presetModel!;

    return ListView(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        // contentPadding :  EdgeInsets.all(0),
        children: _presetModel.groupList.map((ele) {

          GroupModel groupModel = ele;
          int groupId = groupModel.groupId;
          String groupName = groupModel.groupName;
          List<TimerModel> timerModelList = groupModel.timerList;

          return ExpansionTile( // todo 사이즈 수정하기
            initiallyExpanded: false, // todo 초기값 수정
            key: Key('$groupId'),
            tilePadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 0.0),
            controlAffinity: ListTileControlAffinity.leading,
            textColor: Colors.blue,
            title: expandedKey.contains(groupId) // 타이틀 부분
                ? Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(groupName),
                Row(
                  children: [
                    SizedBox(
                      width: SizeUtil.get.sh05,
                      height: SizeUtil.get.sh05,
                      child: groupId != 0 ? IconButton(
                          padding: EdgeInsets.all(10.0),
                          onPressed: () {
                            _showModifyGroupPopup(context, groupModel);
                          },
                          icon: Icon(
                            FontAwesome.pencil_square_o,
                            color: Colors.grey,
                          ),
                          iconSize: 20) : null,
                    ),
                    SizedBox(
                      width: SizeUtil.get.sh05,
                      height: SizeUtil.get.sh05,
                      child: groupId != 0 ? IconButton(
                          padding: EdgeInsets.all(0.0),
                          onPressed: () {
                            _showDeleteGroupPopup(context, groupId);
                          },
                          icon: Icon(
                            FontAwesome.trash,
                            color: Colors.grey,
                          ),
                          iconSize: 20) : IconButton(
                          padding: EdgeInsets.all(10.0),
                          onPressed: () {
                            _showModifyGroupPopup(context, groupModel);
                          },
                          icon: Icon(
                            FontAwesome.pencil_square_o,
                            color: Colors.grey,
                          ),
                          iconSize: 20), // groupId == 0 인 경우 수정버튼, 그 외 삭제버튼
                    ), // 삭제 버튼
                  ],
                )
              ],
            ) // 타이틀 부분(열림)
                : Row(mainAxisSize: MainAxisSize.min, children: [ Text(groupName),]), // 타이틀 부분(닫힘)
            leading: expandedKey.contains(groupId) ? Icon(
              MaterialCommunityIcons.folder_open_outline,
              color: Colors.grey,
            ) : Icon(
              MaterialCommunityIcons.folder_outline,
              color: Colors.grey,
            ),
            onExpansionChanged: (bool expanding) {
              setState(() {
                if (expanding) {
                  expandedKey.add(groupId);
                } else {
                  expandedKey.remove(groupId);
                }
              });
            },
            children: <Widget>[ // 목록의 하위 요소들
                SizedBox( // 이동 가능한 범위 (개별 요소 크기 아님)
                  height: timerModelList.length.toDouble() * SizeUtil.get.sh075 + 5, // 너무 딱 맞으면 드래그 할 때 오류남
                  width: SizeUtil.get.sw90,
                  child: ReorderableListView(
                    // physics: ClampingScrollPhysics(), // 스크롤 제약 조건 설정 찾아보기
                    //   padding: EdgeInsets.only(left: 16.0),
                      proxyDecorator: (child, index, animation) { // 드래그 중 디자인
                        return Material(
                          // 배경이나 그림자를 주고 싶다면 color나 elevation 사용
                          color: Colors.transparent,
                          elevation: 4,
                          borderRadius: BorderRadius.circular(15),
                          child: child,
                        );
                      },
                      onReorder: (oldIndex, newIndex) {
                        setState(() {
                          if (newIndex > oldIndex) {
                            newIndex -= 1;
                          }
                        });
                      },
                      children: timerModelList.map((ele){ // Timer 요소들

                        TimerModel timer = ele;
                        int timerId = timer.timerId;
                        String timerName = timer.timerName;

                        String setupTimeString = parseTimeString(0,timer.setupTime);

                        // print(parseTimeString(0,timer.setupTime));

                        // print(timer.setupTime);

                      return InkWell(
                            key: Key(timerId.toString()),
                            borderRadius : BorderRadius.circular(25), // 원하는 곡선의 반지름 값 설정
                            onTap: () {
                              print("SizedBox tapped!");
                            },
                            child: Container(
                            key: Key(timerId.toString()),
                            margin:  const EdgeInsets.only(bottom: 8), // 마진 줄 수 있음
                            height: SizeUtil.get.sh075,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25), // 원하는 곡선의 반지름 값 설정
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.1),
                                  spreadRadius: 1,
                                  blurRadius: 1,
                                  offset: Offset(0, 1),
                                ),
                              ],
                            ),
                            child: Row(
                              // mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  flex: 4,
                                  child: Text(
                                    setupTimeString,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blueGrey
                                    ),
                                  ),
                                ), // 시간 부분
                                Expanded(
                                  flex: 6, // 상단 위젯: 2 비율
                                  child: Text(
                                    timerName,
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blueGrey
                                    ),
                                  ),
                                ), // 기타 영역
                              ]
                        )
                            )
                        );

                      }).toList() // TimerModel
                  ),
              ),


              SizedBox(
                height: SizeUtil.get.sh05 / 3,
              ), // 추가 버튼 상단 여백
              Container( // 추가 버튼
                  height: SizeUtil.get.sh05,
                  width: SizeUtil.get.sw90,
                  decoration: BoxDecoration(
                    borderRadius:
                    BorderRadius.circular(15), // 원하는 곡선의 반지름 값 설정
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blueGrey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 1,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                  child: IconButton(
                    onPressed: () {
                      context.read<CreateTimerController>().groupId = groupId;
                      Navigator.push(context, MaterialPageRoute(builder: (context) => SelectThemeScreen()));
                    },
                    icon: Icon(
                      Icons.add,
                      color: Colors.grey,
                      size: SizeUtil.get.sw05,
                    ),
                  )), // 추가 버튼
              SizedBox(
                height: SizeUtil.get.sh05 / 3,
              ) // 추가 버튼 하단 여백
            ],
          );
        }).toList() // GroupModel
    );
  }

  /// mft_group에서 그룹을 삭제한다
  void _showDeleteGroupPopup(BuildContext context, int groupId) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('그룹 삭제'),
            content: Text('그룹에 포함된 타이머가 함께 삭제됩니다.'),
            actions: [
              ElevatedButton(
                onPressed: () {
                  context.read<TimerViewModel>().deleteGroup(groupId);
                  Navigator.pop(context);
                },
                child: Text('삭제'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // 다이얼로그 닫기
                },
                child: Text('취소'),
              ),
            ],
          );
        });
  }

  void _showModifyGroupPopup(BuildContext context, GroupModel groupModel) {
    // bool isFolder = type == "F" ? true : false;
    _textController.text = "123";
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('그룹 수정'),
          content: TextField(
            controller: _textController,
            decoration: InputDecoration(
              hintText: '그룹 이름을 입력하세요.',
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                // context.read<TimerViewModel>().addPreset(_textController.text, 'F');
              },
              child: Text('수정'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // 다이얼로그 닫기
              },
              child: Text('닫기'),
            ),
          ],
        );
      },
    );
  }
}