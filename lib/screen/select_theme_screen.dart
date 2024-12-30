import 'package:flutter/material.dart';
import 'package:my_time_timer/provider/timer_controller.dart';
import 'package:my_time_timer/utils/timer_utils.dart' as utils;
import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../provider/app_config_controller.dart';
import '../widgets/timer_loader.dart';
import 'create_timer_screen.dart';


class SelectThemeScreen extends StatelessWidget {
  final Size safeSize;
  const SelectThemeScreen({super.key, required this.safeSize});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('테마 선택'),
      ),
      body: Column(
        children: [
          SizedBox(
            height: safeSize.height * 0.1,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical : 0, horizontal : 8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
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
            height: safeSize.height * 0.7,
            child: Center(
              child: CarouselSlider(
                options: CarouselOptions(
                  height: safeSize.height * 0.7, // 슬라이더 높이
                  autoPlay: false, // 자동 재생
                  enlargeCenterPage: true, // 현재 페이지 확대
                  // aspectRatio: 16 / 9, // 슬라이더 비율 todo 이거 뭔지 확인해보기
                  viewportFraction: 0.8, // 한 번에 보이는 화면의 비율
                ),
                items: [
                  // Text('Slide 1', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  // Container(color: Colors.blue, height: 400, child: Center(child: Text('Slide 3'))),
                  SampleThemeWidget(title: '기본형', content: '', safeSize: safeSize),
                  SampleThemeWidget(title: '배터리', content: '', safeSize: safeSize),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SampleThemeWidget extends StatelessWidget {
  final String title;
  final String content;
  final Size safeSize;

  SampleThemeWidget({required this.title, required this.content, required this.safeSize});

  @override
  Widget build(BuildContext context) {

    return Card(
        elevation: 5,
        child: InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CreateTimerScreen(safeSize)),
              );
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
                      Text(
                        title,
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueGrey
                        ),
                      ),
                      SizedBox(height: 10),
                      SizedBox(
                          height: safeSize.height * 0.8 * 0.6,
                          child: Center(
                              child: TimerLoader().timerLoader(context, "pizza")
                            // child: TimerLoader().timerLoader(context, "battery")
                          )),
                    ],
                  ),
                ),
            )
        ));
  }
}