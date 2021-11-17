import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ptut_game/abstract/a_card.dart';
import 'package:ptut_game/delayed_animation.dart';
import 'package:ptut_game/main.dart';
import 'package:ptut_game/scheduler/player.dart';

class GameMenuSettings extends State<GameMenuSettingsState>{

  static List<player> playerList = [];
  int nbruser = 4;
  int nbusermax = 6;
  int nbusermin = 2;
  String errormsg = "";
  List<TextEditingController> controllers= [];
  List<TextField> textList = [];

  HashMap test = new HashMap<TextEditingController, TextField>();
  void _incrementCount(){
    setState(() {
      if(nbruser == nbusermax) return;
      nbruser++;
    });
  }
  void _decrementCount(){
    setState(() {
      if(nbruser == nbusermin) return;
      nbruser--;
    });
  }


  void checkButton(){
    for(int i =0; i< controllers.length; i++){
      playerList.add(new player(controllers[i].text, 0, new List<a_card>.empty()));
      print(controllers[i].text);
    }

    print(playerList.toString());
    print(playerList[1].getName());

  }
  @override
  Widget build(BuildContext contect){
    return Scaffold(
        backgroundColor: Color(0xFFEDECF2),
        body: SingleChildScrollView(child: Container(
            margin: EdgeInsets.symmetric(
              vertical: 60,
              horizontal: 30,
            ),
            child: Column(
              children:  [
                DelayedAnimation(
                  delay: 500,
                  child: Container(
                    height: 150,
                    child: FlutterLogo(size:100),
                  ),
                ),
                DelayedAnimation(
                  delay: 1500,
                  child: Container(
                    margin: const EdgeInsets.only(
                      top: 30,
                      bottom: 20,
                    ),
                    child: Text('Veuillez choisir un nombre de joueur (compris entre 2 et 6)',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        color: Colors.grey,
                        fontSize: 15,
                      ),),

                  ),
                ),
                DelayedAnimation(
                  delay: 2500,
                  child: Container(
                    margin: EdgeInsets.all(20),
                    alignment: Alignment.center,
                    height: 50,
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        OutlinedButton.icon(
                          onPressed: () {
                            _decrementCount();
                          },
                          icon: Icon(Icons.remove, size: 18),
                          label: Text("Retirer"),
                        ),
                         Text(
                          'Nombre de Joueur : $nbruser',
                        ),
                        OutlinedButton.icon(
                          onPressed: () {
                            _incrementCount();
                          },
                          icon: Icon(Icons.add, size: 18),
                          label: Text("Ajouter"),
                        )
                      ],
                    ),
                  ),
                ),

                DelayedAnimation(

                  delay: 2500,
                  child: Container(
                    margin: EdgeInsets.all(20),
                    width: double.infinity,
                    child: Column(

                      children: getList(nbruser)
                    ),
                  ),
                ),

                OutlinedButton.icon(
                  onPressed: () {
                    checkButton();
                  },
                  icon: Icon(Icons.check, size: 18),
                  label: Text("Commencer la partie"),
                )
              ],
            )
        ),)
    );
  }

  List<Widget> getList(int nbu) {
    if(!controllers.isEmpty) controllers.forEach((element) => element.dispose());
    controllers = List.generate(nbu+1, (index) => TextEditingController());
    List<Widget> childs = [];

    childs.add(Text(errormsg));
    for (var i = 1; i < nbu+1; i++) {
      childs.add(Text('Nom utilisateur : $i'));
      TextField textf = TextField(
        controller: controllers[i],
        decoration: InputDecoration(
          hintText: "Pseudo"
        ),
      );
      test.putIfAbsent(controllers[i], () => textf);
      textList.add(textf);
      childs.add(textf);
    }
    return childs;
  }
}


class GameMenuSettingsState extends StatefulWidget{
  @override
  GameMenuSettings createState() => GameMenuSettings();
}