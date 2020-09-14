import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:offcampus/repos/auth/auth_repo.dart';

import 'models/models.dart';

export 'models/models.dart';

class ChatRepo {
  static final _firestore = FirebaseFirestore.instance;
  final AuthRepo _authRepo;
  final CollectionReference _chatsRef = _firestore.collection('chats');

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
        data['isInit'] = false;

        if (!data.containsKey('title')) {
          data['title'] = 'Chat';
          for (var userId in data['userIds']) {
            final user = await _authRepo.fetchMyUser(userId);
            users.add(user.toJson());

            if (user.id != currUserId) {
              data['title'] = user.name;
            }
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
      'type': chatTypeToString(chat.type),
      'userIds': chat.userIds,
      'lastMessage': chat.lastMessage,
      'lastMessageUser': chat.lastMessageUser,
      'updatedAt': DateTime.now(),
    });
  }

  Future<void> updateChat(Chat chat) async {
    await _firestore.runTransaction((transaction) async {
      final ref = _chatsRef.doc(chat.id);
      await transaction.get(ref);
      transaction.update(ref, {
        'lastMessage': chat.lastMessage,
        'lastMessageUser': chat.lastMessageUser,
        'updatedAt': DateTime.now(),
      });
    });
  }

  Stream<List<Chat>> courseChats(MyUser currUser) {
    return _chatsRef
        .where('type', isEqualTo: 'course')
        .where('university', isEqualTo: currUser.university)
        .orderBy('title')
        .snapshots()
        .asyncMap((snapshot) async {
      final chats = <Chat>[];
      for (var doc in snapshot.docs) {
        final data = doc.data();
        if (data['userIds']?.contains(currUser.id) == true) {
          continue;
        }

        data['id'] = doc.id;
        chats.add(Chat.fromJson(data));
      }

      return chats;
    });
  }

  Future<void> joinCourseChat(String chatId, String userId) async {
    await _firestore.runTransaction((transaction) async {
      final ref = _chatsRef.doc(chatId);
      final snapshot = await transaction.get(ref);
      final data = snapshot.data();

      final int numMembers = (snapshot.data()['numMembers'] ?? 0) + 1;
      var userIds = <String>[];

      if (data.containsKey('userIds')) {
        userIds = List<String>.from(data['userIds']);
      }

      userIds.add(userId);
      transaction.update(ref, {'numMembers': numMembers, 'userIds': userIds});
    });
  }
}
