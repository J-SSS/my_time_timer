import 'package:flutter/material.dart';

class CustomDialog {
  static void show(BuildContext context, Size safeSize) {
    showDialog(
      context: context,
      barrierDismissible: true, // 배경 터치로 닫기 여부
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: EdgeInsets.all(10), // 기본값 변경 가능
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Container(
            width: safeSize.width * 0.8,
            height: safeSize.height * 0.5,
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // 타이틀과 아이콘 영역
                Row(
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
                const SizedBox(height: 16.0),
                // 본문 2:1 비율 분할 (가로로 분할)
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Container(
                          color: Colors.blue.shade100,
                          child: const Center(
                            child: Text(
                              '왼쪽(2)',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          color: Colors.blue.shade200,
                          child: const Center(
                            child: Text(
                              '오른쪽(1)',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16.0),
                // 닫기 버튼
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); // 다이얼로그 닫기
                    },
                    child: const Text('닫기'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );


    // showDialog(
    //   context: context,
    //   builder: (BuildContext context) {
    //     return AlertDialog(
    //       title: Text(
    //         "색상선택",
    //         style: TextStyle(
    //           color: Colors.blueGrey, // 텍스트 색상
    //           fontSize: 20, // 텍스트 크기
    //           fontWeight: FontWeight.w700, // 텍스트 두께
    //         ),
    //       ),
    //       content: Row(
    //         children: [
    //           Container(
    //             width: safeSize.width * 0.2,
    //             color: Colors.cyan,
    //             child: GridView.builder(
    //               shrinkWrap: true,
    //               gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    //                 crossAxisCount: 3,
    //                 crossAxisSpacing: 8.0,
    //                 mainAxisSpacing: 8.0,
    //               ),
    //               itemCount: 9,
    //               itemBuilder: (BuildContext context, int index) {
    //                 return ElevatedButton(
    //                   onPressed: () {
    //                     // 버튼 클릭 시 수행할 동작
    //                     Navigator.of(context).pop(); // 다이얼로그 닫기
    //                     print('Button $index clicked');
    //                   },
    //                   child: Text('Button $index'),
    //                 );
    //               },
    //             ),
    //           ),
    //           Container(
    //           width: safeSize.width * 0.2,
    //           height: safeSize.height * 0.5,
    //           color: Colors.cyan
    //           )
    //         ],
    //       ),
    //     );
    //   },
    // );
  }
}