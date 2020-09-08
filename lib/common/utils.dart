import 'package:cloud_firestore/cloud_firestore.dart';

class Utils {
  static DateTime timestampToDatetime(Timestamp timestamp) {
    return timestamp.toDate();
  }

  static Timestamp datetimeToTimestamp(DateTime datetime) {
    return Timestamp.fromDate(datetime);
  }
}
