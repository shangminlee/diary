import 'package:diary/router/routes.dart';
import 'package:diary/ui/index/index.dart';
import 'package:diary/util/shared_pref_util.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

// 路由
final router = FluroRouter();

// 程序入口
void main() {
  // debugPaintSizeEnabled = true;
  // 配置路由
  Routes.configureRoutes(router);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {

  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      debugShowCheckedModeBanner: false,
      // 本地化代理
      localizationsDelegates: const [
        GlobalWidgetsLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      // 支持的地区
      supportedLocales: const [Locale('zh', "CH")],
      // 地区
      locale: const Locale('zh'),
      // 路由生成器
      onGenerateRoute: router.generator,
      // 主题 material app 才有
      // theme: ThemeData(primarySwatch: Colors.blue,),
      // 主页
      home: const Diary(),
    );
  }

}

class Diary extends StatefulWidget {

  const Diary({Key? key}) : super(key: key);

  @override
  State<Diary> createState() => _DiaryState();
}

class _DiaryState extends State<Diary> {

  String? username;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      // 未进行资料设置，跳转到相应页面进行
      _jumpToAppConfig();
    });
  }

  // 跳转到
  void _jumpToAppConfig() async {
    // 读取用户名
    // await SharedPrefUtil.instance.clearUsername();
    username = await SharedPrefUtil.instance.readUsername();
    if(username == null || username == "") {
      // 导航到资料填写页面
      router.navigateTo(context, Routes.appConfigurationPage, clearStack: true);
    } else {
      // 展示弹出框
      showCupertinoDialog(
          context: context,
          builder: (context) {
            return CupertinoAlertDialog(
              title: const Text('欢迎'),
              content: Text(username!),
              actions: [
                CupertinoDialogAction(
                  child: const Text('确定'),
                  onPressed: () {
                      Navigator.of(context).pop();
                  },
                ),
              ],
            );
          }
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const IndexPage();
  }

}
