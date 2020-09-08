import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:offcampus/repos/auth/auth_repo.dart';

import 'models/models.dart';

export 'models/models.dart';

class ChatRepo {
  final AuthRepo _authRepo;
  final CollectionReference _chatsRef =
      FirebaseFirestore.instance.collection('chats');

  ChatRepo(this._authRepo);

  Future<List<Chat>> fetchChats(String userId) async {
    final snapshot =
        await _chatsRef.where('userIds', arrayContains: userId).get();
    final chats = <Chat>[];

    for (var doc in snapshot.docs) {
      final data = doc.data();
      final users = <MyUser>[];
      data['id'] = doc.id;

      for (var userId in data['userIds']) {
        final user = await _authRepo.fetchMyUser(userId);
        users.add(user);
      }

      data['users'] = users;
      chats.add(Chat.fromJson(data));
    }

    return chats;
  }

  Future<Chat> addChat(List<String> userIds) async {
    final data = <String, dynamic>{'userIds': userIds};
    final docRef = await _chatsRef.add(data);
    data['id'] = docRef;

    return Chat.fromJson(data);
  }
}
