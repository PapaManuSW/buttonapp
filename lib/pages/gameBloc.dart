import 'dart:async';

import 'package:button_app/models/UIData.dart';
import 'package:button_app/utils/firebaseUtils.dart';
import 'package:button_app/utils/misc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GameBloc {
  static GameBloc _instance;
  static const NEXT_CLICK_AT = 'nextClickAt';
  static const STREAK = 'streak';

  StreamController<UIData> _uiDataStream = StreamController<UIData>.broadcast();

  int _streak;
  double _percentageRemainingTime;
  String _remainingTimeText = '';
  Timer _timer;
  DocumentSnapshot _data;
  int _remainingTimeSeconds;

  int get days => _streak;

  factory GameBloc(userId) {
    if (_instance == null) {
      _instance = GameBloc._(userId);
    }
    return _instance;
  }

  GameBloc._(userId) {
    _initFireStoreStream(userId);
  }

  Stream<UIData> get uiDataStream {
    return _uiDataStream.stream;
  }

  _initFireStoreStream(userId) {
    initFirestoreGameDataStreamForUser(userId, _onDataChanged);
  }

  _onDataChanged(DocumentSnapshot data) {
    _data = data;
    _streak = data['streak'];
    startCountDown();
  }

  startCountDown() {
    if (_timer == null) {
      _timer = Timer.periodic(Duration(seconds: 1), ((Timer t) {
        _refreshData();
      }));
    }
  }

  Future _refreshData() async {
    var nextClickDateTime = _data[NEXT_CLICK_AT].toDate();
    _remainingTimeSeconds = await computeRemainingTimeInSeconds(nextClickDateTime);
    _calculatePercentageRemainingTime(_remainingTimeSeconds);
    _buildTextRemainingTime(_remainingTimeSeconds);
    _uiDataStream.add(UIData(_streak, _percentageRemainingTime, _remainingTimeText, _remainingTimeSeconds));
  }

  void _calculatePercentageRemainingTime(int differenceInSeconds) {
    const secondsInOneDay = 60 * 60 * 24;
    var percentage = differenceInSeconds / secondsInOneDay;
    _percentageRemainingTime = percentage;
  }

  void _buildTextRemainingTime(int differenceInSeconds) {
    var remainingTime = Duration(seconds: differenceInSeconds);
    final List<String> parts = remainingTime.toString().split(":");
    final String hour = parts[0].padLeft(2, '0');
    final String minutes = parts[1].padLeft(2, '0');
    final String seconds = parts[2].split(".")[0].padLeft(2, '0');
    _remainingTimeText = '$hour:$minutes:$seconds';
  }

  stopCountDown() {
    if (_timer != null && _timer.isActive) {
      _timer.cancel();
    }
  }

  double get countDownPercentage => _percentageRemainingTime;

  String get remainingTimeText => _remainingTimeText;

  Timer get timer => _timer;

  DocumentSnapshot get data => _data;

  int get differenceInSeconds => _remainingTimeSeconds;
}
