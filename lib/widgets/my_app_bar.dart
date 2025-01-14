import 'package:flutter/material.dart';
import 'package:my_time_timer/screen/preset_screen.dart';
import 'package:my_time_timer/screen/setting_screen.dart';


class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Size safeSize;

  MyAppBar({required this.safeSize, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      // title: Text('기본 타이머'),
      centerTitle: true,
      toolbarHeight: 56, // material의 기본 규격
      leading: IconButton(
        icon: const Icon(Icons.menu),
        onPressed: () => {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PresetScreen()), // 프리셋 화면
          )},
      ),
      actions: [
        IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SettingScreen()), // 설정 화면
            );
          },
          icon: Icon(Icons.settings),
          color: Colors.grey,
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56);
}