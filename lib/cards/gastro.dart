import 'dart:math';

import 'package:ptut_game/abstract/a_classic_card.dart';


class gastro extends a_card_classic {
  gastro(String name, String description, int id, int point_bm) : super(name, description, id, point_bm);

  @override
  void effect() {
    String str("Mettre le text")
    log(getDescription(str));
    addPoint(2);
  }
}