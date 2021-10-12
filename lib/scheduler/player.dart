import 'package:ptut_game/abstract/a_card.dart';

class player {
  String _name;
  int _point;
  List<a_card> _cards;

  player(this._name, this._point, this._cards);

  String get name => _name;

  set name(String str) {
    _name = str;
  }

  void addCard(a_card card) {
    this._cards.add(card);
  }

  void addPoint(int point) {
    this._point += point;
  }

  int get point => _point;

  set point(int value) {
    _point = value;
  }

  List<a_card> get cards => _cards;

  set cards(List<a_card> value) {
    _cards = value;
  }

}