import 'package:flutter/cupertino.dart';

import '../../../util/db_util.dart';
import '../../index/widget/item_single_diary_widget.dart';

class DiaryListWidget {
  // 全部日记列表
  static Widget diaryList(List<DiaryEntity> allDiary) {
    // 查询的日志猎豹是否为空
    if (allDiary == [] || allDiary.isEmpty) {
      return Container(
        child: Center(child: Text("暂无数据"),),
      );
    }
    // 遍历数据
    List<Widget> allDiaryWidget = [];
    for (int i = 0; i < allDiary.length; i++) {
      allDiaryWidget.add(ItemSingleDiaryWidget(
        diary: allDiary[i],
      ));
    }
    return SingleChildScrollView(
      child: Column(
        children: allDiaryWidget,
      ),
    );

  }
}
