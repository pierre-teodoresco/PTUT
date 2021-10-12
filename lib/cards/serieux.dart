import 'dart:math'

import 'package:ptut_game/abstract/a_classic_card.dart';

class serieux extends a_card_classic {
  serieux(String name, String description, int id, int point_bm) : super(name, description, id, point_bm);

  @override
  void effect() {
    String str ("Pas un bruit. Premier rang + 1 point ")
    print(getDescription());
    addPoint(2);
  }