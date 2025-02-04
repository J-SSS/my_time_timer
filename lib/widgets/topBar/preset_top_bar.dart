import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons_null_safety/flutter_icons_null_safety.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../models/timer_model.dart';
import '../../provider/create_timer_controller.dart';
import '../../utils/app_utils.dart';
import '../../utils/common_values.dart';
import '../../utils/size_util.dart';
import '../dialog/select_color_dialog.dart';
import '../dialog/select_time_config_dialog.dart';


class PresetToolbar extends StatefulWidget {
  const PresetToolbar({Key? key}) : super(key: key);

  @override
  State<PresetToolbar> createState() => _PresetToolbarState();
}

class _PresetToolbarState extends State<PresetToolbar> {


  String _selectedTimeText = "";


  @override
  Widget build(BuildContext context) {

    TimerModel timerModel = context.select((CreateTimerController T) => T.timerModel);

    return Container(
          width: SizeUtil().sw,
          height: SizeUtil().sh075,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
                color: Colors.blueGrey.withOpacity(0.3), width: 0.5),
            boxShadow: [
              BoxShadow(
                color: Colors.blueGrey.withOpacity(0.3),
                spreadRadius: 3,
                blurRadius: 1,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child : Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: SizeUtil().sh075,
                height: SizeUtil().sh075,
                child: Icon(MaterialCommunityIcons.format_list_bulleted_type,size: SizeUtil().sh075/2,color: Colors.blueGrey,),
              ),

              Align(child: Text("Timer Groups",style: TextStyle(fontSize: SizeUtil().sh075/2, fontWeight: FontWeight.bold, color: Colors.blueGrey), textAlign: TextAlign.center),),
              SizedBox(
                width: SizeUtil().sh075,
                height: SizeUtil().sh075,
                // child: Icon(MaterialCommunityIcons.format_list_bulleted_type,size: SizeUtil().sh075/2,color: Colors.blueGrey,),
              ),

              // TextButton( /** 우 버튼 */
              //     onPressed: () {
              //     },
              //     style: ElevatedButton.styleFrom(
              //       shape: const CircleBorder(),
              //       padding: const EdgeInsets.all(0.0),
              //     ),
              //     child: Icon(MaterialCommunityIcons.wrench,size: SizeUtil().sh075/2,color: Colors.blueGrey,),
              // ),

            ],
          )
      );
  }
}