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
  Color _secondBtn = Color.fromRGBO(0, 105, 92, 1);
  Color _buyBtn = Color.fromRGBO(0, 105, 95, 1);
  Color _cartBtn = Color.fromRGBO(240, 155, 27, 1);
  Color _ratingColor = Color.fromRGBO(255, 152, 0, 1); // default rating color

  void applyPurpleTheme() {
    _currentTheme = "purple";
    _scaffoldBgColor = const Color.fromRGBO(240, 230, 255, 1); // light violet
    _appBarColor = Colors.deepPurple.shade400;
    _drawerHeaderColor = Colors.deepPurple;
    _buttonColor = const Color.fromARGB(255, 95, 49, 180); // lavender
    _accentColor = Colors.deepPurple;
    _textColor = Color.fromARGB(255, 95, 49, 180); // white text color
    _secondBtn = Color.fromRGBO(25, 91, 246, 1);
    _buyBtn = Color.fromRGBO(255, 119, 14, 1);
    _cartBtn = Color.fromRGBO(255, 14, 14, 1);
    _ratingColor =
        Color.fromRGBO(186, 104, 200, 1); // A soft purple accent (Purple[300])
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
    _secondBtn = Color.fromRGBO(0, 105, 92, 1);
    _buyBtn = Color.fromRGBO(0, 105, 95, 1);
    _cartBtn = Color.fromRGBO(240, 155, 27, 1);
    _ratingColor = Color.fromRGBO(255, 152, 0, 1);
    notifyListeners();
  }

  Color get background => _scaffoldBgColor;
  Color get appBar => _appBarColor;
  Color get drawerHeader => _drawerHeaderColor;
  Color get button => _buttonColor;
  Color get accent => _accentColor;
  Color get textColor => _textColor;
  Color get secondBtn => _secondBtn;
  Color get buyBtn => _buyBtn;
  Color get cartBtn => _cartBtn;
  Color get ratingColor => _ratingColor;

  String get theme => _currentTheme;
}
