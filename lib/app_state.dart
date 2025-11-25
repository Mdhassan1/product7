import 'package:flutter/material.dart';

class FFAppState extends ChangeNotifier {
  static FFAppState _instance = FFAppState._internal();

  factory FFAppState() {
    return _instance;
  }

  FFAppState._internal();

  static void reset() {
    _instance = FFAppState._internal();
  }

  Future initializePersistedState() async {}

  void update(VoidCallback callback) {
    callback();
    notifyListeners();
  }

  String _filePath = '';
  String get filePath => _filePath;
  set filePath(String value) {
    _filePath = value;
  }

  bool _AgreedforTAC = false;
  bool get AgreedforTAC => _AgreedforTAC;
  set AgreedforTAC(bool value) {
    _AgreedforTAC = value;
  }
}
