import 'package:flutter/material.dart';
import 'package:flutter_icons_null_safety/flutter_icons_null_safety.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_time_timer/models/group_model.dart';
import 'package:my_time_timer/models/preset_model.dart';
import 'package:my_time_timer/screen/select_theme_screen.dart';
import 'package:my_time_timer/utils/size_util.dart';
import 'package:my_time_timer/widgets/preset_toolbar.dart';
import 'package:provider/provider.dart';
import 'package:my_time_timer/viewModels/timer_view_model.dart';

import '../provider/app_config_controller.dart';
import '../utils/timer_utils.dart';
import '../widgets/preset_list.dart';

class PresetScreen extends StatefulWidget {
  const PresetScreen({super.key});

  @override
  State<PresetScreen> createState() => _PresetScreenState();
}

class _PresetScreenState extends State<PresetScreen> {

  final TextEditingController _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
  // textFormField(
  // controller: _controller,
  // validator: (value) {
  // if (value == null || value.isEmpty) {
  // return 'Please enter some text';
  // }
  // return null;
  // },


  @override
  @override
  Widget build(BuildContext context) {
    // PresetModel presetModel = context.read<TimerViewModel>().presetModel!;
    PresetModel presetModel = context.select((TimerViewModel T) => T.presetModel!); // select는 여기서만 해주면 될듯?

    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
        body: SafeArea(child: Column(
          children: [
            Container(
              // color: Colors.green.withOpacity(0.5),
              height: SizeUtil.get.sh075,
              child: PresetToolbar(),
            ),
            SizedBox(
                height: SizeUtil.get.sh85,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: SizeUtil().sh01, horizontal: 0),
                  child: PresetList(),
                ),
                // child: PresetList()
            ),
            SizedBox(
              // color: Colors.green.withOpacity(0.05),
              height: SizeUtil.get.sh075,
              width: SizeUtil().sw,

              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                height: SizeUtil.get.sh075/2,
                alignment: Alignment.bottomCenter,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blueGrey.withOpacity(0.3),
                      spreadRadius: 3,
                      blurRadius: 1,
                      offset: const Offset(0, -3),
                    ),
                  ],
                ),
              ),
              )



            )
          ],
        )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showCreateGroupPopup(context);
          print('Custom FAB clicked!');
        },
        tooltip: 'Add Group',
        shape: CircleBorder(),
        child: Icon(MaterialCommunityIcons.folder_plus,size: SizeUtil().sh075/2,color: Colors.white,),
        backgroundColor: Colors.blueGrey, // 배경색
        foregroundColor: Colors.white, // 아이콘 색
        elevation: 5.0,
      ),

    );
  }

  void _showCreateGroupPopup(BuildContext context) {
    _textController.text = '';
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
                  GroupModel model = GroupModel(getUtc(), _textController.text, 0);
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
              child: Text('닫기'),
            ),
          ],
        );
      },
    );
  }
}


