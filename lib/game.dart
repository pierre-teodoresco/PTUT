
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ptut_game/game_settings.dart';

class GameGUI extends State<GameGUIState>{


  int playernb = 0;

  List<TableRow> addLeftTable(){
    List<TableRow> childs = [];
    for(int i = 0; i< GameMenuSettings.playerList.length; i++){
      childs.add(TableRow(children: [
          Text(GameMenuSettings.playerList[i].getName()+ " : "+ GameMenuSettings.playerList[i].getPoint().toString()),
      ]));
    }
    return childs;
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
        color: Color(0XFFF5BB00),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Case : "+GameMenuSettings.playerList[playernb].getCase().toString()),
                Text("C'est au tour de ",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      color: Colors.grey,
                      fontSize: 22,
                    ),
                ),
                Text("Points : "+GameMenuSettings.playerList[playernb].getPoint().toString(),
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    color: Colors.red,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            Text(GameMenuSettings.playerList[playernb].getName(),
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                color: Colors.grey,
                fontSize: 22,
              ),
            ),

            Align(
              alignment: Alignment.topLeft,
              child: Container(
                width: 30,
                constraints: BoxConstraints(maxWidth: 200),
                child:
                  Table(
                      border: TableBorder.all(color: Colors.black),
                      children:
                      addLeftTable()
                  )
              )
            )
            ]
          ),

      ),


    );

  }


}

class GameGUIState extends StatefulWidget{
  @override
  GameGUI createState() => GameGUI();
}