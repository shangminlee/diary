import 'dart:convert';

import 'package:sqflite/sqflite.dart';

class DBColumns {
  static const String tableName = 'diary';
  static const String columnId = '_id';
  static const String columnTitle = 'title';
  static const String columnImage = 'image';
  static const String columnContent = 'content';
  static const String columnTextRightToLeft = 'textRightToLeft';
  static const String columnWeather = 'weather';
  static const String columnEmotion = 'emotion';
  static const String columnDate = 'date';
}

class DatabaseUtil {

  DatabaseUtil._privateConstructor();

  static final DatabaseUtil _instance = DatabaseUtil._privateConstructor();

  static DatabaseUtil get instance {
    return _instance;
  }

  var db;

  /// 打开数据库
  Future openDb() async {
    // databaseFactory = databaseFactoryFfi;
    if (db == null || !db.isOpen) {
      db = await openDatabase('diary.db', version: 1,
          onCreate: (Database database, int version) async {
            await database.execute('''
              create table ${DBColumns.tableName} ( 
                ${DBColumns.columnId} integer primary key autoincrement, 
                ${DBColumns.columnTitle} text,
                ${DBColumns.columnImage} text,
                ${DBColumns.columnContent} text,
                ${DBColumns.columnTextRightToLeft} integer,
                ${DBColumns.columnWeather} text,
                ${DBColumns.columnEmotion} text,
                ${DBColumns.columnDate} text)
            ''');
          });
    }
  }

  /// 关闭数据库
  Future closeDb() async {
    if (db.isOpen) {
      await db.close();
    }
  }

  /// 插入一条数据
  Future<DiaryEntity> insert(DiaryEntity diary) async {
    diary.id = await db.insert(DBColumns.tableName, diary.toMap());
    return diary;
  }

  /// 更新一条数据
  Future<DiaryEntity> update(DiaryEntity diary) async {
    diary.id = await db.update(DBColumns.tableName, diary.toMap(),
        where: '${DBColumns.columnId} = ?', whereArgs: [diary.id]);
    return diary;
  }

  /// 删除一条数据
  Future delete(DiaryEntity diary) async {
    await db.delete(DBColumns.tableName,
        where: '${DBColumns.columnId} = ?', whereArgs: [diary.id]);
  }

  /// 加载所有历史记录（按时间倒序）
  Future<List<Map<String, Object?>>> queryAll() async {
    return await db.rawQuery(
        'SELECT * FROM ${DBColumns.tableName} order by ${DBColumns.columnDate} desc'
    );
  }

  /// 加载特定日期历史记录（按时间倒序）
  Future<List<Map<String, Object?>>> queryByDate(DateTime dateTime) async {
    DateTime startDate = DateTime(dateTime.year, dateTime.month, dateTime.day);
    int startTime = startDate.millisecondsSinceEpoch;
    DateTime endDate = startDate
        .add(const Duration(days: 1))
        .subtract(const Duration(seconds: 1));
    int endTime = endDate.millisecondsSinceEpoch;
    return await db.rawQuery(
        'SELECT * FROM ${DBColumns.tableName} where ${DBColumns.columnDate} between $startTime and $endTime order by ${DBColumns.columnDate} desc');
  }

  /// 加载特定月历史记录（按时间倒序）
  Future<List<Map<String, Object?>>> queryByMonth(DateTime dateTime) async {
    DateTime startDate = DateTime(dateTime.year, dateTime.month);
    int startTime = startDate.millisecondsSinceEpoch;
    DateTime endDate = DateTime(dateTime.year, dateTime.month + 1)
        .subtract(const Duration(seconds: 1));
    int endTime = endDate.millisecondsSinceEpoch;
    return await db.rawQuery(
        'SELECT * FROM ${DBColumns.tableName} where ${DBColumns.columnDate} between $startTime and $endTime order by ${DBColumns.columnDate} desc');
  }

  /// 加载某条历史记录
  Future<List<Map<String, Object?>>> queryById(int id) async {
    return await db.rawQuery(
        'SELECT * FROM ${DBColumns.tableName} where ${DBColumns.columnId} =?',
        [id]);
  }
}

class DiaryEntity {
  late int id;
  late String title;
  late String image;
  late String content;
  late bool textRightToLeft;
  late Map weather;
  late Map emotion;
  late DateTime date;

  DiaryEntity();

  DiaryEntity fromMap(Map<String, Object?> map) {
    id = map[DBColumns.columnId] as int;
    title = map[DBColumns.columnTitle] as String;
    image = map[DBColumns.columnImage] as String;
    content = map[DBColumns.columnContent] as String;
    textRightToLeft = map[DBColumns.columnTextRightToLeft] == 1;
    weather = json.decode(map[DBColumns.columnWeather] as String);
    emotion = json.decode(map[DBColumns.columnEmotion] as String);
    date = DateTime.fromMillisecondsSinceEpoch(
        int.parse(map[DBColumns.columnDate] as String));
    return this;
  }

  Map<String, Object?> toMap() {
    var map = <String, Object?>{
      DBColumns.columnTitle: title,
      DBColumns.columnImage: image,
      DBColumns.columnContent: content,
      DBColumns.columnTextRightToLeft: textRightToLeft == true ? 1 : 0,
      DBColumns.columnWeather: json.encode(weather),
      DBColumns.columnEmotion: json.encode(emotion),
      DBColumns.columnDate: date.millisecondsSinceEpoch,
    };
    return map;
  }
}
