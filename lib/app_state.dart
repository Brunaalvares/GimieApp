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
    // Store previous state for comparison
    final prevLink = _link;
    final prevNome = _nome;
    final prevPrice = _price;
    final prevImageurl = _imageurl;
    final prevLinkdoProduto = _linkdoProduto;
    
    callback();
    
    // Only notify listeners if state actually changed
    if (_link != prevLink || 
        _nome != prevNome || 
        _price != prevPrice || 
        _imageurl != prevImageurl || 
        _linkdoProduto != prevLinkdoProduto) {
      notifyListeners();
    }
  }

  String _link = 'urlaqui[link]';
  String get link => _link;
  set link(String value) {
    _link = value;
  }

  String _nome = '';
  String get nome => _nome;
  set nome(String value) {
    _nome = value;
  }

  double _price = 0.0;
  double get price => _price;
  set price(double value) {
    _price = value;
  }

  String _imageurl = '';
  String get imageurl => _imageurl;
  set imageurl(String value) {
    _imageurl = value;
  }

  String _linkdoProduto = '';
  String get linkdoProduto => _linkdoProduto;
  set linkdoProduto(String value) {
    _linkdoProduto = value;
  }
}
