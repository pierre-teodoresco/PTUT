import 'dart:math';

import 'package:ptut_game/abstract/a_classic_card.dart';

class radiateur_hiver extends a_card_classic {
  radiateur_hiver(String name, String description, int id, int point_bm) : super(name, description, id, point_bm);

  @override
  void effect() {
    String str("L'hiver est arrivé et vous habitez dans le nord. "
        "Après un combat sanglant avec vos camarades, vous pouvez calinner le saint chauffage.")
    log(getDescription(str));
    addPoint(2);
}