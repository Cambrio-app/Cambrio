import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TutorialsState extends ChangeNotifier {
  bool _editClicked = false;
  late final SharedPreferences prefs;
  static late final TutorialsState instance;

  TutorialsState._({required this.prefs});

  static Future<TutorialsState> initInstance() async {
    instance = TutorialsState._(prefs: await SharedPreferences.getInstance());
    return instance;
  }

  bool get showAddBooksTutorial {
    return (_editClicked && (prefs.getBool('seenTutorial') == false));
  }

  set editClicked(bool val) {
    _editClicked = val;
    notifyListeners();
  }
  bool get editClicked {
    return _editClicked;
  }

  void setSawTutorial() {
    prefs.setBool('seenTutorial', true);
    debugPrint('wont show the tutorial anymore');
    notifyListeners();
  }
  void resetSawTutorial() {
    prefs.setBool('seenTutorial', false);
    debugPrint('will show the tutorial again');
    notifyListeners();
  }
}