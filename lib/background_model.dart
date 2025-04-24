import 'package:flutter/material.dart';

class Backgroundmodel extends ChangeNotifier {
  final _color = {'r': 255, 'g': 255, 'b': 255};

  void changeBkg(int r, int g, int b) {
    _color['r'] = r;
    _color['g'] = g;
    _color['b'] = b;
    notifyListeners();
  }

  void reset() {
    _color['r'] = 255;
    _color['g'] = 255;
    _color['b'] = 255;
    notifyListeners();
  }

  getBkg() {
    return Color.fromRGBO(_color['r']!, _color['g']!, _color['b']!, 1);
  }
}
