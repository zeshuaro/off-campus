import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:offcampus/repos/auth/auth_repo.dart';

import 'models/models.dart';

export 'models/models.dart';

class ChatRepo {
  final AuthRepo _authRepo;
  final CollectionReference _chatsRef =
      FirebaseFirestore.instance.collection('chats');

  ChatRepo(this._authRepo);

  Stream<List<Chat>> chats(String currUserId) {
    return _chatsRef
        .where('userIds', arrayContains: currUserId)
        .orderBy('updatedAt', descending: true)
        .snapshots()
        .asyncMap((snapshot) async {
      final chats = <Chat>[];
      for (var doc in snapshot.docs) {
        final data = doc.data();
        final users = <Map<String, dynamic>>[];
        data['id'] = doc.id;
        data['title'] = 'Chat';
        data['isInit'] = false;

        for (var userId in data['userIds']) {
          final user = await _authRepo.fetchMyUser(userId);
          users.add(user.toJson());

          if (user.id != currUserId) {
            data['title'] = user.name;
          }
        }

        data['users'] = users;
        chats.add(Chat.fromJson(data));
      }

      return chats;
    });
  }

  Future<void> addChat(Chat chat) async {
    await _chatsRef.doc(chat.id).set(<String, dynamic>{
      'userIds': chat.userIds,
      'lastMessage': chat.lastMessage,
      'lastMessageUser': chat.lastMessageUser,
      'updatedAt': DateTime.now(),
    });
  }

  Future<void> updateChat(Chat chat) async {
    await _chatsRef.doc(chat.id).update(<String, dynamic>{
      'lastMessage': chat.lastMessage,
      'lastMessageUser': chat.lastMessageUser,
      'updatedAt': DateTime.now(),
    });
  }

  Stream<List<Chat>> courseChats(String currUserId) {
    return _chatsRef
        .where('type', isEqualTo: 'course')
        .orderBy('title')
        .snapshots()
        .asyncMap((snapshot) async {
      final chats = <Chat>[];
      for (var doc in snapshot.docs) {
        final data = doc.data();
        if (data['userIds']?.contains(currUserId) == true) {
          continue;
        }

        data['id'] = doc.id;
        chats.add(Chat.fromJson(data));
      }

      return chats;
    });
  }
}
