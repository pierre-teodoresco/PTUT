import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ptut_game/scheduler/player.dart';

import '../delayed_animation.dart';
import 'game_settings.dart';

class GameOverGUI extends State<GameOverGUIState> {


  @override
  Widget build(BuildContext contect){
    return Scaffold(
        backgroundColor: Color(0xFFEDECF2),
        body: SingleChildScrollView(
          child: Container(
              margin: EdgeInsets.symmetric(
                vertical: 60,
                horizontal: MediaQuery.of(contect).size.width/4,
              ),
              child: Column(
                children:  [
                  DelayedAnimation(
                    delay: 500,
                    child: Container(
                      height: 150,
                      child: const FlutterLogo(size:100),
                    ),
                  ),
                  DelayedAnimation(
                    delay: 1200,
                    child: Text('Gagnant : ' + getWinner()),
                  ),
                  DelayedAnimation(
                      delay: 1200,
                      child: Table(
                          border: TableBorder.all(),
                          children:
                          getLeaderBoard()
                      )
                  ),
                ],
              )
          ),)
    );
  }

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

}
class GameOverGUIState extends StatefulWidget{
  @override
  GameOverGUI createState() => GameOverGUI();
}