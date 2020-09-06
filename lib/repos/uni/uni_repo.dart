import 'package:cloud_firestore/cloud_firestore.dart';

import 'models/models.dart';

export 'models/models.dart';

class UniRepo {
  final CollectionReference _unisRef =
      FirebaseFirestore.instance.collection('unis');

  Future<List<Uni>> fetchUnis() async {
    final snapshot = await _unisRef.orderBy('name').get();
    final unis = snapshot.docs.map((doc) {
      final data = doc.data();
      final faculties = List.from(data['faculties']);
      faculties.sort();
      data['faculties'] = faculties;

      return Uni.fromJson(data);
    }).toList();

    return unis;
  }
}
