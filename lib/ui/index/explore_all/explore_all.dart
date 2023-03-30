
// 这个地方很重要，如果类名相同“隐藏”对应文件的类
import 'dart:async';

import 'package:diary/main.dart' hide Diary;
import 'package:diary/router/routes.dart';
import 'package:diary/util/eventbus_util.dart';
import 'package:flutter/cupertino.dart';

import '../../../constants.dart';
import '../../../util/db_util.dart';
import '../widget/diary_list_widget.dart';

// 日记列表
class ExploreAllPage extends StatefulWidget {

  const ExploreAllPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ExploreAppPageState();

}

class _ExploreAppPageState extends State<ExploreAllPage> {
  // 日志保存监听
  late StreamSubscription saveDiaryDoneListener;

  // 所有日记信息-Column
  List<Map<String, Object?>> allDiaryRow = [];

  // 日志信息
  List<DiaryEntity> allDiary = [];

  // 日记新增按钮
  Widget addNewDiaryButton() {
    return Positioned(
        right: 20,
        bottom: 20,
        child: _buildAddButton(),
    );
  }

  // 设置日志按钮位置
  Widget _buildAddButton() {
    return CupertinoButton(
        child: Container(
          width: 60,
          height: 60,
          decoration: const BoxDecoration(
            color: Consts.themeColor,
            borderRadius: BorderRadius.all(Radius.circular(80)),
            boxShadow: [
              BoxShadow(
                color: CupertinoColors.systemBlue,
                offset: Offset(5.0, 5.0),
                blurRadius: 15.0,
                spreadRadius: 0.1
              )
            ]
          ),
          child: const Icon(
            CupertinoIcons.add,
            color: CupertinoColors.white,
            size: 20,
          ),
        ),
        onPressed: () {
          router.navigateTo(context, "${Routes.writeDiaryPage}/-1");
        }
    );
  }

  // 加载所有日记
  void loadAllDiary() async {
    await DatabaseUtil.instance.openDb();
    // 加载全部日志信息
    allDiaryRow = await DatabaseUtil.instance.queryAll();
    allDiary.clear();
    // map 转换为实体
    if(allDiaryRow.isNotEmpty) {
      for (int i = 0; i < allDiaryRow.length; i++) {
        allDiary.add(DiaryEntity().fromMap(allDiaryRow[i]));
      }
    }
    // 刷新整个页面
    setState(() {
    });
  }

  @override
  void initState() {
    super.initState();
    // 日志保存成功监听器
    saveDiaryDoneListener = eventBus.on<DiaryListChanged>().listen((event) {
      loadAllDiary();
    });
    // 加载日志
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
          width: double.infinity,
          height: double.infinity,
          padding: const EdgeInsets.only(top: 5),
          decoration: const BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.fill,
              image: AssetImage('assets/image/bg.jpg'),
            ),
          ),
          child: Stack(
            children: [
              DiaryListWidget.diaryList(allDiary),
              // addNewDiaryButton(),
            ],
          ),
        )
    );
  }

}