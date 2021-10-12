import 'dart:math';

import 'package:ptut_game/abstract/a_classic_card.dart';

class heure_de_permis extends a_card_classic {
  heure_de_permis(String name, String description, int id, int point_bm) : super(name, description, id, point_bm);

  @override
  void effect()
  {
    String str("Mettre la description");
    log(getDescription(str));
    addPoint(2);
  }
}