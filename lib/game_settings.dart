import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ptut_game/delayed_animation.dart';
import 'package:ptut_game/main.dart';

class GameMenuSettings extends State<GameMenuSettingsState>{

  int nbruser = 4;
  int nbusermax = 6;
  int nbusermin = 2;

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
                    margin: EdgeInsets.only(
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
                    height: 50,
                    width: double.infinity,
                    child: Row(
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
                        InkWell(
                            onTap: () {},
                            child: Icon(
                              Icons.remove,
                              color: Colors.white,
                              size: 16,
                            )),
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
                      children: <Widget>[
                        for (int i=1; i<nbruser+1; i++)
                          createTextFIld(i).first
                      ],
                    ),
                  ),
                ),
              ],
            )
        ),)
    );
  }
}



List<Widget> createTextFIld(int i){
  return [
    Text('Nom utilisateur : $i'),
  const TextField(
    decoration: InputDecoration(
    border: OutlineInputBorder(),
    hintText: 'Pseudo'
    )
  ),
  ];
}
Widget createTextInput(int i){
  return const TextField(
      decoration: InputDecoration(
      border: OutlineInputBorder(),
  hintText: 'Pseudo'
  ));
}
class GameMenuSettingsState extends StatefulWidget{
  @override
  GameMenuSettings createState() => GameMenuSettings();
}