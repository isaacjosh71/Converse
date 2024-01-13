import 'package:flutter/cupertino.dart';

class SkillNotifier extends ChangeNotifier {

  bool _addSkills = false;
  bool get addSkills => _addSkills;

  set setSkills(bool newState){
    _addSkills = newState;
    notifyListeners();
  }

  String _addSkillsId = '';
  String get addSkillsId => _addSkillsId;

  set setSkillsId(String newState){
    _addSkillsId = newState;
    notifyListeners();
  }

  String _logoUrl = '';
  String get logoUrl => _logoUrl;

  void setLogoUrl(String newState){
    _logoUrl = newState;
    notifyListeners();
  }
}