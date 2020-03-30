import 'package:button_app/utils/firebaseUtils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

const int _nextTimeAbsoluteValueInSeconds = 50;

double computePercentage(DateTime lastTimestampOnServer) {
  DateTime now = Timestamp.now().toDate();
  int differenceInSeconds = lastTimestampOnServer.difference(now).inSeconds;
  return differenceInSeconds / _nextTimeAbsoluteValueInSeconds;
}

verifyPressOnTime(DateTime countDown) {
  DateTime now = Timestamp.now().toDate();
  const int slack = 40; //seconds
  var differenceInSeconds = countDown.difference(now).inSeconds;
  if (differenceInSeconds > slack) {
    print("Too early: " + differenceInSeconds.toString());
    resetHitCounter('labels_collection', 'test_label2');
  } else if (differenceInSeconds < -slack) {
    print("Too late: " + differenceInSeconds.toString());
    resetHitCounter('labels_collection', 'test_label2');
  } else {
    incrementHitCounter('labels_collection', 'test_label2');
    updateTimeStamp(
        'labels_collection',
        'test_label2',
        Timestamp.fromDate(DateTime.now()
            .add(new Duration(seconds: _nextTimeAbsoluteValueInSeconds))));
    print("On time!!!");
  }
}
