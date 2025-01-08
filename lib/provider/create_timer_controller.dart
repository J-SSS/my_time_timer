
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateTimerController with ChangeNotifier {

  BuildContext? context;

  Map<String,String> _timerUIData = {};

  /// 시간 단위 (0 : 초, 1 : 분, 2 : 시간)
  int _timeUnit = 0;

  /// 최대 시간
  int _maxTime = 0;

  /// 남은 시간 표시 여부 (0 : 표시안함, 1 : hh:mm:ss, 2 : 00%)
  int _remainTimeStyle = 0;

  /// 무음/진동/알람 (0 : 무음, 1 : 진동, 2 : 소리)
  int _alarmType = 0;

  int _timerColorListSize = 0; /// 타이머 색상 리스트 (최대 5개)
  List<int> _timerColorList = [0]; /// 타이머 색상 리스트 (최대 5개)
  List<Map<String,String>> _timerColorData = [{"colorIdx": "0", "msg": "~100%"}]; /// 타이머 색상 리스트 (최대 5개)


  assignFunc(){
    _timerUIData.addAll({
      "timeUnit" : _timeUnit.toString(),
      "maxTime" : _maxTime.toString(),
      "remainTimeStyle" : _remainTimeStyle.toString(),
      "alarmType" : _alarmType.toString(),
      "timerColorData" : _timerColorData.toString(),
    });
  }

  List<List<String>> _timerColorTextList =
  [
    // [],
    // ["~100%"],
    // ["~100%", "~50%"],
    // [ "~100%", "~66%", "~33%"],
    // [ "~100%", "~75%", "~50%", "~25%"],
    // ["~100%", "~80%", "~60%", "~40%", "~20%"]
    [],
    ["~100%"],
    ["~50%", "~100%"],
    ["~33%", "~66%", "~100%"],
    ["~25%","~50%","~75%", "~100%"],
    ["~20%", "~40%", "~60%", "~80%", "~100%"],
  ];

  get timerColorList => _timerColorList;
  get timerColorListSize => _timerColorListSize;
  get timerColorData => _timerColorData;

  set setTimerColorListSize(int idx){
    _timerColorList.add(idx);
    _timerColorListSize = _timerColorList.length;
    _timerColorData.clear();

    // print(_timerColorList.length);
    // print(_timerColorList);
    print('추가 : $_timerColorList' );
    for (var i = _timerColorList.length - 1; i >= 0; i--) {
      _timerColorData.add({"index" : i.toString(), "colorIdx" : _timerColorList[i].toString(), "msg" : _timerColorTextList[_timerColorListSize][i]});

      // print(_timerColorData[i]);
    }

    // print(this._timerColorListSize);
    // this._timerColorList.add = val;

    notifyListeners();
  }

  set deleteTimerColorByIndex(int idx){
    _timerColorList.removeAt(idx);
    _timerColorListSize = _timerColorList.length;
    _timerColorData.clear();

    // print('삭제 : $_timerColorList' );
    for (var i = _timerColorList.length - 1; i >= 0; i--) {
      _timerColorData.add({"index" : i.toString(), "colorIdx" : _timerColorList[i].toString(), "msg" : _timerColorTextList[_timerColorListSize][i]});
      // print(_timerColorData[i]);
    }
    // print(this._timerColorListSize);
    // this._timerColorList.add = val;
    notifyListeners();
  }

  void assignTimerUIData(){

    print("저장");
    notifyListeners();
  }

  set assignTimerUIData2(int a){

    print("저장");
    notifyListeners();
  }

  /// 타이머 시간 단위
  get timeUnit => _timeUnit;
  set setTimeUnit(int val){
    this._timeUnit = val;
    notifyListeners();
  }

  get maxTime => _maxTime;
  set setMaxTime(int val){
    this._maxTime = val;
    notifyListeners();
  }

  /// 남은 시간 표시 여부
  get remainTimeStyle => _remainTimeStyle;
  set setRemainTimeStyle(int val){
    _remainTimeStyle = val;
    notifyListeners();
  }


}