import 'package:flutter/material.dart';
import 'package:my_time_timer/models/timer_model.dart';
import 'package:my_time_timer/provider/create_timer_controller.dart';
import 'package:provider/provider.dart';
import '../../provider/app_config_controller.dart';
import '../../utils/common_values.dart';
import '../../utils/size_util.dart';


class SelectColorDialog {
  static void show(BuildContext context) {
    Size safeSize = SizeUtil().safeSize;
    double dialogWidth = safeSize.width * 0.8;
    double dialogHeight = safeSize.height * 0.7 * 0.6;
    double dialogInnerPadding = dialogWidth * 0.05;
    double dialogSafeWidth = dialogWidth - safeSize.width * 0.8 * 0.1;
    double dialogSafeHeight = dialogHeight - safeSize.width * 0.8 * 0.1;


    showDialog( // 여기서부터 리빌드됨
      context: context,
      barrierDismissible: false, // 배경 터치로 닫기 여부
      builder: (BuildContext context) {

      List<Map<String,String>> colorData = context.select((CreateTimerController T) => T.timerColorData);
      int size  = colorData.length;

        return Dialog(
          insetPadding: const EdgeInsets.all(0), // 기본값 변경 가능
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Container(
            width: dialogWidth,
            height: dialogHeight,
            padding: EdgeInsets.all(dialogInnerPadding),
            child: Column(
              children: [
                SizedBox(
                  height: dialogSafeHeight * 0.1,
                  child: Row(
                    // 타이틀과 아이콘 영역
                    children: [
                      // Image.asset(
                      //   'assets/icon/btn_color.png',
                      //   // width: 30,
                      //   // height: 30,
                      // ),
                      const Icon(Icons.palette_outlined),
                      const SizedBox(width: 8.0),
                      const Text(
                        "타이머 색상",
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
                                context.read<CreateTimerController>().setTimerColorList = index;
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
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  color: Colors.blueGrey.withOpacity(0.1),
                  height: dialogSafeHeight * 0.1,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: () {
                        context.read<CreateTimerController>().refreshTimerModelWithColor();
                        Navigator.pop(context); // 다이얼로그 닫기
                      },
                      child: const Text('SAVE'),
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

  static Widget _colorBtn(BuildContext context, Map<String,String?> data) {
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
