import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:high_hat/common/helper/helpers.dart';
import 'package:high_hat/domain/schedule/schedule.dart';
import 'package:high_hat/domain/schedule/schedule_repository_base.dart';
import 'package:high_hat/domain/schedule/value/schedule_date.dart';
import 'package:high_hat/domain/schedule/value/schedule_remarks.dart';
import 'package:high_hat/domain/schedule/value/schedule_title.dart';
import 'package:high_hat/domain/schedule/value/schedule_id.dart';
import 'package:high_hat/domain/user/value/answer.dart';
import 'package:high_hat/domain/user/value/avatar_url.dart';
import 'package:high_hat/domain/user/value/user_id.dart';

export 'package:high_hat/domain/schedule/schedule_repository_base.dart';

class ScheduleRepository implements ScheduleRepositoryBase {
  final _db = FirebaseFirestore.instance;
  final _userId = Helpers.userId ?? '';

  @override
  Future<Schedule?> find(ScheduleId id) async {
    DocumentSnapshot snapshot;
    final doc = _db.doc('public/schedule/schedule_v1/${id.value}');

    try {
      snapshot = await doc.get();
    } on Exception catch (e) {
      print(e);
      return null;
    }

    if (!snapshot.exists) {
      return null;
    }
    final data = snapshot.data()!;

    final _ownerUrl = AvatarUrl(data['ownerUrl'] as String);
    final _title = ScheduleTitle(data['title'] as String);
    final _remarks = ScheduleRemarks(data['remarks'] as String);
    final _scheduleList = List<Timestamp>.from(data['scheduleList'] as List)
        .map((e) => e.toDate())
        .map((e) => ScheduleDate(e))
        .toList();
    final _userList = List<String>.from(data['userList'] as List)
        .map((e) => UserId(e))
        .toList();

    return Schedule(
      id: id,
      ownerUrl: _ownerUrl,
      title: _title,
      remarks: _remarks,
      scheduleList: _scheduleList,
      userList: _userList,
    );
  }

  @override
  Future<List<Schedule>> findAll() async {
    final scheduleList = <Schedule>[];

    DocumentSnapshot snapshot;
    final doc = _db.doc('public/user/user_v1/$_userId');

    try {
      snapshot = await doc.get();
    } on Exception catch (e) {
      print(e);
      return scheduleList;
    }

    if (!snapshot.exists) {
      return scheduleList;
    }
    final data = snapshot.data()!;
    final scheduleIdItr = (data['schedule'] as Map<String, dynamic>).keys;

    for (final id in scheduleIdItr) {
      final foundSchedule = await find(ScheduleId(id));
      if (foundSchedule != null) {
        scheduleList.add(foundSchedule);
      }
    }

    return scheduleList;
  }

  @override
  Future<Schedule?> findByTitle(ScheduleTitle title) async {
    // TODO: implement findByTitle
    throw UnimplementedError();
  }

  @override
  Future<void> remove(Schedule schedule) async {
    // schedulesコレクションからドキュメントを取得する
    DocumentSnapshot snapshot;
    final doc = _db.doc('public/user/user_v1/$_userId');

    try {
      snapshot = await doc.get();
    } on Exception catch (e) {
      print(e);
      return;
    }

    if (!snapshot.exists) {
      return;
    }
    final data = snapshot.data()!;

    final scheduleMap = data['schedule'] as Map<String, dynamic>
      ..remove(schedule.id.value);
    await doc.update(<String, dynamic>{'schedule': scheduleMap});
  }

  @override
  Future<T> transaction<T>(Future<T> Function() f) async {
    // TODO: implement transaction
    throw UnimplementedError();
  }

  @override
  Future<void> saveSchedule(Schedule schedule) async {
    // スケジュール本体を作成
    await _db
        .doc('public/schedule/schedule_v1/${schedule.id.value}')
        .set(<String, dynamic>{
      'ownerPhotoUrl': schedule.ownerUrl.value,
      'remarks': schedule.remarks.value,
      'title': schedule.title.value,
      'userNumber': schedule.userList.length,
      'userList':
          FieldValue.arrayUnion(schedule.userList.map((e) => e.value).toList()),
      'scheduleList': FieldValue.arrayUnion(
          schedule.scheduleList.map((e) => e.value).toList()),
    });

    // 各ユーザーにスケジュールを追加
    final scheduleMap = Map.fromIterables(
      schedule.scheduleList.map((e) => e.value).toList(),
      List.filled(schedule.scheduleList.length, 1), // △で埋める
    );

    for (final user in schedule.userList) {
      await _db.doc('public/user/user_v1/${user.value}').set(
        <String, dynamic>{
          'schedule': <String, dynamic>{
            schedule.id.value: scheduleMap,
          },
        },
      );
    }
  }

  @override
  Future<void> saveScheduleAnswer(
      ScheduleId id, Map<ScheduleDate, Answer> answer) async {
    final answerForStrage =
        answer.map((key, value) => MapEntry(key.value.toString(), value.index));
    await _db.doc('public/user/user_v1/${id.value}').update(
      <String, dynamic>{
        'schedule/${id.value}': answerForStrage,
      },
    );
  }
}
