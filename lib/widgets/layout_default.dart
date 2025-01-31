import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_time_timer/utils/size_util.dart';

class LayoutDefault extends StatelessWidget {
  final Widget widget1;
  final Widget widget2;
  final Widget widget3;
  final Widget widget4;

  const LayoutDefault({super.key,
    required this.widget1,
    required this.widget2,
    required this.widget3,
    required this.widget4,});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: SizeUtil().sh075,
          color: Colors.red.withOpacity(0.5),
        ),
        Container(
          height: SizeUtil().sh075,
          color: Colors.red.withOpacity(0.5),
        ),
        Container(
          height: SizeUtil().sh70,
          color: Colors.red.withOpacity(0.5),
        ),
        Container(
          height: SizeUtil().sh15,
          color: Colors.red.withOpacity(0.5),
        ),
      ],
    );
  }
}
