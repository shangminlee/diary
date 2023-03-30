import 'package:flutter/cupertino.dart';

import '../../../main.dart';
import '../../../util/eventbus_util.dart';

// 文字排版设置
class SettingDialog extends StatefulWidget {
  const SettingDialog({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SettingDialogState();
}

class _SettingDialogState extends State<SettingDialog> {
  // 文字从右至左
  bool textRightToLeft = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: const Text('排版设置'),
      content: Column(
        children: [
          // 文字靠右
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '文字靠右对齐',
                style: TextStyle(fontSize: 16),
              ),
              CupertinoSwitch(
                  value: textRightToLeft,
                  onChanged: (bool value) {
                    setState(() {
                      textRightToLeft = value;
                    });
                    eventBus.fire(WriteTextRightToLeft(textRightToLeft));
                  })
            ],
          ),
        ],
      ),
      actions: <CupertinoDialogAction>[
        CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () {
              router.pop(context);
            },
            child: const Text('确认'))
      ],
    );
  }
}
