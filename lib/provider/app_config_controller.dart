
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

  /**
   * 시스템 설정에 따라 텍스트 크기가 변하는 것 막기
   * fontSize: 16 * MediaQuery.of(context).textScaleFactor, // 고정 크기
   */
  // final double statusBarHeight = MediaQuery.of(context).padding.top; // 상태바 높이
  // final double appBarHeight = AppBar().preferredSize.height;         // AppBar 높이
  // final double totalHeight = statusBarHeight + appBarHeight;

  bool isOnTimerBottomViewYn = false;

  set setOnTimerBottomView(bool bool){
    Timer myTimer;
    isOnTimerBottomViewYn = true;
    notifyListeners();

    if (bool) {
      myTimer = Timer(Duration(seconds: 3), () {
        isOnTimerBottomViewYn = false;
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
    _mediaQuery = mediaQuery;
    _size = mediaQuery.size;
    _padding = mediaQuery.padding;

    /*안전영역 계산*/
    _safeHeight = mediaQuery.size.height - mediaQuery.padding.top - mediaQuery.padding.bottom - 56; // 56은 AppBar 기본 높이
    _safeWidth = mediaQuery.size.width - mediaQuery.padding.left - mediaQuery.padding.right;
    _safeSize = Size(_safeWidth,_safeHeight);

    // Orientation.portrait: 세로 방향, Orientation.landscape: 가로 방향
    if(mediaQuery.orientation ==  Orientation.portrait){ // todo 가로세로별 계산도 필요 시 추가
      // this.painterSize = mediaQuery.size.width * 0.85;
    } else {
      // this.painterSize = mediaQuery.size.height * 0.85;
    }
  }
}