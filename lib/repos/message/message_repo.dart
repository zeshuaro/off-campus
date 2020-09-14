import 'package:cloud_firestore/cloud_firestore.dart';

import 'models/models.dart';

export 'models/models.dart';

class MessageRepo {
  final CollectionReference _messagesRef =
      FirebaseFirestore.instance.collection('messages');

  Stream<List<Message>> messages(String chatId) {
    return _messagesRef
        .where('chatId', isEqualTo: chatId)
        .orderBy('createdAt')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              final data = doc.data();
              data['id'] = doc.id;

              return Message.fromJson(data);
            }).toList());
  }

  Future<void> addMessage(
      String userId, String username, String chatId, String text) async {
    await _messagesRef.add(<String, dynamic>{
      'chatId': chatId,
      'userId': userId,
      'username': username,
      'text': text,
      'createdAt': DateTime.now(),
    });
  }
}
