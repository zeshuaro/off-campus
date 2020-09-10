import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:offcampus/repos/auth/auth_repo.dart';

import 'models/models.dart';

export 'models/models.dart';

class MessageRepo {
  final AuthRepo _authRepo;
  final CollectionReference _messagesRef =
      FirebaseFirestore.instance.collection('messages');

  MessageRepo(this._authRepo);

  Stream<List<Message>> messages(String chatId) {
    return _messagesRef
        .where('chatId', isEqualTo: chatId)
        .orderBy('createdAt')
        .snapshots()
        .asyncMap((snapshot) async {
      final messages = <Message>[];

      for (var doc in snapshot.docs) {
        final data = doc.data();
        final user = await _authRepo.fetchMyUser(data['userId']);

        data['id'] = doc.id;
        data['user'] = user.toJson();
        messages.add(Message.fromJson(data));
      }

      return messages;
    });
  }

  Future<void> addMessage(String userId, String chatId, String text) async {
    await _messagesRef.add(<String, dynamic>{
      'userId': userId,
      'chatId': chatId,
      'text': text,
      'createdAt': DateTime.now(),
    });
  }
}
