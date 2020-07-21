import 'dart:async';

import 'package:button_app/utils/firebaseUtils.dart';
import 'package:button_app/utils/misc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GameBloc {
  static GameBloc _instance;
  static const NEXT_CLICK_AT = 'nextClickAt';
  static const STREAK = 'streak';

  //StreamController<List<PageModel>> _refreshControllerPages = new StreamController<List<PageModel>>.broadcast();

  int _days;
  double _percentageRemainingTime;
  String _countDownText = '';
  Timer _timer;
  DocumentSnapshot _data;
  int _remainingTimeSeconds;
  Function _onStreakChanged;
  Function _onTickText;
  Function _onTickProgressCircle;

  int get days => _days;

  factory GameBloc() {
    if (_instance == null) {
      _instance = GameBloc._();
    }
    return _instance;
  }

  initFireStoreStream(userId, onStreakChanged, onTickText, onTickProgressCircle) {
    initFirestoreGameDataStreamForUser(userId, onDataChanged);
    _onStreakChanged = onStreakChanged;
    _onTickProgressCircle = onTickProgressCircle;
    _onTickText = onTickText;
  }

  onDataChanged(DocumentSnapshot data) {
    _data = data;
    _days = data['streak'];
    _onStreakChanged(_days);
    startCountDown(_onTickText, _onTickProgressCircle);
  }

  startCountDown(onTickText, onTickProgressCircle) {
    Timer.periodic(Duration(seconds: 1), ((Timer t) {
      _refreshData();
    }));
  }

  Future _refreshData() async {
    var nextClickDateTime = _data[NEXT_CLICK_AT].toDate();
    _remainingTimeSeconds = await computeRemainingTimeInSeconds(nextClickDateTime);
    _calculatePercentageRemainingTime(_remainingTimeSeconds);
    _buildTextRemainingTime(_remainingTimeSeconds);
  }

  Future<void> _calculatePercentageRemainingTime(int differenceInSeconds) async {
    const secondsInOneDay = 60 * 60 * 24;
    var percentage = differenceInSeconds / secondsInOneDay;
    _percentageRemainingTime = percentage;
    _onTickProgressCircle(_percentageRemainingTime);
  }

  void _buildTextRemainingTime(int differenceInSeconds) {
    var remainingTime = Duration(seconds: differenceInSeconds);
    final List<String> parts = remainingTime.toString().split(":");
    final String hour = parts[0].padLeft(2, '0');
    final String minutes = parts[1].padLeft(2, '0');
    final String seconds = parts[2].split(".")[0].padLeft(2, '0');
    _countDownText = '$hour:$minutes:$seconds';
    _onTickText(_countDownText);
  }

  stopCountDown() {
    _timer.cancel();
  }

  GameBloc._();

  double get countDownPercentage => _percentageRemainingTime;

  String get countDownText => _countDownText;

  Timer get timer => _timer;

  DocumentSnapshot get data => _data;

  int get differenceInSeconds => _remainingTimeSeconds;
}
