import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:offcampus/repos/auth/auth_repo.dart';

class UserRepo {
  final CollectionReference _usersRef =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference _chatsRef =
      FirebaseFirestore.instance.collection('chats');

  Stream<List<MyUser>> users(String currUserId) {
    return _usersRef.snapshots().asyncMap((snapshot) async {
      final users = <MyUser>[];
      final chatsSnapshot =
          await _chatsRef.where('userIds', arrayContains: currUserId).get();
      final chatUserIds = <String>{};

      for (var doc in chatsSnapshot.docs) {
        chatUserIds.addAll(List<String>.from(doc.data()['userIds']));
      }

      for (var doc in snapshot.docs) {
        if (doc.id == currUserId || chatUserIds.contains(doc.id)) {
          continue;
        }

        final data = doc.data();
        data['id'] = doc.id;
        users.add(MyUser.fromJson(data));
      }

      return users;
    });
  }
}
