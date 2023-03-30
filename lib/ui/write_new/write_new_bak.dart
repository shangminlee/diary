import 'dart:io';

import 'package:diary/router/routes.dart';
import 'package:diary/ui/write_new/widget/setting_dialog_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';

import '../../../main.dart' hide Diary;
import '../../constants.dart';
import '../../util/datetime_util.dart';
import '../../util/db_util.dart';
import '../../util/eventbus_util.dart';

class WriteNewPage extends StatefulWidget {
  const WriteNewPage({Key? key, required this.id}) : super(key: key);
  final String id;

  @override
  State<WriteNewPage> createState() => _WriteNewPageState();
}

class _WriteNewPageState extends State<WriteNewPage> {
  TextEditingController titleInputController = TextEditingController();
  TextEditingController contentInputController = TextEditingController();
  var saveDiaryDoneListener;
  var textRightToLeftEventListener;

  // 文字从右至左
  bool textRightToLeft = false;
  Map selectedWeather = {};
  Map selectedEmotion = {};
  DateTime selectedDate = DateTime.now();
  final ImagePicker imagePicker = ImagePicker();
  XFile? image;

  @override
  void initState() {
    super.initState();
    // 载入旧的日记内容
    if (widget.id != "-1") {
      recoverDiary(int.parse(widget.id));
    }
    // 改变文字从右至左排版监听器
    textRightToLeftEventListener =
        eventBus.on<WriteTextRightToLeft>().listen((event) {
          setState(() {
            textRightToLeft = event.textRightToLeft;
          });
        });
    // 日记保存成功监听器
    saveDiaryDoneListener = eventBus.on<DiaryListChanged>().listen((event) {
      router.pop(context);
    });
  }

  @override
  void dispose() {
    super.dispose();
    saveDiaryDoneListener.cancel();
    textRightToLeftEventListener.cancel();
  }

  // 保存这条日记
  void saveDiary() async {
    await DatabaseUtil.instance.openDb();
    Diary singleDiary = Diary();
    singleDiary.title = titleInputController.text;
    singleDiary.image = image != null ? image!.path : '';
    singleDiary.content = contentInputController.text;
    singleDiary.textRightToLeft = textRightToLeft;
    singleDiary.weather = selectedWeather;
    singleDiary.emotion = selectedEmotion;
    singleDiary.date = selectedDate;
    if (widget.id == '-1') {
      // 新创建的日记
      await DatabaseUtil.instance.insert(singleDiary);
    } else {
      // 编辑旧的日记
      singleDiary.id = int.parse(widget.id);
      await DatabaseUtil.instance.update(singleDiary);
    }
    eventBus.fire(DiaryListChanged());
  }

  // 恢复数据
  void recoverDiary(int id) async {
    List<Map<String, Object?>> uniqueDiaryRow =
    await DatabaseUtil.instance.queryById(id);
    if (uniqueDiaryRow.isNotEmpty) {
      Diary uniqueDiary = Diary();
      uniqueDiary.fromMap(uniqueDiaryRow[0]);
      titleInputController.text = uniqueDiary.title;
      textRightToLeft = uniqueDiary.textRightToLeft;
      contentInputController.text = uniqueDiary.content;
      image = XFile(uniqueDiary.image);
      selectedDate = uniqueDiary.date;
      selectedEmotion = uniqueDiary.emotion;
      selectedWeather = uniqueDiary.weather;
      setState(() {});
    }
  }

