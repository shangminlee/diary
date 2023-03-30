import 'package:flutter/cupertino.dart';

class DefaultPage extends StatefulWidget {
  const DefaultPage({Key? key}) : super(key: key);

  @override
  State<DefaultPage> createState() => _DefaultPageState();
}

class _DefaultPageState extends State<DefaultPage> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('未找到页面'),
      ),
      child: Container(
        margin: const EdgeInsets.only(top: 40),
        child: Center(child: Text('未找到页面')),
      ),
    );
    ;
  }
}
