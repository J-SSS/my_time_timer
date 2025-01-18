
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:my_time_timer/utils/size_util.dart';
import 'dart:async';
import 'dart:math' as math;
import 'package:provider/provider.dart';
import 'package:my_time_timer/my_app.dart';
import 'dart:developer';

import 'package:my_time_timer/provider/app_config_controller.dart';
import 'package:my_time_timer/provider/timer_controller.dart';

/** TextPainter 얻기 */
TextPainter getTextPainter(String text, TextStyle style) {
  // TextSpan 생성
  TextSpan textSpan = TextSpan(text: text, style: style);

  // TextPainter 생성 및 설정
  TextPainter textPainter = TextPainter(
    text: textSpan,
    textDirection: TextDirection.ltr, // 텍스트 방향
  );
  // 텍스트 레이아웃 계산
  textPainter.layout();
  // painter.layout(maxWidth: 200); // 최대 너비를 설정
  return textPainter;
}


TextStyle overlayTextStyle = const TextStyle(color: Colors.white, fontSize: 25 * 1, fontWeight: FontWeight.w800);

OverlayEntry? _overlayEntryTime; // 오버레이를 저장할 변수
Timer? _timerForTime; // 타이머를 저장할 변수
Timer? _overlayEntryTimer; // 타이머를 저장할 변수

/** 설정한 시간을 Overlay 위젯으로 표시 */
void showOverlayText(BuildContext context, Size size, String msg) {
  TextPainter textPainter = getTextPainter("$msg mins",overlayTextStyle);

  // print(textPainter.);
  /* 기존 overlayEntry 있으면 삭제 */
  if(_overlayEntryTime != null){
    _overlayEntryTime?.remove();
    _overlayEntryTime = null;
    _timerForTime?.cancel();
  }

  /* 새 overlayEntry 등록 */
  _overlayEntryTime = OverlayEntry(
    builder: (context) => Center(
      child: Material(
        type: MaterialType.transparency, // 투명한 Material
        child: Container(
          width: size.width * 0.35,
          height: size.height * 0.07,
          decoration: BoxDecoration(
            color: Colors.blueGrey.withOpacity(0.5),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Center(
            child: Text(
              "$msg mins",
              style: overlayTextStyle,
            ),
          ),
        ),
      ),
    ),
  );

  Overlay.of(context).insert(_overlayEntryTime!);
  _timerForTime = Timer(Duration(milliseconds: 500), () {
    _overlayEntryTime?.remove();
    _overlayEntryTime = null;
  });


  // 업데이트 시 `overlayEntry.markNeedsBuild()` 호출
  // overlayEntry.markNeedsBuild();
}


/** 정보를 Overlay 위젯으로 표시 */
void showOverlayInfo(BuildContext context, String msg) {
  TextPainter textPainter = getTextPainter(msg, overlayTextStyle);
  Size textBoxSize = textPainter.size;
  Size size = SizeUtil.get.safeSize;
  /* 기존 overlayEntry 있으면 삭제 */
  if(_overlayEntryTime != null){
    _overlayEntryTime?.remove();
    _overlayEntryTime = null;
    _timerForTime?.cancel();
  }

  /* 새 overlayEntry 등록 */
  _overlayEntryTime = OverlayEntry(
    builder: (context) => Center(
      child: Material( // todo Material 제거해도될듯
        type: MaterialType.transparency, // 투명한 Material
        child: Container(
          width: textBoxSize.width + size.width * 0.07,
          height: textBoxSize.height + size.height * 0.02,
          decoration: BoxDecoration(
            color: Colors.blueGrey.withOpacity(0.5),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Center(
            child: Text(
              msg,
              style: overlayTextStyle,
            ),
          ),
        ),
      ),
    ),
  );

  Overlay.of(context).insert(_overlayEntryTime!);
  _timerForTime = Timer(Duration(milliseconds: 700), () {
    _overlayEntryTime?.remove();
    _overlayEntryTime = null;
  });
}