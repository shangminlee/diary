import 'package:event_bus/event_bus.dart';

EventBus eventBus = EventBus();

//事件：书写页面修改排版
class WriteTextRightToLeft {
  bool textRightToLeft;

  WriteTextRightToLeft(this.textRightToLeft);
}

//事件：日记有修改
class DiaryListChanged {
  DiaryListChanged();
}
