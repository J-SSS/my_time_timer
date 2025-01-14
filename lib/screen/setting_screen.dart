import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_time_timer/viewModels/timer_view_model.dart';

import '../utils/db_manager.dart';

class SettingScreen extends StatefulWidget {
  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  List<bool> switchValues = List.generate(10, (index) => false);
  final dbManager = DbManager.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('앱 설정'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    // '남은 시간을 가득 찬 상태로 타이머 시작',
                    // '타이머 시작시 남은 시간으로 화면 채우기',
                    '가득 찬 상태로 타이머 시작',
                    // '남은 시간으로 타이머 채우기',
                    // '항상 최대 영역으로 타이머 시작',
                    // '항상 최대 영역으로 타이머 시작',
                    // '타이머 시작 시 영역 기준 (설정 시간 / 기본값)',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                Switch(
                  value: false,
                  onChanged: (value) {
                    setState(() {
                      // switchValues[index] = value;
                    });
                  },
                ),
              ],
            ),
            Divider(),
            Row(
              children: [
                Expanded(
                  child: Text(
                    '타이머 작동 중 상단 바 숨김',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                Switch(
                  value: false,
                  onChanged: (value) {
                    setState(() {
                      // switchValues[index] = value;
                    });
                  },
                ),
              ],
            ),
            Divider(),
            Row(
              children: [
                Expanded(
                  child: Text(
                    '백그라운드에서도 실행',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                Switch(
                  value: false,
                  onChanged: (value) {
                    setState(() {
                      // switchValues[index] = value;
                    });
                  },
                ),
              ],
            ),
            Divider(),
            TextButton(onPressed: () async {
              // print(await dbManager.resetData());
                await dbManager.resetData();
              print('DB 삭제 완료');
                // context.read<TimerViewModel>().clearPreset();
            }, child: Text('설정 초기화'))
          ]
        ),
      ),
    );
  }
}