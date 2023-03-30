import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';

import '../../../constants.dart';
import '../../../util/datetime_util.dart';
import '../../../util/db_util.dart';
import 'read_diary_dialog.dart';

class ItemSingleDiaryWidget extends StatefulWidget {
  const ItemSingleDiaryWidget({Key? key, required this.diary})
      : super(key: key);

  final Diary diary;

  @override
  State<StatefulWidget> createState() => _ItemSingleDiaryWidgetState();
}

class _ItemSingleDiaryWidgetState extends State<ItemSingleDiaryWidget> with SingleTickerProviderStateMixin {
  late AnimationController controller;
  double beginScale = 1.0, endScale = 1.0;

  @override
  void initState() {
    super.initState();
    // 定义整体缩放动画
    controller = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 100)
    );
    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        showCupertinoModalPopup(
            context: context,
            builder: (BuildContext context) {
              return ReadDiaryDialog(diary: widget.diary);
            });
        controller.reverse();
      }
    });
  }

  // 左侧区域
  Widget leftArea() {
    return Column(
      children: [
        Text(
          widget.diary.date.day.toString(),
          style: const TextStyle(color: Consts.themeColor, fontSize: 26),
        ),
        Container(height: 2),
        Text(
          DateTimeUtil.parseWeekDay(widget.diary.date),
          style: const TextStyle(color: Consts.themeColor, fontSize: 12),
        ),
      ],
    );
  }

  // 中间区域
  Widget rightArea() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(DateTimeUtil.parseTime(widget.diary.date),
            style: const TextStyle(color: Consts.themeColor, fontSize: 12)),
        Container(height: 2),
        Text(
            widget.diary.title != ''
                ? widget.diary.title
                : DateTimeUtil.parseDate(widget.diary.date),
            style: const TextStyle(color: Consts.themeColor, fontSize: 14)),
        Container(height: 2),
        Text(
          widget.diary.content,
          style: const TextStyle(color: Consts.themeColor, fontSize: 14),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  // 天气和情绪
  Widget weatherAndEmotionArea() {
    return Positioned(
      right: 5,
      top: 5,
      child: Row(
        children: [
          widget.diary.weather['path'] != null
              ? SvgPicture.asset(
            widget.diary.weather['path'],
            width: 14.0,
            height: 14.0,
          )
              : const SizedBox(width: 14.0, height: 14.0),
          const SizedBox(width: 5),
          widget.diary.emotion['path'] != null
              ? SvgPicture.asset(
            widget.diary.emotion['path'],
            width: 14.0,
            height: 14.0,
          )
              : const SizedBox(width: 14.0, height: 14.0),
        ],
      ),
    );
  }

  // 显示日志详情
  void showDiaryDetail(double startX, double startY) {
    print("0000000");
    setState(() {
      endScale = 1.1;
    });
    if (!controller.isAnimating) {
      controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: Tween(begin: beginScale, end: endScale).animate(controller),
      child: GestureDetector(
        onTapUp: (tapUpDetails) {
          showDiaryDetail(
              tapUpDetails.globalPosition.dx, tapUpDetails.globalPosition.dy);
        },
        child: Container(
          padding: const EdgeInsets.only(left: 20, top: 8, bottom: 8, right: 8),
          margin: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
          decoration: const BoxDecoration(
            boxShadow: [
              BoxShadow(
                  color: CupertinoColors.systemGrey,
                  offset: Offset(2.0, 2.0),
                  blurRadius: 2,
                  spreadRadius: 0.5)
            ],
            color: CupertinoColors.white,
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
          child: Stack(children: [
            Row(
              children: [
                leftArea(),
                Container(width: 20),
                Expanded(child: rightArea())
              ],
            ),
            weatherAndEmotionArea()
          ]),
        ),
      ),
    );
  }
}
