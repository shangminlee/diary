
import 'package:diary/ui/app_configuration/app_configuration.dart';
import 'package:diary/ui/index/explore_all/explore_all.dart';
import 'package:diary/ui/index/explore_calender/explore_calender.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../write_new/write_new.dart';

class IndexPage extends StatefulWidget {

  const IndexPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _IndexPageState();

}

class _IndexPageState extends State<IndexPage> {

  int currentPage = 0;

  Map<Object, Widget> segmentedControlWidgets() {
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

  Widget _buildPageScaffold() {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: CupertinoSlidingSegmentedControl(
          children: segmentedControlWidgets(),
          groupValue: currentPage,
          onValueChanged: (value) {
            setState(() {
              currentPage = value as int;
            });
          },
        ),
      ),
      child: Container(
        child: currentPage == 0? const ExploreAllPage() : const ExploreCalenderPage(),
      ),
    );
  }

  Widget _buildTabScaffold() {
    return CupertinoTabScaffold(
        tabBar: CupertinoTabBar(
          items:const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.home),
              label: '首页',
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.add),
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.settings),
              label: '设置',
            ),
          ],
        ),
      tabBuilder: (BuildContext context, int index) {
        return CupertinoTabView(
          builder: (BuildContext context) {
            if (index == 1) {
              return const WriteNewPage(id: '-1');
            }
            return index == 0 ? _buildPageScaffold(): const AppConfigurationPage();
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildTabScaffold();
  }

}