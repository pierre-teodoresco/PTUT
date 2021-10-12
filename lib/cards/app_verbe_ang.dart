import 'dart:math';

import 'package:ptut_game/abstract/a_classic_card.dart';

class app_verbe_ang extends a_card_classic {
  app_verbe_ang(String name, String description, int id, int point_bm) : super(name, description, id, point_bm);

  @override
  void effect()
  {
    addPoint(2);
  }
}