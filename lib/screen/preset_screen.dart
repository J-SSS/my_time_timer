import 'package:flutter/material.dart';
import 'package:flutter_icons_null_safety/flutter_icons_null_safety.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_time_timer/screen/select_theme_screen.dart';
import 'package:my_time_timer/utils/size_util.dart';
import 'package:provider/provider.dart';
import 'package:my_time_timer/viewModels/timer_view_model.dart';

import '../provider/app_config_controller.dart';
import '../widgets/preset_list.dart';

class PresetScreen extends StatelessWidget {
  // PresetScreen({super.key});

  TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    // context.read<TimerViewModel>().loadPresetDb();

    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
        title: Text('List'),
        actions: [
          IconButton(
            onPressed: () {
              _showCreateFolderPopup(context);
            },
            icon: Icon(
              MaterialCommunityIcons.folder_plus_outline,
              size: 25,
              color: Colors.grey,
            )),
        ],
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

  void _showCreateFolderPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('폴더 생성'),
          content: TextField(
            controller: _textController,
            decoration: InputDecoration(
              hintText: '폴더 이름을 입력하세요.',
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                if (!(_textController.text ?? '').isNotEmpty) {
                  Fluttertoast.showToast(
                    msg: "폴더 이름을 입력하세요",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    fontSize: 16.0,
                  );
                } else {
                  // context.read<TimerViewModel>().addPreset(_textController.text, 'F');
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

