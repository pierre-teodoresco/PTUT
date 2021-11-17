import 'package:ptut_game/abstract/a_card.dart';

class player {

  late String name;
  late int point;
  late List<a_card> cardList;

  player(String name, int point, List<a_card> cardList) {
    this.name = name;
    this.point = point;
    this.cardList = cardList;
  }

  String getName() {
    return name;
  }

  void setName(String name) {
    this.name = name;
  }

  int getPoint() {
    return point;
  }

  void setPoint(int point) {
    this.point = point;
  }

  List<a_card> getCardList() {
    return cardList;
  }

  void setCardList(List<a_card> cardList) {
    this.cardList = cardList;
  }

  @override
  String toString() {
    return "(name: $name, point: $point, cards: $cardList)";
  }

}