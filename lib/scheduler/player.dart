import 'package:ptut_game/abstract/a_card.dart';

class player {

  late String name;
  late int point, pcase,annee;
  //late List<a_card> cardList;

  player(String name, int point, int pcase, int annee /*List<a_card> cardList*/) {
    this.name = name;
    this.point = point;
    this.pcase = pcase;
    this.annee = annee;
    //this.cardList = cardList;
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

  int getCase() {
    return pcase;
  }

  int getAnnee(){
    return annee;
  }

  void setAnnee(int annee){
    this.annee = annee;
  }

  void setCase(int pcase) {
    this.pcase = pcase;
  }

  /*List<a_card> getCardList() {
    return cardList;
  }

  void setCardList(List<a_card> cardList) {
    this.cardList = cardList;
  }*/

  @override
  String toString() {
    return "(name: $name, point: $point, case: $pcase)";
  }

}