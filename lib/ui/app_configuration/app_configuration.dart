
import 'package:diary/main.dart';
import 'package:diary/util/shared_pref_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../router/routes.dart';
import '../../util/log_util.dart';

// app 配置页面
class AppConfigurationPage extends StatefulWidget {

  // 默认构造方法
  const AppConfigurationPage({Key? key}) : super(key: key);

  // 创建状态
  @override
  State<StatefulWidget> createState() => _AppConfigurationPageState();

}

// app 配置页面 状态页面
class _AppConfigurationPageState extends State<AppConfigurationPage> {



  // 资料填写区域控制器
  final TextEditingController _nameInputController = TextEditingController();

  // 资料填写区域
  Widget _buildInputForm() {
    return CupertinoTextField(
      placeholder: "你的名字",
      keyboardType: TextInputType.name,
      controller: _nameInputController,
    );
  }

  // 底部确认按钮
  Widget _buildConfirmButton() {
    return CupertinoButton(
      child: const Text('继续'),
      onPressed: () {
        _saveToSharedPref();
      },
    );
  }

  // 将名字保存到首选项
  void _saveToSharedPref() async {
    String name = _nameInputController.text.trim();
    if (name == "") {
      showCupertinoDialog(
          context: context,
          builder: (context) {
            return CupertinoAlertDialog(
              title: const Text("请检查"),
              content: const Text("请填写你的名字"),
              actions: [
                CupertinoDialogAction(
                  child: const Text("确定"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          }
      );
    } else {
      // 保存资料到首选项
      SharedPrefUtil.instance.saveUserName(name);
      // 跳转到主页
      router.navigateTo(context, Routes.indexPage, rootNavigator: true);
    }
  }

  // 点击空白，收回软键盘
  Widget _buildGesture(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: _buildBody(),
    );
  }

  // 页面主要内容
  Widget _buildBody() {
    return SafeArea(
        child: Container(
          margin: const EdgeInsets.all(50),
          child: Column(
            children: [
              Expanded(child: Center(child: _buildInputForm(),)),
              _buildConfirmButton()
            ],
          ),
        )
    );
  }

  // 构建页面
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('个人资料配置'),
      ),
      child: _buildGesture(context)
    );
  }

  @override
  void initState() {
    super.initState();
    Log.d('用户信息页面【初始化】..');
  }

  @override
  void dispose() {
    Log.d('用户信息页面【销毁】..');
    super.dispose();
  }
}