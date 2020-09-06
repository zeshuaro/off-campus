import 'package:cloud_firestore/cloud_firestore.dart';

import 'models/models.dart';

export 'models/models.dart';

class UniRepo {
  final CollectionReference _unisRef =
      FirebaseFirestore.instance.collection('unis');

  Future<List<Uni>> fetchUnis() async {
    final snapshot = await _unisRef.get();
    final unis = snapshot.docs.map((doc) => Uni.fromJson(doc.data())).toList();

    return unis;
  }
}
