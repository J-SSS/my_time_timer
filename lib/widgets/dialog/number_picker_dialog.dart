import 'package:flutter/material.dart';
import 'package:my_time_timer/provider/create_timer_controller.dart';
import 'package:my_time_timer/utils/size_util.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:provider/provider.dart';
import '../../provider/app_config_controller.dart';
import '../../utils/common_values.dart';


class NumberPickerDialog {
    void show(BuildContext context) {
      Size safeSize = SizeUtil.get.safeSize;
    double dialogInnerPadding = safeSize.width * 0.8 * 0.05;
    double dialogSafeWidth = safeSize.width * 0.8 - safeSize.width * 0.8 * 0.1;
    double dialogSafeHeight = safeSize.height * 0.7 * 0.8 - safeSize.width * 0.8 * 0.1;

    showDialog( // 여기서부터 리빌드됨
      context: context,
      barrierDismissible: false, // 배경 터치로 닫기 여부
      builder: (BuildContext context) {

      int size  = context.select((CreateTimerController T) => T.timerColorListSize);

      // List<Map<String,String>> colorData = context.read<CreateTimerController>().timerColorData;

      // int timeValue = 1;
      int timeValue  = context.select((CreateTimerController T) => T.maxTime);
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
                      Icon(Icons.timelapse),
                      SizedBox(width: 8.0),
                      Text(
                        "최대 시간 선택",
                        style: TextStyle(
                          color: Colors.blueGrey, // 텍스트 색상
                          fontSize: 18, // 텍스트 크기
                          fontWeight: FontWeight.w700, // 텍스트 두께
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: dialogSafeHeight * 0.8,
                  child: NumberPicker(
                  value: timeValue,
                  minValue: 1,
                  maxValue: 100,
                  onChanged: (value) => context.read<CreateTimerController>().setMaxTime = value
                ),),
                Container(
                  color: Colors.green.withOpacity(0.1),
                  height: dialogSafeHeight * 0.1,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: () {
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

  static Widget _colorBtn(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min, // Row의 크기를 내용에 맞게 조정
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8), // 텍스트 주변 여백
          decoration: BoxDecoration(
            color: Colors.blue, // 배경색
            borderRadius: BorderRadius.circular(30), // 타원형 모양
          ),
          child: Text(
            'Oval Text', // 가운데 텍스트
            style: TextStyle(
              color: Colors.white, // 글씨 색
              fontSize: 16,
            ),
          ),
        ),
        SizedBox(width: 8), // Oval과 X 아이콘 사이의 간격
        GestureDetector(
          onTap: () {
            print('X Icon tapped!'); // 클릭 이벤트
          },
          child: Icon(
            Icons.close, // X 표시
            color: Colors.grey, // 아이콘 색상
          ),
        ),
      ],
    );
  }


}
