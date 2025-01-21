import 'package:flutter/material.dart';
import 'package:flutter_icons_null_safety/flutter_icons_null_safety.dart';
import 'package:my_time_timer/models/group_model.dart';
import 'package:my_time_timer/models/timer_model.dart';

import 'package:my_time_timer/utils/size_util.dart';
import 'package:provider/provider.dart';

import '../models/preset_model.dart';
import '../screen/select_theme_screen.dart';
import '../viewModels/timer_view_model.dart';

class PresetList extends StatefulWidget {
  const PresetList({super.key});

  @override
  State<PresetList> createState() => _PresetListState();
}

class _PresetListState extends State<PresetList> {
  List<int> expandedKey = [];
  bool isExpanded = false; // ExpansionTile의 초기 상태
  // List<String> items = ['- 피자타입', '- 배터리타입'];

  late PresetModel _presetModel;
  // int _expandedTileIndex = -1; // 현재 열려 있는 타일의 인덱스를 저장
  TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
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
        // children: _folderPresetDb.map((item) {
        children: _presetModel.groupMap.entries.map((ele) {

          GroupModel groupModel = ele.value;
          int folderId = groupModel.groupId;
          String folderName = groupModel.groupName;
          List<TimerModel> timerModelList = groupModel.timerList;

          return ExpansionTile( // todo 사이즈 수정하기
            initiallyExpanded: false, // todo 초기값 수정
            key: Key('$folderId'),
            tilePadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 0.0),
            controlAffinity: ListTileControlAffinity.leading,
            textColor: Colors.blue,
            title: expandedKey.contains(folderId) // 타이틀 부분
                ? Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(folderName),
                Row(
                  children: [
                    SizedBox(
                      width: SizeUtil.get.sh05,
                      height: SizeUtil.get.sh05,
                      child: IconButton(
                          padding: EdgeInsets.all(10.0),
                          onPressed: () {
                            // _showModifyFolderPopup(context, "F", folderId.toString());
                            _showModifyFolderPopup(context, groupModel);
                          },
                          icon: Icon(
                            FontAwesome.pencil_square_o,
                            color: Colors.grey,
                          ),
                          iconSize: 20),
                    ),
                    SizedBox(
                      // 추가 버튼
                      width: 35,
                      height: 35,
                      child: IconButton(
                          padding: EdgeInsets.all(0.0),
                          onPressed: () {
                            _showDeleteFolderPopup(
                                context, "F", folderId.toString());
                          },
                          icon: Icon(
                            FontAwesome.trash,
                            color: Colors.grey,
                          ),
                          iconSize: 20),
                    ),
                  ],
                )
              ],
            ) // 타이틀 부분(열림)
                : Row(mainAxisSize: MainAxisSize.min, children: [
              Text(folderName),
            ]), // 타이틀 부분(닫힘)
            leading: expandedKey.contains(folderId)
                ? Icon(
              MaterialCommunityIcons.folder_open_outline,
              color: Colors.grey,
            )
                : Icon(
              MaterialCommunityIcons.folder_outline,
              color: Colors.grey,
            ),
            onExpansionChanged: (bool expanding) {
              setState(() {
                if (expanding) {
                  expandedKey.add(folderId);
                } else {
                  expandedKey.remove(folderId);
                }
              });
            },
            children: <Widget>[ // 목록의 하위 요소들
                Container( // 추가 버튼
                    height: timerModelList.length.toDouble() * SizeUtil.get.sh075 + 5, // 너무 딱 맞으면 드래그 할 때 오류남
                    width: SizeUtil.get.sw90,
                    decoration: BoxDecoration(
                      borderRadius:
                      BorderRadius.circular(25), // 원하는 곡선의 반지름 값 설정
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 1,
                          offset: Offset(0, 1),
                        ),
                      ],
                    ),
                    child: ReorderableListView(
                    // physics: ClampingScrollPhysics(), // 스크롤 제약 조건 설정
                    // physics: NeverScrollableScrollPhysics(), // 스크롤 제약 조건 설정
                    padding: EdgeInsets.only(left: 16.0),
                    onReorder: (oldIndex, newIndex) {
                      setState(() {
                        if (newIndex > oldIndex) {
                          newIndex -= 1;
                        }
                      });
                    },
                    children: timerModelList.map((ele){ // TimerModel 부분

                      TimerModel timer = ele;
                      int timerId = timer.timerId;
                      String timerName = timer.timerName;

                      return InkWell(
                        key: Key(timerId.toString()),
                        onTap: () {
                          print("SizedBox tapped!");
                        },
                        child: SizedBox(
                            key: Key(timerId.toString()),
                            height: SizeUtil.get.sh075,
                            child: Text(timerName,
                                style: TextStyle(fontSize: 15), textAlign: TextAlign.start)
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
                      // todo folderId 추가
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SelectThemeScreen(safeSize : SizeUtil.get.safeSize)));
                    },
                    icon: Icon(
                      Icons.add,
                      // Icons.add_circle,
                      color: Colors.grey,
                      // size: 23,
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

  void _showDeleteFolderPopup(BuildContext context, String type, String key) {
    bool isFolder = type == "F" ? true : false;

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(isFolder ? '폴더 삭제' : '타이머 삭제'),
            content: Text(
                isFolder ? '폴더에 포함된 타이머 목록이 함께 삭제됩니다.' : '선택한 타이머를 삭제합니다.'),
            actions: [
              ElevatedButton(
                onPressed: () {
                  // context.read<TimerViewModel>().deletePreset(key, 'F');
                  Navigator.of(context).pop(); // 다이얼로그 닫기
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

  // void _showModifyFolderPopup(BuildContext context, String type, String key, [String msg = "!@3"]) {
  void _showModifyFolderPopup(BuildContext context, GroupModel groupModel) {
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