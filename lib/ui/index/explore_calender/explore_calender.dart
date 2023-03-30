import 'package:flutter/cupertino.dart';

import '../../../util/db_util.dart';
import '../../../util/eventbus_util.dart';
import '../widget/diary_list_widget.dart';
import 'widget/calendar_widget.dart';

class ExploreCalenderPage extends StatefulWidget {
  const ExploreCalenderPage({Key? key}) : super(key: key);

  @override
  State<ExploreCalenderPage> createState() => _ExploreCalenderPageState();
}

class _ExploreCalenderPageState extends State<ExploreCalenderPage> {
  List<Map<String, Object?>> allDiaryRow = [];
  List<DiaryEntity> allDiary = [];
  List<Map<String, Object?>> allDiaryMonthlyRow = [];
  List<DiaryEntity> allDiaryMonthly = [];
  DateTime selectedDate = DateTime.now();
  Set<DateTime> markedDates = {};

  var saveDiaryDoneListener;

  // 日期选择器组件
  Widget calenderSelector() {
    return CalenderWidget(
      markedDate: markedDates,
      onDateChanged: (currentDate) {
        selectedDate = currentDate;
        loadAllDiary();
      },
    );
  }

  // 载入所有日记
  void loadAllDiary() async {
    await DatabaseUtil.instance.openDb();
    // 读取当天的日记
    allDiaryRow = await DatabaseUtil.instance.queryByDate(selectedDate);
    allDiary.clear();
    if (allDiaryRow.isNotEmpty) {
      for (int i = 0; i < allDiaryRow.length; i++) {
        allDiary.add(DiaryEntity().fromMap(allDiaryRow[i]));
      }
    }
    // 读取当月的日记
    allDiaryMonthlyRow = await DatabaseUtil.instance.queryByMonth(selectedDate);
    if (allDiaryMonthlyRow.isNotEmpty) {
      for (int i = 0; i < allDiaryMonthlyRow.length; i++) {
        DiaryEntity singleDiary = DiaryEntity().fromMap(allDiaryMonthlyRow[i]);
        markedDates.add(DateTime(singleDiary.date.year, singleDiary.date.month,
            singleDiary.date.day));
      }
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    // 日记保存成功监听器
    saveDiaryDoneListener = eventBus.on<DiaryListChanged>().listen((event) {
      loadAllDiary();
    });
    loadAllDiary();
  }

  @override
  void dispose() {
    super.dispose();
    saveDiaryDoneListener.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.fill,
            image: AssetImage('assets/image/bg.jpg'),
          ),
        ),
        child: Column(
          children: [
            calenderSelector(),
            Container(height: 10),
            Expanded(
              child: SingleChildScrollView(
                child: DiaryListWidget.diaryList(allDiary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
