const int _nextTimeAbsoluteValueInMinutes = 60 * 24;

DateTime nextTimeToPress(DateTime now) {
  return now.add(new Duration(minutes: _nextTimeAbsoluteValueInMinutes));
}

Future<int> computeRemainingTimeInSeconds(DateTime nextClickAt) async {
  DateTime now = await getCurrentTime();
  int difference = nextClickAt.difference(now).inSeconds;
  return difference;
}

Future<DateTime> getCurrentTime() async {
  //return NTP.now(); // Internet based
  // return Timestamp.now();
  return DateTime.now();
}

Future<bool> verifyPressOnTime(int differenceInMinutes) async {
  const int slack = 60; //minutes
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
