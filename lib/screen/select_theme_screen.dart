import 'package:flutter/material.dart';
import 'package:my_time_timer/provider/timer_controller.dart';
import 'package:my_time_timer/manager/app_manager.dart';
import 'package:my_time_timer/utils/size_util.dart';
import 'package:my_time_timer/utils/timer_utils.dart' as utils;
import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../provider/app_config_controller.dart';
import '../provider/create_timer_controller.dart';
import '../widgets/timer_loader.dart';
import 'create_timer_screen.dart';


class SelectThemeScreen extends StatelessWidget {

  const SelectThemeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AppManager.log("테마선택", type: "B");
    int activeIndex = 0;

    Size safeSize = SizeUtil().safeSize;

    return Scaffold(
      body: SafeArea(child: Column(
        children: [
          Container(
            // color: Colors.cyan.withOpacity(0.1),
            height: SizeUtil().sh10,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical : 0, horizontal : 8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // 버튼이 클릭되었을 때의 동작 추가
                      print('Button clicked!');
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: Text(
                      'All',
                      style: TextStyle(
                        color: Colors.grey, // 텍스트 색상
                        fontSize: 15.0,
                      ),
                    ),
                  ),
                ],),
            ),
          ),
          SizedBox(
            height: SizeUtil().sh80,
            child: Center(
              child: CarouselSlider(
                options: CarouselOptions(
                  // height: safeSize.height * 0.7, // 슬라이더 높이
                  autoPlay: false, // 자동 재생
                  enlargeCenterPage: true, // 현재 페이지 확대
                  aspectRatio: 8 / 10, // CarouselSlider의 높이를 직접 지정하지 않아도, 가로:세로 비율이 유지
                  // viewportFraction: 1, // 한 번에 보이는 화면의 비율
                  viewportFraction: 0.8, // 한 번에 보이는 화면의 비율
                  onPageChanged: (index, reason) {
                    activeIndex = index; // 애니메이션이 끝나고 이벤트 실행됨
                    print(index);
                  },
                ),
                items: [
                  SampleThemeCard(title: '기본형', theme: 'pizza', safeSize: safeSize, isActive : activeIndex == 0),
                  SampleThemeCard(title: '배터리', theme: 'battery', safeSize: safeSize, isActive : activeIndex == 1),
                  SampleThemeCard(title: '기본형2', theme: 'pizzaB', safeSize: safeSize, isActive : activeIndex == 2),
                  // SampleThemeCard(title: '타입D', theme: 'battery', safeSize: safeSize, isActive : activeIndex == 3),
                ],
              ),
            ),
          ),
          Container(
              // color: Colors.green.withOpacity(0.2),
              height: SizeUtil().sh10
          ),
        ],
      ))
      ,
    );
  }
}

class SampleThemeCard extends StatelessWidget {
  final String title;
  final String theme;
  final Size safeSize;
  final bool isActive;

  SampleThemeCard({required this.title, required this.theme, required this.safeSize, required this.isActive});

  @override
  Widget build(BuildContext context) {
    Size cardSize = Size(safeSize.width, safeSize.height * 0.8 * 0.6);

    print('$title, $isActive'); // todo 가운데가 아니라 양옆에서 새로 만들어지는 카드

    return Card(
        elevation: 5,
        child: InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: () {
              context.read<CreateTimerController>().refreshTimerModelWithTheme(theme);
              Navigator.pop(context);
            },
            child: Padding(
              padding: const EdgeInsets.all(30),
              child: Container(
                width: safeSize.width,
                height: safeSize.height * 0.8,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.transparent,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 1, // 상단 위젯: 2 비율
                      child: Text(
                        title,
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueGrey
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 9, // 하단 위젯: 3 비율
                      child: Center(
                          child: TimerLoader().sampleTimerLoader(context, theme, cardSize)
                        //       // child: TimerLoader().timerLoader(context, "battery")
                      ),
                    ),
                  ],
                ),
              ),
            )
        )
    );
  }
}