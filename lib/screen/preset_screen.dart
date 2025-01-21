import 'package:flutter/material.dart';
import 'package:flutter_icons_null_safety/flutter_icons_null_safety.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_time_timer/models/group_model.dart';
import 'package:my_time_timer/models/preset_model.dart';
import 'package:my_time_timer/screen/select_theme_screen.dart';
import 'package:my_time_timer/utils/size_util.dart';
import 'package:provider/provider.dart';
import 'package:my_time_timer/viewModels/timer_view_model.dart';

import '../provider/app_config_controller.dart';
import '../widgets/preset_list.dart';

class PresetScreen extends StatefulWidget {
  const PresetScreen({super.key});

  @override
  State<PresetScreen> createState() => _PresetScreenState();
}

class _PresetScreenState extends State<PresetScreen> {

  TextEditingController _textController = TextEditingController();

  @override
  @override
  Widget build(BuildContext context) {
    PresetModel presetModel = context.read<TimerViewModel>().presetModel!;

    int? newSortOrder = 0;
    presetModel.groupMap.entries.map((e){
      if(newSortOrder! < newSortOrder!)
        newSortOrder = e.value.sortOrder;
    });
    newSortOrder = newSortOrder! + 1;

    GroupModel groupModel = GroupModel(1, "새 그룹", newSortOrder);

    // print(presetModel);

    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text('List'),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _showCreateGroupPopup(context,groupModel);
            print('Custom FAB clicked!');
          },
          tooltip: 'Add Item',
          child: Icon(Icons.add),
          backgroundColor: Colors.blueGrey,
          // 배경색
          foregroundColor: Colors.white,
          // 아이콘 색
          elevation: 5.0, // 그림자 높이
        ),
        body: Column(
          children: [
            SizedBox(
                height: SizeUtil.get.sh90,
                child: PresetList()
            ),
            Container(
              color: Colors.green.withOpacity(0.1),
              height: SizeUtil.get.sh10,
            )
          ],
        )
    );
  }



  void _showCreateGroupPopup(BuildContext context, GroupModel model) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('그룹 생성'),
          content: TextField(
            controller: _textController,
            decoration: InputDecoration(
              hintText: '그룹 이름을 입력하세요.',
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                if (!(_textController.text ?? '').isNotEmpty) {
                  Fluttertoast.showToast(
                    msg: "그룹 이름을 입력하세요",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    fontSize: 16.0,
                  );
                } else {
                  int unixTimeInSeconds = DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000;
                  print(unixTimeInSeconds); // 예: 1672531200
                  model.groupName = _textController.text;
                  context.read<TimerViewModel>().createGroup(model);
                  Navigator.pop(context);
                }
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