  // 显示设置窗口
  void showSettingDialog() {
    showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) {
          return const SettingDialog();
        });
  }

  // 插入图片
  void insertImage() {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: const Text('请选择图片来源'),
        cancelButton: CupertinoActionSheetAction(
          isDestructiveAction: true,
          onPressed: () async {
            Navigator.pop(context);
            router.navigateTo(context, Routes.indexPage);
          },
          child: const Text('取消'),
        ),
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            onPressed: () async {
              Navigator.pop(context);
              image = await imagePicker.pickImage(source: ImageSource.camera);
              setState(() {});
            },
            child: const Text('拍一张'),
          ),
          CupertinoActionSheetAction(
            onPressed: () async {
              Navigator.pop(context);
              image = await imagePicker.pickImage(source: ImageSource.gallery);
              setState(() {});
            },
            child: const Text('从相册中选取'),
          ),
        ],
      ),
    );
  }

  // 在文本底部插入时间日期
  void insertDateTime() {
    contentInputController.text =
    "${contentInputController.text}\n${DateTimeUtil.parseDateTimeNow()}";
    contentInputController.selection = TextSelection(
        baseOffset: contentInputController.text.length,
        extentOffset: contentInputController.text.length);
  }

  // 设置天气
  void setWeather() {
    showCupertinoModalPopup<void>(
        context: context,
        builder: (BuildContext context) => Container(
          height: 216,
          padding: const EdgeInsets.only(top: 6.0),
          margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          color: CupertinoColors.systemBackground.resolveFrom(context),
          child: SafeArea(
            top: false,
            child: CupertinoPicker(
              magnification: 1.22,
              squeeze: 1.2,
              useMagnifier: true,
              itemExtent: 30,
              onSelectedItemChanged: (int selectedItem) {
                setState(() {
                  selectedWeather = Consts.weatherResource[selectedItem];
                });
              },
              children: List<Widget>.generate(20, (int index) {
                return Center(
                  child: Text(
                    Consts.weatherResource[index]['name'],
                    textAlign: TextAlign.center,
                  ),
                );
              }),
            ),
          ),
        ));
  }

  // 设置心情
  void setEmotion() {
    showCupertinoModalPopup<void>(
        context: context,
        builder: (BuildContext context) => Container(
          height: 216,
          padding: const EdgeInsets.only(top: 6.0),
          margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          color: CupertinoColors.systemBackground.resolveFrom(context),
          child: SafeArea(
            top: false,
            child: CupertinoPicker(
              magnification: 1.22,
              squeeze: 1.2,
              useMagnifier: true,
              itemExtent: 30,
              onSelectedItemChanged: (int selectedItem) {
                setState(() {
                  selectedEmotion = Consts.emotionResource[selectedItem];
                });
              },
              children: List<Widget>.generate(19, (int index) {
                return Center(
                  child: Text(
                    Consts.emotionResource[index]['name'],
                    textAlign: TextAlign.center,
                  ),
                );
              }),
            ),
          ),
        ));
  }

  // 设置日期
  void setDate() {
    showCupertinoModalPopup<void>(
        context: context,
        builder: (BuildContext context) => Container(
          height: 216,
          padding: const EdgeInsets.only(top: 6.0),
          margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          color: CupertinoColors.systemBackground.resolveFrom(context),
          child: SafeArea(
            top: false,
            child: CupertinoDatePicker(
              initialDateTime: selectedDate,
              mode: CupertinoDatePickerMode.dateAndTime,
              use24hFormat: true,
              onDateTimeChanged: (DateTime newDate) {
                setState(() => selectedDate = newDate);
              },
            ),
          ),
        ));
  }

  // 顶部导航栏
  CupertinoNavigationBar topNavigationBar() {
    return CupertinoNavigationBar(
      leading: SizedBox(
        width: 40,
        child: CupertinoButton(
          padding: const EdgeInsets.all(0),
          child: const Text(
            '取消',
            style: TextStyle(color: CupertinoColors.label),
          ),
          onPressed: () {
            // router.pop(context);
            router.navigateTo(context, Routes.indexPage, clearStack: true);
          },
        ),
      ),
      middle: CupertinoTextField(
        controller: titleInputController,
        textAlign: TextAlign.center,
        decoration: const BoxDecoration(border: null),
        placeholder: '标题',
      ),
      trailing: SizedBox(
        height: 30,
        width: 50,
        child: CupertinoButton(
          color: Consts.themeColor,
          padding: const EdgeInsets.all(0),
          child: Text(
            widget.id == '-1' ? '保存' : '修改',
            style: const TextStyle(color: CupertinoColors.white, fontSize: 15),
          ),
          onPressed: () {
            saveDiary();
          },
        ),
      ),
    );
  }

  // 日记配图（仅在添加了图片后显示）
  Widget diaryPicture() {
    return image == null
        ? Container()
        : Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: FileImage(File(image!.path)),
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
    );
  }

  // 文本输入区
  Widget textInputArea() {
    return Expanded(
      child: CupertinoTextField(
        textAlign: !textRightToLeft ? TextAlign.start : TextAlign.end,
        controller: contentInputController,
        padding: const EdgeInsets.only(left: 16, right: 16, top: 10),
        cursorColor: Consts.themeColor,
        style: const TextStyle(fontSize: 18, height: 1.8),
        autofocus: true,
        maxLines: 500,
        textAlignVertical: TextAlignVertical.top,
        decoration: const BoxDecoration(border: null),
      ),
    );
  }

  // 底部操作栏
  Widget bottomOperationBar() {
    return SizedBox(
      height: 40,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 设置按钮
          Expanded(
            child: Container(
              alignment: Alignment.centerLeft,
              child: CupertinoButton(
                  padding: const EdgeInsets.all(0),
                  child: const Icon(CupertinoIcons.gear_solid,
                      size: 20, color: CupertinoColors.systemGrey),
                  onPressed: () {
                    showSettingDialog();
                  }),
            ),
          ),
          // 插入图片按钮
          Platform.isIOS || Platform.isAndroid
              ? CupertinoButton(
              padding: const EdgeInsets.all(0),
              child: const Icon(CupertinoIcons.photo_fill,
                  size: 20, color: CupertinoColors.systemGrey),
              onPressed: () {
                insertImage();
              })
              : Container(),
          // 插入当前日期时间按钮
          CupertinoButton(
              padding: const EdgeInsets.all(0),
              child: const Icon(CupertinoIcons.time,
                  size: 20, color: CupertinoColors.systemGrey),
              onPressed: () {
                insertDateTime();
              }),
          // 分割线
          Container(
            width: 1,
            height: 20,
            color: CupertinoColors.systemGrey,
            alignment: Alignment.center,
          ),
          // 设置当前天气按钮
          CupertinoButton(
              padding: const EdgeInsets.all(0),
              child: selectedWeather == {} || selectedWeather['path'] == null
                  ? const Icon(CupertinoIcons.sun_max_fill,
                  size: 20, color: CupertinoColors.systemGrey)
                  : SvgPicture.asset(
                selectedWeather['path'],
                width: 20.0,
                height: 20.0,
              ),
              onPressed: () {
                setWeather();
              }),
          // 设置当前心情按钮
          CupertinoButton(
              padding: const EdgeInsets.all(0),
              child: selectedEmotion == {} || selectedEmotion['path'] == null
                  ? const Icon(CupertinoIcons.smiley,
                  size: 20, color: CupertinoColors.systemGrey)
                  : SvgPicture.asset(
                selectedEmotion['path'],
                width: 20.0,
                height: 20.0,
              ),
              onPressed: () {
                setEmotion();
              }),
          // 设置日记日期按钮
          CupertinoButton(
              padding: const EdgeInsets.all(0),
              child: Icon(CupertinoIcons.calendar,
                  size: 20,
                  color: selectedDate.year == DateTime.now().year &&
                      selectedDate.month == DateTime.now().month &&
                      selectedDate.day == DateTime.now().day
                      ? CupertinoColors.systemGrey
                      : Consts.themeColor),
              onPressed: () {
                setDate();
              }),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: topNavigationBar(),
      child: SafeArea(
        child: Column(
          children: [
            diaryPicture(),
            textInputArea(),
            bottomOperationBar(),
          ],
        ),
      ),
    );
  }
}
