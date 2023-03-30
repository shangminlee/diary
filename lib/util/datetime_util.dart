import 'package:intl/intl.dart';

class DateTimeUtil {
  /// 最近日记列表中的单个条目时间，规则如下：
  /// 1.当天的消息，显示时间（没日期）
  /// 2.消息超过1天、小于2天，显示昨天+时间
  /// 3.消息超过2天、小于1周，显示星期+时间
  /// 4.消息大于1周，显示时间：日期（年+月+日）+时间
  static String parseDateTimeToFriendlyRead(int timeMillis) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timeMillis);
    int year = dateTime.year;
    int month = dateTime.month;
    int day = dateTime.day;
    String weekDay = '';
    switch (dateTime.weekday) {
      case 1:
        weekDay = '星期一';
        break;
      case 2:
        weekDay = '星期二';
        break;
      case 3:
        weekDay = '星期三';
        break;
      case 4:
        weekDay = '星期四';
        break;
      case 5:
        weekDay = '星期五';
        break;
      case 6:
        weekDay = '星期六';
        break;
      case 7:
        weekDay = '星期日';
        break;
    }
    int hour = dateTime.hour;
    int minute = dateTime.minute;
    int second = dateTime.second;
    DateTime dateTimeNow = DateTime.now();
    int yearNow = dateTime.year;
    int monthNow = dateTime.month;
    int dayNow = dateTime.day;
    int hourNow = dateTime.hour;
    int minuteNow = dateTime.minute;
    int secondNow = dateTime.second;
    int passedDays = dateTimeNow.difference(dateTime).inHours;

    if (yearNow == year && monthNow == month && passedDays <= 1 * 24) {
      // 对应第1条规则
      return '$hour:$minute';
    } else if (yearNow == year &&
        monthNow == month &&
        passedDays > 1 * 24 &&
        passedDays <= 2 * 24) {
      // 对应第2条规则
      return '昨天 $hour:$minute';
    } else if (yearNow == year &&
        monthNow == month &&
        passedDays > 2 * 24 &&
        passedDays <= 7 * 24) {
      // 对应第3条规则
      return '$weekDay $hour:$minute';
    } else {
      // 对应第4条规则
      return '$year-$month-$day $hour:$minute:$second';
    }
  }

  /// 获取当前时间
  static String parseDateTimeNow() {
    DateTime dateTime = DateTime.now();
    String weekDay = '';
    switch (dateTime.weekday) {
      case 1:
        weekDay = '星期一';
        break;
      case 2:
        weekDay = '星期二';
        break;
      case 3:
        weekDay = '星期三';
        break;
      case 4:
        weekDay = '星期四';
        break;
      case 5:
        weekDay = '星期五';
        break;
      case 6:
        weekDay = '星期六';
        break;
      case 7:
        weekDay = '星期日';
        break;
    }
    DateFormat outputFormat = DateFormat("yyyy/MM/dd $weekDay\nHH:mm");
    return outputFormat.format(dateTime);
  }

  /// 获取给定时间的星期
  static String parseWeekDay(DateTime date) {
    String weekDay = '';
    switch (date.weekday) {
      case 1:
        weekDay = '星期一';
        break;
      case 2:
        weekDay = '星期二';
        break;
      case 3:
        weekDay = '星期三';
        break;
      case 4:
        weekDay = '星期四';
        break;
      case 5:
        weekDay = '星期五';
        break;
      case 6:
        weekDay = '星期六';
        break;
      case 7:
        weekDay = '星期日';
        break;
    }
    return weekDay;
  }

  /// 获取给定时间的时刻（仅时间）
  static String parseTime(DateTime date) {
    DateFormat outputFormat = DateFormat("HH:mm");
    return outputFormat.format(date);
  }

  /// 获取给定时间的日期（完整年月日）
  static String parseDate(DateTime date) {
    DateFormat outputFormat = DateFormat("yyyy/MM/dd");
    return outputFormat.format(date);
  }

  /// 获取给定时间的日期（年月）
  static String parseMonth(DateTime date) {
    DateFormat outputFormat = DateFormat("yyyy年 M月");
    return outputFormat.format(date);
  }
}
