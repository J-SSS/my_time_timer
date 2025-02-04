import 'package:flutter/material.dart';

import '../manager/app_manager.dart';

/// SizeUtil class
///  - 중복된 MediaQuery 인스턴스 생성 방지
///  - [my_app.dart] 에서 초기화


class SizeUtil {
  SizeUtil._()
      :param = 1; // private 생성자

  static SizeUtil? _instance;

  factory SizeUtil() {
    _instance ??= SizeUtil._();
    return _instance!;
  }

  final int param;
  late double statusBarHeight; // Safe Area 상단 Inset
  late double bottomInset; // Safe Area 하단 Inset
  late double responsiveBottomInset; // 반응형 하단 Safe Area 하단 Inset
  late MediaQueryData mQ;

  late Size size; // 디바이스 사이즈
  late double dw; // 디바이스 넓이
  late double dh; // 디바이스 높이

  late Size safeSize;//	안전 영역 사이즈
  late double sw; // 안전 영영 넓이
  late double sh; // 안전 영역 높이


  late Orientation orientation;//	화면 방향 (Orientation.portrait 또는 Orientation.landscape).
  late EdgeInsets padding;//	디바이스의 안전 영역 패딩 (예: 노치 영역, 상태바, 하단 패딩 등).
  late double devicePixelRatio;//	픽셀 밀도 (1dp가 몇 픽셀인지).
  late TextScaler textScaler;//	시스템에서 설정된 텍스트 스케일 값.
  late Brightness platformBrightness;//	시스템의 현재 밝기 모드 (Brightness.light 또는 Brightness.dark).


  // 자주 쓰는 값
  late double sh01;
  late double sh05;
  late double sh075;
  late double sh10;
  late double sh15;
  late double sh20;
  late double sh65;
  late double sh70;
  late double sh75;
  late double sh80;
  late double sh85;
  late double sh90;

  // 자주 쓰는 값
  late double sw05;
  late double sw075;
  late double sw10;
  late double sw20;
  late double sw70;
  late double sw80;
  late double sw90;


  // 비율로 처리했을 때 높이 넓이. (375 * 812) 기준
  double ratioHeight(double givenHeight) => (givenHeight / 375) * 375;
  double rationWidth(double givenWidth) => (givenWidth / 812) * 812;

  // 초기화 구문
  void init(BuildContext context) {
    AppManager.log('SizeUtil 초기화', type : 'S');
    // final bool isTablet = mQ.size.width > 600;
    // dW = isTablet ? 375 : mQ.size.width;
    // dH = isTablet ? 812 : mQ.size.height;

    mQ = MediaQuery.of(context);

    print(mQ.toString());
    statusBarHeight = mQ.padding.top;
    bottomInset = mQ.padding.bottom;
    responsiveBottomInset =  mQ.padding.bottom == 0 ? 16 : mQ.padding.bottom;

    print(AppBar().preferredSize); // 별도 설정 안 할 경우 기본 사이즈


    // 디바이스 크기
    size = mQ.size;
    dw = mQ.size.width;
    dh = mQ.size.height;

    // 안전영역 계산
    sh = mQ.size.height - mQ.padding.top - mQ.padding.bottom;
    sw = mQ.size.width - mQ.padding.left - mQ.padding.right;
    safeSize = Size(sw, sh);

    sh01 = sh * 0.01;
    sh05 = sh * 0.05;
    sh075 = sh * 0.075;
    sh10 = sh * 0.1;
    sh15 = sh * 0.15;
    sh20 = sh * 0.2;
    sh65 = sh * 0.65;
    sh70 = sh * 0.7;
    sh75 = sh * 0.75;
    sh80 = sh * 0.8;
    sh85 = sh * 0.85;
    sh90 = sh * 0.9;

    sw05 = sw * 0.05;
    sw075 = sw * 0.075;
    sw10 = sw * 0.1;
    sw20 = sw * 0.2;
    sw70 = sw * 0.7;
    sw80 = sw * 0.8;
    sw90 = sw * 0.9;

    // Orientation.portrait: 세로 방향, Orientation.landscape: 가로 방향
    if(mQ.orientation ==  Orientation.portrait){ // todo 가로세로별 계산도 필요 시 추가
      // this.painterSize = mediaQuery.size.width * 0.85;
    } else {
      // this.painterSize = mediaQuery.size.height * 0.85;
    }


  }
  // static get layout => _instance;
  // static get get => SizeUtil();
  // static final SizeUtil to = SizeUtil._();
  // static final SizeUtil layout = SizeUtil._();
  // static final SizeUtil? layout = SizeUtil()._instance;
}

// 1. 모바일 디바이스의 해상도 표준
// 많은 디자이너가 모바일 UI 디자인을 할 때 가로 길이(예: 360px, 375px)를 기준으로 잡아요.
// 이는 안드로이드/아이폰이 서로 다른 화면 비율을 갖더라도, 가로 폭이 UI 구조상 더 중요한 기준이 되기 때문이에요.
// 세로 높이(스크롤)보다 가로 폭이 고정적인 느낌으로 레이아웃을 잡기 쉽습니다.
// 예: Material Design 가이드
// 구글 Material Design에서도 레이아웃 그리드를 설계할 때 디바이스 너비를 기준으로 단계별 규칙을 제시해요.


// .w : 너비를 기준으로 배율을 적용한다.
// .h : 높이를 기준으로 배율을 적용한다.
// .r : 너비와 높이 중 작은 값으로 배율을 적용한다.
// .sp : 화면 사이즈를 기준으로 font-size에 배율을 적용한다.
//
//  
// 그 외에도 sw, sh 라는 속성도 있다.
//
// .sw : screen width0.3.sw 와 같이 사용할 수 있고, 이는 기기 너비의 30%를 의미한다.
// .sh : screen height0.3.sh 와 같이 사용할 수 있고, 이는 기기 높이의 30%를 의미한다.
//
// 실제 사용을 할 때에는 w, h, r, sp 를 주로 사용하고 sw와 sh는 잘 사용하지 않게 된다.
// sw, sh로 화면 구성을 할 생각이었다면 굳이 ScreenUtil을 가져오지 않고 MediaQuery를 쓰면 되기 때문이다.
// 출처: https://noguen.com/137 [NOGUEN 블로그:티스토리]
// fontSize.sp	기준 화면 대비 비율로 폰트 크기 계산
// radius.r	반응형 반지름, 여백, 패딩 계산
// ScreenUtil().screenWidth	현재 디바이스의 실제 화면 너비(px)
// ScreenUtil().screenHeight	현재 디바이스의 실제 화면 높이(px)
// ScreenUtil().scaleWidth	너비 비율 (기준 크기 대비 스케일)
// ScreenUtil().scaleHeight	높이 비율 (기준 크기 대비 스케일)
// width: ScreenUtil().setWidth(50),
// height:ScreenUtil().setHeight(200),
// fontsize:ScreenUtil().setSp(15),
//
// width: 50.w,
// height: 200.h
// fontsize: 15.sp
