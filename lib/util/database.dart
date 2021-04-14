import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:high_hat/util/schedule_data.dart';

class Database {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<ScheduleData> scheduleList = [];

  // TODO(ymgn): これStreamにするとヤバい(ユーザーが増えるたびに更新される)
  //firestore上の全ユーザー情報(友達検索/追加時に使用)
  // Stream<LinkedHashSet<FriendData>> get users {
  //   return _firestore.collection('users').snapshots().map(
  //         (snapshot) => snapshot.docs.map<FriendData>(
  //           (doc) => FriendData(
  //               uid: doc.get('uid') as String,
  //               displayName: doc.get('displayName') as String,
  //               photoUrl: doc.get('photoUrl') as String),
  //         ) as LinkedHashSet<FriendData>,
  //       );
  // }
}
