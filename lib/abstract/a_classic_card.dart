import 'a_card.dart';

abstract class a_card_classic extends a_card {
  int _point_bm;

  a_card_classic(String name, String description, int id, this._point_bm) : super(name, description, id);

  void effect();
}