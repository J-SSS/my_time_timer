import 'dart:async';
import 'package:my_time_timer/manager/app_manager.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbManager {
  // DB 이름, 버전, 테이블 이름 등 정의
  static const _dbName = 'myDatabase.db';
  static const _dbVersion = 1;
  static const _tableGroup = 'mft_group';
  static const _tableTimer = 'mft_timer';
  static const _tableConfig = 'mft_config';

  DbManager._();
  static final DbManager instance = DbManager._();

  Database? _db;

  // 데이터베이스 객체를 가져오는 Getter
  Future<Database> get database async {
    return _db ??= await init();
  }

  /// 데이터베이스 초기화
  Future<Database> init() async {
    AppManager.log("SQLite 초기화", type: "S");
    // /data/user/0/com.mtt.my_time_timer/databases
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);

    return await openDatabase(
      path,
      version: _dbVersion,
      onConfigure: (db) async {
      await db.execute('PRAGMA foreign_keys = ON'); // 외래 키 활성화
      },
      onCreate: _onCreate,
      // 앱을 배포한 후 테이블 스키마를 수정해야 할 때, onUpgrade 콜백을 활용해 마이그레이션 로직을 작성 가능
      // onUpgrade: (db, oldVersion, newVersion) async {
      //   // 마이그레이션 로직
      //   if (oldVersion < newVersion) {
      //     // 예: 테이블에 컬럼 추가
      //     await db.execute("ALTER TABLE $_tableName ADD COLUMN newColumn TEXT");
      //   }
      // },
    ); // DB 열기 (없으면 생성)
  }

  // DB가 처음 생성될 때 테이블 생성 및 값 초기화
  Future _onCreate(Database db, int version) async {
    // mft_config 테이블
    await db.execute('''
      CREATE TABLE $_tableConfig(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        age INTEGER NOT NULL
      )
    ''');

    // mft_group 테이블
    await db.execute('''
      CREATE TABLE $_tableGroup(
        group_id INTEGER PRIMARY KEY AUTOINCREMENT,
        group_name TEXT,
        sort_order INTEGER,
        insert_date TEXT,
        update_date TEXT
      )
    ''');

    // mft_timer 테이블
    await db.execute('''
      CREATE TABLE $_tableTimer(
        timer_id INTEGER PRIMARY KEY AUTOINCREMENT,
        group_id INTEGER NOT NULL,
        timer_name TEXT,
        sort_order INTEGER,
        FOREIGN KEY (group_id) REFERENCES $_tableGroup (group_id) 
        ON DELETE CASCADE
        ON UPDATE CASCADE
      )
    ''');

    /** 추가해야할 것
     * 순번 sort_order ㅇ
     * 타입
     *  'type': 'pizza',
     * 'unit': 'min', // 설정 단위 min,sec,time
     *'setupTime': '45', // 설정 시간
     *'viewRemainTime': '', // 남은 시간 표시 여부
     */


    // 'viewDescript': 'false', // 설명 표시 여부
    // 'descriptText': 'test', // 설명 텍스트


    // 'isAlarmYn': 'N', // 알람 여부
    // 'alarmType': '', // 알람 타입 무음/진동/소리
    // 'dismissAlarm': '', // 한 번, 버튼 클릭
    // 'isInterNotif': '', // 중간 알림
    // 'notifUnit': '', // 중간 알림
    // 'notifGap': '', // 알림 간격
    // 'notifType': '', // 알림 타입 무음 / 진동 / 소리


    await insertDefaultData(db);
  }

  Future<void> insertDefaultData(Database db) async {
    // Database db = await instance.database;
    // db.insert(_tableConfig, {}); // mft_config
    await db.insert(_tableGroup, {
      "group_id" : 0,
      "group_name" : "Timer Group",
    }); // mft_group
    await db.insert(_tableTimer, {
      "timer_id" : 0,
      "group_id" : 0,
      "timer_name" : "Basic Timer",
    }); // mft_timer
  }



  // datetime('now') >
  /// Create
  Future<int> insertData(String tableName, Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(tableName, row);
  }

  /// Read
  Future<List<Map<String, dynamic>>> getGroupData() async {
    Database db = await instance.database;
    return await db.query(_tableGroup);
  }
  /// Read
  Future<List<Map<String, dynamic>>> getTimerData() async {
    Database db = await instance.database;
    return await db.query(_tableTimer);
  }

  /// Read
  Future<List<Map<String, dynamic>>> getAllData(String tableName) async {
    Database db = await instance.database;
    return await db.query(tableName);
  }

  /// Update
  Future<int> updateData(String tableName, Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row['id'];
    return await db.update(
      tableName,
      row,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Delete
  Future<int> deleteData(String tableName, int id) async {
    Database db = await instance.database;
    return await db.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// 모든 테이블 DROP 후 초기화
  Future<void> resetData() async {
    Database db = await instance.database;
    await db.execute('''DROP TABLE IF EXISTS $_tableConfig;'''); // mft_config drop
    await db.execute('''DROP TABLE IF EXISTS $_tableGroup;'''); // mft_group drop
    await db.execute('''DROP TABLE IF EXISTS $_tableTimer;'''); // mft_timer drop

    return await _onCreate(db, _dbVersion); // 테이블 재생성 및 값 초기화 todo 앱 재실행까지 가능한지 확인해보기
    // await db.close(); // 데이터베이스 닫기
    // await deleteDatabase(path); // 데이터베이스 삭제
  }
}

/**
 *  '''는 멀티라인 문자열
 *  execute은 DML (결과 반환 X)
 *  rawQuery는 SELECT 문 (결과 반환 O) > List<Map<String, dynamic>> 형태
 *
 * query: 테이블 조회 (편의 메서드)
 * final results = await db.query('users', where: 'age > ?', whereArgs: [20]);
 *
 * insert: 데이터 삽입
 * final id = await db.insert('users', {'name': 'Alice', 'age': 25});
 *
 * update: 데이터 수정
 * final rows = await db.update('users', {'age': 30}, where: 'name = ?', whereArgs: ['Alice']);
 *
 * delete: 데이터 삭제
 * final rows = await db.delete('users', where: 'age < ?', whereArgs: [18]);
 *
 *
 * TEXT: ISO8601 형식의 문자열

예: '2025-01-14 15:30:00'
REAL: Julian Day 숫자 형식

예: 2459888.145833 (날짜와 시간을 나타내는 실수형 값)
INTEGER: Unix 타임스탬프 (초 단위 또는 밀리초 단위)

예: 1705257000 (UTC 기준 1970-01-01 00:00:00부터의 초)

date(): 날짜만 반환 (YYYY-MM-DD).
time(): 시간만 반환 (HH:MM:SS).
datetime(): 날짜와 시간 반환 (YYYY-MM-DD HH:MM:SS).
strftime(): 커스텀 형식으로 날짜/시간 반환.
julianday(): Julian Day 숫자 반환.
unixepoch(): Unix Epoch 시간 반환.

-- 현재 날짜와 시간 반환
SELECT datetime('now');

-- 7일 후의 날짜 계산
SELECT date('now', '+7 days');

-- 특정 날짜의 요일 계산
SELECT strftime('%w', '2025-01-14'); -- 0: 일요일, 1: 월요일 ...
*/