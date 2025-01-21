
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:my_time_timer/models/timer_model.dart';
import 'package:provider/provider.dart';

class CreateTimerController with ChangeNotifier {

  BuildContext? context;

  TimerModel? _timerModel;

  get timerModel  {
    return _timerModel ??= TimerModel.dflt();
  }

  void initTimerModel(){
    _timerModel ??= TimerModel.dflt();
  }

  int _timerColorListSize = 0; /// 타이머 색상 리스트 사이즈 (최대 5개)

  void refreshTimerModel(){
    _timerModel = TimerModel.dflt();
  }

  List<List<String>> _timerColorTextList =
  [
    [],
    ["~100%"],
    ["~100%", "~50%"],
    ["~100%", "~66%", "~33%"],
    ["~100%", "~75%", "~50%", "~25%"],
    ["~100%", "~80%", "~60%", "~40%", "~20%"]
    // [],
    // ["~100%"],
    // ["~50%", "~100%"],
    // ["~33%", "~66%", "~100%"],
    // ["~25%","~50%","~75%", "~100%"],
    // ["~20%", "~40%", "~60%", "~80%", "~100%"],
  ];

  get timerColorListSize => _timerColorListSize;
  // get timerColorData => _timerColorData;
  get timerColorData => _timerModel?.timerColorData;

  set setTimerColorListSize(int idx){
    _timerModel?.timerColorList.add(idx);
    _timerModel?.timerColorListSize = _timerModel!.timerColorList.length;
    _timerModel?.timerColorData.clear();
    int size = _timerModel!.timerColorList.length;

    // print('추가 : ${_timerModel?.timerColorList}' );
    for (var i = 0; i < _timerModel!.timerColorList.length; i++) {
      _timerModel?.timerColorData.add({"index" : i.toString(), "colorIdx" : _timerModel?.timerColorList[i].toString(), "msg" : _timerColorTextList[size][i]});
    }
    _timerColorListSize = size; // List의 요소 변경에는 provider가 반응하지 않음

    notifyListeners();
  }

  set deleteTimerColorByIndex(int idx){
    _timerModel?.timerColorList.removeAt(idx);
    _timerModel?.timerColorListSize = _timerModel!.timerColorList.length;
    _timerModel?.timerColorData.clear();

    int size = _timerModel!.timerColorList.length;

    // print('삭제 : $_timerColorList' );
      for (var i = 0; i < _timerModel!.timerColorList.length; i++) {
        _timerModel?.timerColorData.add({"index" : i.toString(), "colorIdx" : _timerModel?.timerColorList[i].toString(), "msg" : _timerColorTextList[size][i]});
    }

    _timerColorListSize = size; // List의 요소 변경에는 provider가 반응하지 않음

    notifyListeners();
  }

  /// 타이머 시간 단위
  get timeUnit => _timerModel?.timeUnit;
  set setTimeUnit(int val){
    _timerModel?.timeUnit = val;
    notifyListeners();
  }

  get maxTime => _timerModel?.maxTime;
  set setMaxTime(int val){
    _timerModel?.maxTime = val;
    notifyListeners();
  }

  /// 남은 시간 표시 여부
  get remainTimeStyle => _timerModel?.remainTimeStyle;
  set setRemainTimeStyle(int val){
    _timerModel?.remainTimeStyle = val;
    notifyListeners();
  }


}