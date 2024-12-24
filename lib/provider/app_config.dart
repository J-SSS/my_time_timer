
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class AppConfigController with ChangeNotifier {
  BuildContext? context;

  late MediaQueryData _mediaQuery;
  // late double painterSize;
  late Size _size;
  late EdgeInsets _padding;

  late Size _safeSize;
  late double _safeHeight; // 안전 높이 todo 가로세로 계산 추가 필요
  late double _safeWidth; // 안전 너비 todo 가로세로 계산 추가 필요

  /** MediaQueryData 값
      size	화면의 크기 (Size 객체로 가로와 세로 길이 포함).
      orientation	화면 방향 (Orientation.portrait 또는 Orientation.landscape).
      padding	디바이스의 안전 영역 패딩 (예: 노치 영역, 상태바, 하단 패딩 등).
      devicePixelRatio	픽셀 밀도 (1dp가 몇 픽셀인지).
      textScaleFactor	시스템에서 설정된 텍스트 스케일 값.
      platformBrightness	시스템의 현재 밝기 모드 (Brightness.light 또는 Brightness.dark).
   */

  // final double statusBarHeight = MediaQuery.of(context).padding.top; // 상태바 높이
  // final double appBarHeight = AppBar().preferredSize.height;         // AppBar 높이
  // final double totalHeight = statusBarHeight + appBarHeight;




  bool isOnTimerBottomViewYn = false;

  set setOnTimerBottomView(bool bool){
    Timer myTimer;
    this.isOnTimerBottomViewYn = true;
    notifyListeners();

    if (bool) {
      myTimer = Timer(Duration(seconds: 3), () {
        this.isOnTimerBottomViewYn = false;
        notifyListeners();
      });

      // myTimer.cancel();
    }

  }

  get mediaQuery => _mediaQuery;
  get size => _size;
  get padding => _padding;
  get safeHeight => _safeHeight;
  get safeWidth => _safeWidth;
  get safeSize => _safeSize;

  set setMediaQuery(MediaQueryData mediaQuery){
    if(mediaQuery.orientation ==  Orientation.portrait){ // todo 가로세로별 계산도 추가하기
      // Orientation.portrait: 세로 방향
      // Orientation.landscape: 가로 방향
      // this.painterSize = mediaQuery.size.width * 0.85;
    } else {
      // this.painterSize = mediaQuery.size.height * 0.85;
    }

    this._mediaQuery = mediaQuery; // 쓰는중
    this._size = mediaQuery.size;
    this._padding = mediaQuery.padding;

    /*안전영역 계산*/
    this._safeHeight = mediaQuery.size.height - mediaQuery.padding.top - mediaQuery.padding.bottom - 56; // 56은 AppBar 기본 높이
    this._safeWidth = mediaQuery.size.width;
    // todo 가로세로별 계산도 추가하기

    this._safeSize = Size(_safeHeight,_safeHeight);
  }
}