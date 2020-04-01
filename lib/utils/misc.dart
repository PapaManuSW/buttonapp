import 'package:button_app/utils/firebaseUtils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ntp/ntp.dart';

const int _nextTimeAbsoluteValueInHours = 24;

Future<double> computePercentage(DateTime lastTimestampOnServer) async {
  DateTime now = await getCurrentTime();
  int differenceInHours = lastTimestampOnServer.difference(now).inHours;
  return differenceInHours / _nextTimeAbsoluteValueInHours;
}

Future<DateTime> getCurrentTime() async {
  return NTP.now(); // Internet based
  // return Timestamp.now();
  // return DateTime.now();
}

verifyPressOnTime(DateTime countDown) async {
  DateTime now = await getCurrentTime();
  const int slack = 1; //hours
  var differenceInHours = countDown.difference(now).inHours;
  if (differenceInHours > slack) {
    print("Too early: " + differenceInHours.toString());
    resetHitCounter('labels_collection', 'test_label1');
  } else if (differenceInHours < -slack) {
    print("Too late: " + differenceInHours.toString());
    resetHitCounter('labels_collection', 'test_label1');
  } else {
    incrementHitCounter('labels_collection', 'test_label1');
    updateTimeStamp(
        'labels_collection',
        'test_label1',
        Timestamp.fromDate(
            now.add(new Duration(hours: _nextTimeAbsoluteValueInHours))));
    print("On time!!!");
  }
}
