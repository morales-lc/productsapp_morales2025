import 'package:flutter/material.dart';

// =================== LANGUAGE MODEL ===================
/// LanguageModel
///
/// ChangeNotifier for managing the app's language state.
/// Allows switching between English and Filipino, and notifies listeners on change.
class LanguageModel extends ChangeNotifier {
  String _language = "English"; // default

  String get language => _language;

  void setLanguage(String lang) {
    _language = lang;
    notifyListeners();
  }

  bool isFilipino() => _language == "Filipino";
}
// =================== END LANGUAGE MODEL ===================
