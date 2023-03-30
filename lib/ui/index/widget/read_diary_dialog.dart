import 'dart:io';

import 'package:flutter/cupertino.dart';

import '../../../constants.dart';
import '../../../main.dart' hide Diary;
import '../../../router/routes.dart';
import '../../../util/datetime_util.dart';
import '../../../util/db_util.dart';
import '../../../util/eventbus_util.dart';

class ReadDiaryDialog extends StatefulWidget {
  const ReadDiaryDialog({Key? key, required this.diary}) : super(key: key);

  final Diary diary;

  @override
  State<StatefulWidget> createState() => _ReadDiaryDialogState();
}

class _ReadDiaryDialogState extends State<ReadDiaryDialog> {
  // 顶部日期显示区域
  Widget dateTime() {
    return SizedBox(
      width: double.infinity,
      child: Stack(
        children: [
          Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 20, bottom: 20),
              child: Column(
                children: [
                  Text(
                    DateTimeUtil.parseMonth(widget.diary.date),
                    style: const TextStyle(
                        fontSize: 18, color: CupertinoColors.white),
                  ),
                  Text(
                    widget.diary.date.day.toString(),
                    style: const TextStyle(
                        fontSize: 60, color: CupertinoColors.white),
                  ),
                  Text(
                    '${DateTimeUtil.parseWeekDay(widget.diary.date)} ${DateTimeUtil.parseTime(widget.diary.date)}',
                    style: const TextStyle(
                        fontSize: 18, color: CupertinoColors.white),
                  )
                ],
              )),
          Positioned(
            top: 5,
            right: 5,
            child: CupertinoButton(
              child: const Icon(
                CupertinoIcons.clear,
                color: CupertinoColors.white,
              ),
              onPressed: () {
                router.pop(context);
              },
            ),
          )
        ],
      ),
    );
  }

  // 日记内容区
  Widget diaryContent() {
    return Container(
      width: double.infinity,
      color: CupertinoColors.white,
      child: SingleChildScrollView(
        child: Column(
          children: [
            // 图片
            widget.diary.image == ''
                ? Container()
                : Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: FileImage(File(widget.diary.image)),
                ),
                boxShadow: const [
                  BoxShadow(
                      color: CupertinoColors.systemGrey,
                      offset: Offset(3.0, 3.0),
                      blurRadius: 4,
                      spreadRadius: 0.5)
                ],
              ),
              height: 180,
            ),
            // 标题
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(left: 16, right: 16, top: 10),
              child: Text(
                widget.diary.title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 25, height: 1.8, color: Color(0x99000000)),
              ),
            ),

            // 内容
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(left: 16, right: 16, top: 10),
              child: Text(
                widget.diary.content,
                textAlign: !widget.diary.textRightToLeft
                    ? TextAlign.start
                    : TextAlign.end,
                style: const TextStyle(
                    fontSize: 18, height: 1.8, color: Color(0x99000000)),
              ),
            )
          ],
        ),
      ),
    );
  }

  // 底部操作栏
  Widget bottomBar() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        CupertinoButton(
          child: const Icon(
            CupertinoIcons.delete_simple,
            color: CupertinoColors.systemRed,
          ),
          onPressed: () {
            showCupertinoDialog(
                context: context,
                builder: (BuildContext context) {
                  return CupertinoAlertDialog(
                    title: Text('要删除"${widget.diary.title}"吗？'),
                    content: const Text('删除的日记无法恢复'),
                    actions: <CupertinoDialogAction>[
                      CupertinoDialogAction(
                          isDestructiveAction: true,
                          onPressed: () async {
                            router.pop(context);
                            router.pop(context);
                            await DatabaseUtil.instance.openDb();
                            await DatabaseUtil.instance.delete(widget.diary);
                            eventBus.fire(DiaryListChanged());
                          },
                          child: const Text('确认')),
                      CupertinoDialogAction(
                          isDefaultAction: true,
                          onPressed: () {
                            router.pop(context);
                          },
                          child: const Text('取消'))
                    ],
                  );
                  ;
                });
          },
        ),
        CupertinoButton(
          child: const Icon(
            CupertinoIcons.pencil,
            color: CupertinoColors.white,
          ),
          onPressed: () {
            showCupertinoDialog(
                context: context,
                builder: (BuildContext context) {
                  return CupertinoAlertDialog(
                    title: Text('再次编辑"${widget.diary.title}"吗？'),
                    content: const Text('即使是不好的回忆，也值得纪念'),
                    actions: <CupertinoDialogAction>[
                      CupertinoDialogAction(
                          isDestructiveAction: true,
                          onPressed: () async {
                            router.pop(context);
                            router.pop(context);
                            // 跳转到编辑
                            router.navigateTo(context,
                                "${Routes.writeDiaryPage}/${widget.diary.id}");
                          },
                          child: const Text('确认')),
                      CupertinoDialogAction(
                          isDefaultAction: true,
                          onPressed: () {
                            router.pop(context);
                          },
                          child: const Text('取消'))
                    ],
                  );
                });
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 40, bottom: 40, left: 20, right: 20),
      decoration: const BoxDecoration(
        color: Consts.themeColor,
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: Column(
        children: [
          dateTime(),
          Expanded(
            child: diaryContent(),
          ),
          bottomBar()
        ],
      ),
    );
  }
}

