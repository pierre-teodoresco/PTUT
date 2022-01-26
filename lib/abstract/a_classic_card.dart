import 'a_card.dart';
import '../scheduler/player.dart';

abstract class a_classic_card extends a_card {
  int _point_bm;

  a_classic_card(String name, String description, int id, this._point_bm) : super(name, description, id);

  void effect(Player p);
}