import 'package:flutter/material.dart';
import 'package:flutter_icons_null_safety/flutter_icons_null_safety.dart';

import 'package:my_time_timer/utils/size_util.dart';
import 'package:provider/provider.dart';

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
  List<String> items = ['- 피자타입', '- 배터리타입'];

  // int _expandedTileIndex = -1; // 현재 열려 있는 타일의 인덱스를 저장

  TextEditingController _textController = TextEditingController();

  late List<Map<String, dynamic>> _folderPresetDb;
  late List<Map<String, dynamic>> _timerPresetDb;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // todo FutureBuilder로 변경하기
    _folderPresetDb = context.watch<TimerViewModel>().preset!.folderPresetDb;
    _timerPresetDb = context.watch<TimerViewModel>().preset!.timerPresetDb;
    // print('폴더DB : ${_folderPresetDb}');
    // print('타이머Db : ${_timerPresetDb}');

    // _folderPresetDb.forEach((item) {
    //   print('ID: ${item['folder_id']}, Name: ${item['folder_name']}');
    // });

    // FutureBuilder( todo 적용해보기
    //     future: viewModel.loadUsers(),
    //     builder: (context, snapshot) {
    //       if (snapshot.connectionState == ConnectionState.waiting) {
    //         return CircularProgressIndicator();
    //       }
    //       return

    return ListView(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        // contentPadding :  EdgeInsets.all(0),
        children: _folderPresetDb.map((item) {

          int folderId = item['folder_id'];
          String folderName = item['folder_name'];

          // print('$folderName');
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
                            _showModifyFolderPopup(
                                context, "F", folderId.toString());
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
                    height: _timerPresetDb.where((item) {
                          return item['folder_id'] == folderId;
                        }).length.toDouble() * SizeUtil.get.sh075 + 5, // 너무 딱 맞으면 드래그 할 때 오류남
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
                      // print('??');
                      setState(() {
                        if (newIndex > oldIndex) {
                          newIndex -= 1;
                        }
                        final item = items.removeAt(oldIndex);
                        items.insert(newIndex, item);
                      });
                    },
                    children: _timerPresetDb.map((item){

                      // print(folderId);
                      // int folderId = item['timer_id'];
                      int timerId = item['timer_id'];
                      String timerName = item['timer_name'];

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

                    }).toList()
                ),
              ),
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
                  )),
              SizedBox(
                height: SizeUtil.get.sh05 / 3,
              )
            ],
          )
          ;

        }).toList()
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

  void _showModifyFolderPopup(BuildContext context, String type, String key) {
    bool isFolder = type == "F" ? true : false;
    // _textController.text = _folderPreset[key]?['nodeName'];
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('폴더 수정'),
          content: TextField(
            controller: _textController,
            decoration: InputDecoration(
              hintText: '폴더 이름을 입력하세요.',
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                // context.read<TimerViewModel>().addPreset(_textController.text, 'F');
              },
              child: Text('생성'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // 다이얼로그 닫기
              },
              child: Text('취소'),
            ),
          ],
        );
      },
    );
  }
}