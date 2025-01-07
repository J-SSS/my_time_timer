import 'package:flutter/material.dart';
import 'package:my_time_timer/provider/create_timer_controller.dart';
import 'package:provider/provider.dart';
import '../../provider/app_config_controller.dart';
import '../../utils/common_values.dart';


class SelectColorDialog {
  static void show(BuildContext context, Size safeSize) {
    double dialogInnerPadding = safeSize.width * 0.8 * 0.05;
    double dialogSafeWidth = safeSize.width * 0.8 - safeSize.width * 0.8 * 0.1;
    double dialogSafeHeight = safeSize.height * 0.7 * 0.8 - safeSize.width * 0.8 * 0.1;

    showDialog( // 여기서부터 리빌드됨
      context: context,
      barrierDismissible: false, // 배경 터치로 닫기 여부
      builder: (BuildContext context) {

      int size  = context.select((CreateTimerController T) => T.timerColorListSize);
      // List<int> items = context.read<AppConfigController>().timerColorList;
      List<Map<String,String>> colorData = context.read<CreateTimerController>().timerColorData;
      // List<Map<String,String>> colorData = context.select((AppConfigController T) => T.timerColorListSize);

        return Dialog(
          insetPadding: const EdgeInsets.all(0), // 기본값 변경 가능
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Container(
            width: safeSize.width * 0.8,
            height: safeSize.height * 0.7 * 0.8,
            padding: EdgeInsets.all(dialogInnerPadding),
            child: Column(
              children: [
                Container(
                  color: Colors.green.withOpacity(0.1),
                  height: dialogSafeHeight * 0.1,
                  child: Row(
                    // 타이틀과 아이콘 영역
                    children: const [
                      Icon(Icons.colorize_outlined),
                      SizedBox(width: 8.0),
                      Text(
                        "색상선택",
                        style: TextStyle(
                          color: Colors.blueGrey, // 텍스트 색상
                          fontSize: 18, // 텍스트 크기
                          fontWeight: FontWeight.w700, // 텍스트 두께
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Container(
                      color: Colors.transparent,
                      width: dialogSafeWidth * 0.6,
                      height: dialogSafeHeight * 0.8,
                      child: Center(
                          child: GridView.builder(
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 50, // 셀의 최대 너비
                          crossAxisSpacing: 15, // 열 사이 간격
                          mainAxisSpacing: 15, // 행 사이 간격
                          childAspectRatio: 1, // 가로:세로 비율
                        ),
                        itemCount: 9,
                        itemBuilder: (BuildContext context, int index) {
                          return ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: colorList[index], // 배경색
                            ),
                            onPressed: () {
                              if(size < 5){
                                context.read<CreateTimerController>().setTimerColorListSize = index;
                              } else {

                              }
                            },
                            child: null,
                          );
                        },
                      )),
                    ),
                    Container(
                      color: Colors.blue.withOpacity(0.1),
                      width: dialogSafeWidth * 0.4,
                      height: dialogSafeHeight * 0.8,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            for (var data in colorData)
                                _colorBtn(context, data),
                            // if(size < 5){
                            //
                            // } else {
                            //
                            // }
                            // _colorBtn(context),
                            // for (var data in colorData)
                            //     _colorBtn(context, data),
                            //   Text(data['colorIdx'].toString() + data['msg'].toString()), // 리스트의 각 요소를 Text로 변환


                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  color: Colors.green.withOpacity(0.1),
                  height: dialogSafeHeight * 0.1,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: () {
                        context.read<CreateTimerController>().assignTimerUIData();
                        Navigator.pop(context); // 다이얼로그 닫기
                        // Navigator.of(context).pop(); // 다이얼로그 닫기
                      },
                      child: const Text('저장'),
                    ),
                  ),
                )
                // 닫기 버튼
              ],
            ),
          ),
        );
      },
    );
  }

  static Widget _colorBtn(BuildContext context, Map<String,String> data) {
    // print(data);
    // print(data['colorIdx']);
    // print(int.parse(data['colorIdx']!));
    // I/flutter ( 3972): {index: 3, colorIdx: 7, msg: ~100%}
    return Row(
      mainAxisSize: MainAxisSize.min, // Row의 크기를 내용에 맞게 조정
      children: [
        Container(
          width: 75,
          height: 40,
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8), // 텍스트 주변 여백
          decoration: BoxDecoration(
            color: colorList[int.parse(data['colorIdx']!)], // 배경색
            borderRadius: BorderRadius.circular(20), // 타원형 모양
          ),
          child: Text(
            data['msg']!, // 가운데 텍스트
            style: TextStyle(
              color: Colors.white, // 글씨 색
              fontSize: 15,
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            // int trgtIndex = data['index']!
            int trgtIndex = int.parse(data['index']!);
            print(data['index']! + "삭제"); // 클릭 이벤트
            context.read<CreateTimerController>().deleteTimerColorByIndex = trgtIndex;
          },
          child: Icon(
            Icons.close, // X 표시
            color: Colors.blueGrey, // 아이콘 색상
            size: 25,
          ),
        ),
      ],
    );
  }


}
