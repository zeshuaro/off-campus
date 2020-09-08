import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:offcampus/repos/auth/auth_repo.dart';

class UserRepo {
  final CollectionReference _usersRef =
      FirebaseFirestore.instance.collection('users');

  Future<List<MyUser>> fetchUsers(String currUserId) async {
    final snapshot = await _usersRef.get();
    final users = <MyUser>[];

    for (var doc in snapshot.docs) {
      if (doc.id == currUserId) {
        continue;
      }

      final data = doc.data();
      data['id'] = doc.id;
      users.add(MyUser.fromJson(data));
    }

    return users;
  }
}
