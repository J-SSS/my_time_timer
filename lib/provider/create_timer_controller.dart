
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:my_time_timer/models/timer_model.dart';
import 'package:provider/provider.dart';

class CreateTimerController with ChangeNotifier {
  BuildContext? context;

  int groupId = 0;

  TimerModel? _timerModel;


  final List<List<String>> _timerColorTextList =
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


  List<int> _timerColorList = [0];
  List<Map<String,String>> _timerColorData = [{"colorIdx": "0", "msg": "~100%"}];

  get timerModel {
    _timerModel ??= TimerModel();
    return _timerModel;
  }

  set setTimerModel(TimerModel model) {
    _timerModel = model;
    // todo 컬러데이터 초기화 로직 추가
  }


  /// TimerModel 갱신(timerColorList 만)
  void refreshTimerModelWithColor(){
    _timerModel = _timerModel?.copyWith(timerColorList: _timerColorList);
    notifyListeners();
  }

  /// TimerModel 갱신
  void refreshTimerModel(TimerModel model){
    _timerModel = model;
    notifyListeners();
  }

  get timerColorData => _timerColorData;

  get timerColorList => _timerColorList;

  /// timerColorList에 값을 추가한다
  set setTimerColorList(int idx){
    List<Map<String,String>> newList = [];
    _timerColorList.add(idx);

    for (var i = 0; i < _timerColorList.length; i++) {
      newList.add({"index" : i.toString(), "colorIdx" : _timerColorList[i].toString(), "msg" : _timerColorTextList[_timerColorList.length][i]});
    }
    _timerColorData = newList;
    notifyListeners();
  }

  /// timerColorList에서 값을 삭제한다
  set deleteTimerColorByIndex(int idx){
    List<Map<String,String>> newList = [];
    _timerColorList.removeAt(idx);

    for (var i = 0; i < _timerColorList.length; i++) {
      newList.add({"index" : i.toString(), "colorIdx" : _timerColorList[i].toString(), "msg" : _timerColorTextList[_timerColorList.length][i]});
    }
    _timerColorData = newList;
    notifyListeners();

    notifyListeners();
  }
}