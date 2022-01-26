import 'package:ptut_game/abstract/a_card.dart';

class Player {

  late String name;
  late int point, box, lap;
  bool haveGf = false;
  List<String> mates = [];

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

  bool hasGf() {
    return haveGf;
  }

  void setGf(bool haveGf) {
    this.haveGf = haveGf;
  }

  List<String> getMates() {
    return mates;
  }

  void setMates(List<String> mates) {
    this.mates = mates;
  }

  void addPoint(int point) {
    this.point += point;
  }

  bool hasMate(String mate) {
    bool here = false;
    for (String str in mates) {
      here = str == mate;
      if (here) return here;
    }
    return here;
  }

  void addMate(String mate) {
    mates.add(mate);
  }

  void removeMate(String mate) {
    mates.remove(mate);
  }

  @override
  String toString() {
    return "(name: $name, point: $point, case: $box)";
  }
}