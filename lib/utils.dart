import 'package:flutter/cupertino.dart';
import 'package:ptut_game/scheduler/player.dart';

import 'iu/game_settings.dart';

///
/// Definition des constantes
///

const String POTE_1 = "Bryan";
const String POTE_2 = "Melinda";
const String POTE_3 = "Josiane";
const String POTE_4 = "Luc";

///
/// Definition de fonction externes
///

String getWinner() {
  return GameMenuSettings.playerList.reduce((a, b) => a.getPoint() > b.getPoint() ? a : b).getName();
}

List<TableRow> getLeaderBoard() {
  List<TableRow> widgetChildren = [];
  widgetChildren.add (const TableRow(
    children: [
      Text("Pseudo"),
      Text("Points"),
    ],
  ),);

  List<Player> sortedPlayerList = GameMenuSettings.playerList;
  sortedPlayerList.sort((a,b) => b.getPoint().compareTo(a.getPoint()));
  for (Player p in sortedPlayerList) {
    widgetChildren.add(TableRow(children: [
      Text(p.getName()),
      Text(p.getPoint().toString()),
    ]));
  }
  return widgetChildren;
}