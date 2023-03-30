import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../constants.dart';
import '../../../../util/datetime_util.dart';

class CalenderWidget extends StatefulWidget {
  const CalenderWidget(
      {Key? key, required this.markedDate, required this.onDateChanged})
      : super(key: key);
  final Set<DateTime> markedDate;
  final Function onDateChanged;

  @override
  State<StatefulWidget> createState() => _CalenderWidgetState();
}

class _CalenderWidgetState extends State<CalenderWidget> {
  DateTime currentDate = DateTime.now();

  // 跳到上一个月
  void jumpToPreviousMonth() {
    setState(() {
      currentDate = currentDate.subtract(const Duration(days: 31));
    });
    widget.onDateChanged(currentDate);
  }

  // 跳到下一个月
  void jumpToNextMonth() {
    setState(() {
      currentDate = currentDate.add(const Duration(days: 31));
    });
    widget.onDateChanged(currentDate);
  }

  // 年月顶栏
  Widget topBar() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: 20,
          child: CupertinoButton(
            padding: const EdgeInsets.all(0),
            child: const Icon(CupertinoIcons.arrow_left, size: 18),
            onPressed: () {
              jumpToPreviousMonth();
            },
          ),
        ),
        Text(DateTimeUtil.parseMonth(currentDate)),
        SizedBox(
          width: 20,
          child: CupertinoButton(
            padding: const EdgeInsets.all(0),
            child: const Icon(CupertinoIcons.arrow_right, size: 18),
            onPressed: () {
              jumpToNextMonth();
            },
          ),
        ),
      ],
    );
  }

  // 存在日志指示灯
  Widget diaryExistDot() {
    return const SizedBox(
      width: 4,
      height: 4,
      child: CircleAvatar(),
    );
  }

  // 计算并生成单个日期组件
  List<Widget> allDates() {
    int currentDay = currentDate.day;
    List<Widget> returnData = [];
    DateTime singleDate = DateTime(currentDate.year, currentDate.month, 1);
    int month = currentDate.month;
    List<Widget> datesOfThisMonth = [];
    List<DateTime> dateData = [];
    // 上个月日期填充
    for (int i = 0; i < singleDate.weekday; i++) {
      dateData.add(singleDate.subtract(Duration(days: singleDate.weekday - i)));
      datesOfThisMonth.add(
        Expanded(
          child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    dateData[i].day.toString(),
                    style: const TextStyle(
                        fontSize: 15, color: CupertinoColors.inactiveGray),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10)
                ],
              )),
        ),
      );
    }
    // 本月首天
    dateData.add(singleDate);
    // 本月日期填充
    while (singleDate.month == month) {
      DateTime uniqueDate = singleDate;
      datesOfThisMonth.add(
        Expanded(
          child: CupertinoButton(
            padding: const EdgeInsets.all(0),
            child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(5),
                child: CircleAvatar(
                  backgroundColor: currentDay == singleDate.day
                      ? Consts.themeColor
                      : CupertinoColors.white,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(singleDate.day.toString(),
                          style: TextStyle(
                              fontSize: 15,
                              color: currentDay == singleDate.day
                                  ? CupertinoColors.white
                                  : CupertinoColors.black),
                          textAlign: TextAlign.center),
                      widget.markedDate.contains(uniqueDate) &&
                          currentDay != singleDate.day
                          ? diaryExistDot()
                          : const SizedBox(height: 4)
                    ],
                  ),
                )),
            onPressed: () {
              setState(() {
                currentDate = uniqueDate;
              });
              widget.onDateChanged(currentDate);
            },
          ),
        ),
      );
      dateData.add(singleDate.add(const Duration(days: 1)));
      singleDate = singleDate.add(const Duration(days: 1));
    }
    // 下月日期填充
    for (int i = 0; i < 7 - singleDate.weekday; i++) {
      dateData.add(singleDate.add(Duration(days: i)));
      datesOfThisMonth.add(
        Expanded(
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(5),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(dateData[dateData.length - 1].day.toString(),
                      style: const TextStyle(
                          fontSize: 15, color: CupertinoColors.inactiveGray),
                      textAlign: TextAlign.center),
                  const SizedBox(height: 10)
                ]),
          ),
        ),
      );
    }
    // 汇总所有日期
    for (int i = 0; i < datesOfThisMonth.length; i++) {
      returnData.add(datesOfThisMonth[i]);
    }
    return returnData;
  }

  // 生成日期组件矩阵
  List<Widget> allDatesWidget(List<Widget> allDates) {
    List<Widget> allLinesWidgets = [];
    int linesCount = allDates.length ~/ 7;
    for (int i = 0; i < linesCount; i++) {
      List<Widget> singleLineWidgets = [];
      for (int j = 0; j < 7; j++) {
        singleLineWidgets.add(allDates[i * 7 + j]);
      }
      allLinesWidgets.add(Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: singleLineWidgets));
    }
    return allLinesWidgets;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: CupertinoColors.white,
      padding: const EdgeInsets.all(15),
      child: Column(
        children: [
          // 年月顶栏
          topBar(),
          // 分割线
          Container(
            height: 10,
          ),
          // 星期显示标头
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Expanded(
                child: Text('日',
                    style: TextStyle(
                        color: CupertinoColors.placeholderText, fontSize: 15),
                    textAlign: TextAlign.center),
              ),
              Expanded(
                child: Text('一',
                    style: TextStyle(
                        color: CupertinoColors.placeholderText, fontSize: 15),
                    textAlign: TextAlign.center),
              ),
              Expanded(
                child: Text('二',
                    style: TextStyle(
                        color: CupertinoColors.placeholderText, fontSize: 15),
                    textAlign: TextAlign.center),
              ),
              Expanded(
                child: Text('三',
                    style: TextStyle(
                        color: CupertinoColors.placeholderText, fontSize: 15),
                    textAlign: TextAlign.center),
              ),
              Expanded(
                child: Text('四',
                    style: TextStyle(
                        color: CupertinoColors.placeholderText, fontSize: 15),
                    textAlign: TextAlign.center),
              ),
              Expanded(
                child: Text('五',
                    style: TextStyle(
                        color: CupertinoColors.placeholderText, fontSize: 15),
                    textAlign: TextAlign.center),
              ),
              Expanded(
                child: Text('六',
                    style: TextStyle(
                        color: CupertinoColors.placeholderText, fontSize: 15),
                    textAlign: TextAlign.center),
              ),
            ],
          ),
          // 日期矩阵
          Container(
            margin: const EdgeInsets.only(top: 10),
            child: Column(
              children: allDatesWidget(allDates()),
            ),
          )
        ],
      ),
    );
  }
}
