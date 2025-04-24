import 'package:flutter/material.dart';

class Backgroundmodel extends ChangeNotifier {
  String _currentTheme = "default";

  // Theme colors
  Color _scaffoldBgColor = Colors.pinkAccent;
  Color _appBarColor = Colors.pinkAccent;
  Color _drawerHeaderColor = Colors.pinkAccent;
  Color _buttonColor = Colors.pink;
  Color _accentColor = Colors.pinkAccent;
  Color _textColor = Color.fromRGBO(255, 64, 129, 1); // default text color

  void applyPurpleTheme() {
    _currentTheme = "purple";
    _scaffoldBgColor = const Color.fromRGBO(240, 230, 255, 1); // light violet
    _appBarColor = Colors.deepPurple.shade400;
    _drawerHeaderColor = Colors.deepPurple;
    _buttonColor = const Color.fromARGB(255, 95, 49, 180); // lavender
    _accentColor = Colors.deepPurple;
    _textColor = Color.fromARGB(255, 95, 49, 180); // white text color
    notifyListeners();
  }

  void reset() {
    _currentTheme = "default";
    _scaffoldBgColor = Colors.pinkAccent;
    _appBarColor = Colors.pinkAccent;
    _drawerHeaderColor = Colors.pinkAccent;
    _buttonColor = Colors.pink;
    _accentColor = Colors.pinkAccent;
    _textColor = Color.fromRGBO(255, 64, 129, 1);
    notifyListeners();
  }

  Color get background => _scaffoldBgColor;
  Color get appBar => _appBarColor;
  Color get drawerHeader => _drawerHeaderColor;
  Color get button => _buttonColor;
  Color get accent => _accentColor;
  Color get textColor => _textColor;
  String get theme => _currentTheme;
}
