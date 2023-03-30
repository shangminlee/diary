
import 'package:diary/ui/index/explore_all/explore_all.dart';
import 'package:diary/ui/index/explore_calender/explore_calender.dart';
import 'package:flutter/cupertino.dart';

class IndexPage extends StatefulWidget {

  const IndexPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _IndexPageState();

}

class _IndexPageState extends State<IndexPage> {

  // 顶部标签索引
  int _currentPage = 0;

  // 顶部标签
  Map<Object, Widget> _segmentedControlWidgets() {
    return {
      0: Container(
        padding: const EdgeInsets.only(left: 25, right: 25),
        child: const Text('浏览'),
      ),
      1: Container(
        padding: const EdgeInsets.only(left: 25, right: 25),
        child: const Text('日历'),
      )
    };
  }

  // 顶部标签页页面
  static const List<Widget> _tabPages = [
    ExploreAllPage(),
    ExploreCalenderPage(),
  ];

  // 构建顶部标签
  Widget _buildPageScaffold() {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: CupertinoSlidingSegmentedControl(
          children: _segmentedControlWidgets(),
          groupValue: _currentPage,
          onValueChanged: (value) {
            setState(() {
              _currentPage = value as int;
            });
          },
        ),
      ),
      child: Container(
        child: _tabPages[_currentPage],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildPageScaffold();
  }

}