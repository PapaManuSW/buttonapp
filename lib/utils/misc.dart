import 'package:ntp/ntp.dart';

const int _nextTimeAbsoluteValueInMinutes = 60 * 24;

DateTime nextTimeToPress(DateTime now) {
  return now.add(new Duration(minutes: _nextTimeAbsoluteValueInMinutes));
}

Future<double> computePercentage(DateTime lastTimestampOnServer) async {
  DateTime now = await getCurrentTime();
  int differenceInMinutes = lastTimestampOnServer.difference(now).inMinutes;
  return differenceInMinutes / _nextTimeAbsoluteValueInMinutes;
}

Future<DateTime> getCurrentTime() async {
  return NTP.now(); // Internet based
  // return Timestamp.now();
  // return DateTime.now();
}

Future<bool> verifyPressOnTime(DateTime countDown) async {
  DateTime now = await getCurrentTime();
  const int slack = 60; //minutes
  var differenceInMinutes = countDown.difference(now).inMinutes;
  return true;
  if (differenceInMinutes > slack) {
    print("Too early: " + differenceInMinutes.toString());
    return false;
  } else if (differenceInMinutes < -slack) {
    print("Too late: " + differenceInMinutes.toString());
    return false;
  } else {
    print("On time!!!");
    return true;
  }
}
