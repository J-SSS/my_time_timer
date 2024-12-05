import 'package:flutter/material.dart';
import 'package:my_time_timer/screen/setting_screen.dart';


class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Size mainSize;

  MyAppBar({required this.mainSize, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text('My Time Timer'),
      centerTitle: true,
      toolbarHeight: mainSize.height / 10,
      actions: [
        IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SettingScreen()),
            );
          },
          icon: Icon(Icons.settings),
          color: Colors.grey,
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(mainSize.height / 10);
}