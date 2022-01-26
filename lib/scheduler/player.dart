import 'package:ptut_game/abstract/a_card.dart';

class Player {

  late String name;
  late int point, box, lap;
  bool haveGf = false;

  Player(this.name, this.point, this.box, this.lap);

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
    return box;
  }

  int getLap() {
    return lap;
  }

  void setLap(int lap) {
    this.lap = lap;
  }

  void setCase(int box) {
    this.box = box;
  }

  bool isGf() {
    return haveGf;
  }

  void setGf(bool haveGf) {
    this.haveGf = haveGf;
  }

  @override
  String toString() {
    return "(name: $name, point: $point, case: $box)";
  }
}