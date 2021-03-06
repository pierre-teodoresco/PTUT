
import 'dart:core';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ptut_game/iu/game_settings.dart';
import 'package:ptut_game/iu/menu.dart';
import 'package:ptut_game/main.dart';
import 'package:ptut_game/scheduler/player.dart';

import '../delayed_animation.dart';
import '../utils.dart';
import 'gameover.dart';

class GameGUI extends State<GameGUIState>{

  static int playernb = 0;
  int year = 1;
  bool isShifumi = false;
  int randomimg = 1;

  List<TableRow> addLeftTable(){
    List<TableRow> childs = [];
    for(int i = 0; i< GameMenuSettings.playerList.length; i++){
      childs.add(TableRow(children: [
        Text(GameMenuSettings.playerList[i].getName()+ " : "+ GameMenuSettings.playerList[i].getPoint().toString()),
      ]));
    }
    return childs;
  }

  List<String> effectString = [];
  List<Widget> action = [];

  int reponse = 0;
  var reponsemax = "";


  void _incrementCount(){
    setState(() {
      if(reponse == int.parse(reponsemax)) return;
      reponse++;
    });
  }
  void _decrementCount(){
    setState(() {
      if(reponse == 0) return;
      reponse--;
    });
  }


  ///
  /// \brief Affecte les effets de la carte
  ///
  /// Correspond à l'analyse des effect d'une carte en fonction d'id
  /// Analyse de l'effect pour savoir si il comporte un prefix, sinon renvoi du texte.
  /// \param cardnumber ID de la carte (dispo JSON)
  ///
  void giveEffect(int cardnumber){
    action.clear();
    effectString.clear();
    MainMenu.cardlist[cardnumber].getEffect().forEach((element) {
      if(element.startsWith('removepoint-')){
        print("remove de point ..");
        var point = element;
        var pointremove = point.substring(12);
        GameMenuSettings.playerList[playernb].removePoint(int.parse(pointremove));
      }else if(element.startsWith('removecase')){

      }else if(element.startsWith('addpoint-')){
        /// Ajout de point au joueur
        var point = element;
        var pointadd = point.substring(9);
        GameMenuSettings.playerList[playernb].addPoint(int.parse(pointadd));
      }else if(element.startsWith('addpointall-')){
        var point = element;
        var pointadd = point.substring(12);
        GameMenuSettings.playerList.forEach((element) { element.addPoint(int.parse(pointadd));});

      }else if(element.startsWith('removepointall-')) {
        var point = element;
        var pointremove = point.substring(15);
        GameMenuSettings.playerList.forEach((element) {
          element.removePoint(int.parse(pointremove));
        });
      }else if(element.startsWith('stealpoint-')){
        var point = element;
        var pointremove = point.substring(11);
        var playerMax = GameMenuSettings.playerList[0];
        GameMenuSettings.playerList.forEach((element) {
          if(element.getPoint() > element.getPoint()) playerMax = element;
        });
        playerMax.removePoint(int.parse(pointremove));
        GameMenuSettings.playerList[playernb].addPoint(int.parse(pointremove));

      } else if(element.startsWith('coinflip-')){
        action.add(
            ElevatedButton(
                onPressed: () {
                  var point = element;
                  var pointflip = point.substring(9, 10);
                  if((GameMenuSettings.playerList[playernb].getPoint() <= int.parse(pointflip))) GameMenuSettings.playerList[playernb].setPoint(0);
                  else GameMenuSettings.playerList[playernb].addPoint(int.parse(pointflip));
                  Navigator.pop(context, true);
                },
                child: Text('Pile',
                  style: GoogleFonts.poppins(

                    color: Colors.black54,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                )
            )
        );
        action.add(
            ElevatedButton(
                onPressed: () {
                  var point = element;
                  var pointflip = point.substring(11, 12);
                  GameMenuSettings.playerList[playernb].addPoint(int.parse(pointflip));
                  print(pointflip);
                  Navigator.pop(context, true);
                },
                child: Text('Face',
                  style: GoogleFonts.poppins(
                    color: Colors.black54,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                )
            )
        );
      } else if (element.startsWith("irl-")){
        var point = element;
        reponsemax = point.substring(4);
        action.add(OutlinedButton.icon(
          onPressed: () {
            _decrementCount();
            Navigator.pop(context, false);
          },
          icon: Icon(Icons.remove, size: 18),
          label: Text('Retirer'),
        ));
        action.add(Text(
          ' $reponse',
        ));
        action.add(OutlinedButton.icon(
          onPressed: () {
          },
          icon: Icon(Icons.add, size: 18),
          label: Text('Ajouter'),
        ));
      }else{
        effectString.add(element.toString());
      }
    });
  }

  ///
  /// \brief check la condition de fin de partie à la fin du 6eme tour
  ///
  void gameOver(Player p) {
    if (p.getLap() >= 6) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => GameOverGUIState()));
    }
  }

  ///
  /// \brief effectue le bonus de point lié aux copines à chaque tour
  ///
  void gfManager(Player p) {
    if(p.hasGf()) {
      switch(year) {
        case 1 :
          p.addPoint(3);
          break;
        case 2 :
          p.addPoint(5);
          break;
        case 3 :
          p.addPoint(7);
          break;
        default :
          break;
      }
    }
  }

  ///
  /// \brief gère l'année globale
  ///
  bool yearManager() {
    int lap = 0;
    for (Player p in GameMenuSettings.playerList) {
      if (p.getLap() >= lap) {
        lap = p.getLap();
      }
    }
    if (lap % 2 == 0) {
      yearPopUp();
      ++year;
      for (Player p in GameMenuSettings.playerList) {
        p.setCase(0);
        p.setLap(lap);
        matesPointManager(p);
      }
      return true;
      // possible gestion carte règlement
    } else {
      return false;
    }
  }

  ///
  /// \brief check si le mate est open
  ///
  bool isMateTaken(String mate) {
    bool taken = false;
    for (Player p in GameMenuSettings.playerList) {
      if (p.hasMate(mate)) {
        taken = true;
      }
    }
    return taken;
  }

  ///
  /// \brief trouve le joueur qui possède le pote
  ///
  Player whoGotMate(String mate) {
    for (Player p in GameMenuSettings.playerList) {
      if (p.hasMate(mate)) {
        return p;
      }
    }
    return Player("", 0, 0, 0);
  }

  ///
  /// \brief manage les potes en les affectant avec verification
  ///
  void mateManager(String mate) {
    if (!isMateTaken(mate)) {
      isShifumi = false;
      GameMenuSettings.playerList[playernb].addMate(mate);
    } else if (GameMenuSettings.playerList[playernb] == whoGotMate(mate)){
      isShifumi = false;
      return;
    } else {
      isShifumi = true;
      shifumi(mate);
    }
  }

  ///
  /// \brief manage les points attribuer à la fin de chaque année en fonction des potes
  ///
  void matesPointManager(Player p) {
    p.addPoint(p.getMates().isEmpty ? 0 : p.getMates().length * year);
  }

  ///
  /// \brief retourne le nom de l'année correspondante pour l'affichage
  ///
  String getYearName() {
    switch (year) {
      case 1 :
        return 'Seconde';
      case 2 :
        return 'Première';
      case 3 :
        return 'Terminale';
      default :
        return 'Post-Bac';
    }
  }

  ///
  /// \brief affiche une pop up à la fin d'une année qui fait un récap
  ///
  void yearPopUp() {
    showDialog(
        context: context,
        builder: (context) {
            return Center(
                child: Material(
                    type: MaterialType.transparency,
                    child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: const Color(0xFFFFE539),
                        ),
                        padding: const EdgeInsets.all(15),
                        width: MediaQuery.of(context).size.width*0.30,
                        height: MediaQuery.of(context).size.height*0.75,
                        child: Column(
                            children: [
                              DelayedAnimation(
                                delay: 400,
                                child: Text("L'année de " + getYearName() + " est Terminé"),
                              ),
                              DelayedAnimation(
                                  delay: 400,
                                  child: Table(
                                      border: TableBorder.all(),
                                      children:
                                      getLeaderBoard()
                                  )
                              ),
                            ]
                        )
                    )
                )
            );
        }
    );
  }

void shifumiButton(String mate) {
    action.clear();
    action.add(
       ElevatedButton(
            onPressed: () {
              whoGotMate(mate).removePoint(1);
              whoGotMate(mate).removeMate(mate);
              GameMenuSettings.playerList[playernb].addMate(mate);
              Navigator.pop(context, true);
            },
            child: Text(GameMenuSettings.playerList[playernb].getName(),
              style: GoogleFonts.poppins(
                color: Colors.black54,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            )
        )
    );
    action.add(
        ElevatedButton(
            onPressed: () {
              GameMenuSettings.playerList[playernb].removePoint(2);
              Navigator.pop(context, true);
            },
            child: Text(whoGotMate(mate).getName(),
              style: GoogleFonts.poppins(
                color: Colors.black54,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            )
        )
    );
  }

  ///
  /// \brief lance un shi-fu-mi
  ///
  void shifumi(String mate) {
    shifumiButton(mate);
    showDialog(
        context: context,
        builder: (context){
          return Center(
            child: Material(
                type: MaterialType.transparency,
                child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color(0xFF4AE84D),
                    ),
                    padding: EdgeInsets.all(15),
                    width: MediaQuery.of(context).size.width*0.30,
                    height: MediaQuery.of(context).size.height*0.75,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          const SizedBox(height: 10,),
                          const Text(
                            'SHI-FU-MI',
                            style:  TextStyle(
                                fontSize: 30,
                                color: Colors.black87,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                          const Divider(
                            height: 20,
                            color: Colors.black54,
                          ),
                          Container(
                              height: MediaQuery.of(context).size.height*0.4,
                              child: Column(
                                  children: const <Widget> [
                                    SizedBox(height: 15,),
                                    Text(
                                      'Shi-fu-mi',
                                      style: TextStyle(
                                          fontSize: 30,
                                          color: Colors.black87,
                                          fontWeight: FontWeight.bold
                                      ),
                                    ),
                                    SizedBox(height: 10,),
                                    Text(
                                      'Jouer un shi-fu-mi',
                                      style: TextStyle(
                                        fontSize: 22,
                                        color: Colors.black54,
                                      ),
                                    ),

                                  ]
                              )
                          ),
                          const Divider(
                            height: 20,
                            color: Colors.black54,
                          ),
                          const SizedBox(height: 30,),
                          const Text(
                            "Action : ",
                            style:  TextStyle(
                              fontSize: 22,
                              color: Colors.black54,
                            ),
                          ),
                          Center(
                            child : Row(
                              children: action
                            )
                          )
                        ]
                    )
                )
            ),
          );
        }).then((value) {
      setState(() {
        if(playernb == GameMenuSettings.playerList.length-1) playernb = 0;
        else playernb++;
      });
    });
  }


  ///
  /// \brief Lance le dé
  ///
  /// Lorsque le joueur clique sur le bouton lancer le dé
  /// On rafraichi la page, puis on tira au hasard un nombre parmis toutes les cartes de dispo,
  /// On lui affiche la petite pop up concernant les info necessaire au type de cartes
  ///
  void _rollDice(){
    setState(() {
      var rng = Random();
      int random = (rng.nextInt(6) + 1);
      randomimg = random;
      int playernewcase = GameMenuSettings.playerList[playernb].getCase() + random;
      if (playernewcase > 23) {
        GameMenuSettings.playerList[playernb].setLap(GameMenuSettings.playerList[playernb].getLap() + 1);
        gfManager(GameMenuSettings.playerList[playernb]);
        gameOver(GameMenuSettings.playerList[playernb]);
        if (yearManager()) {
          playernewcase = 0;
        } else {
          playernewcase -= 23;
        }
      }
      if (MyApp.stringList[playernewcase].startsWith("MYSTERE")){
        var ran = new Random();
        int randomcard = (ran.nextInt(MainMenu.cardlist.length));
        giveEffect(randomcard);
        showDialog(
            context: context,
            builder: (context){
              return Center(
                child: Material(
                    type: MaterialType.transparency,
                    child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Color(0xFFE63946),
                        ),
                        padding: EdgeInsets.all(15),
                        width: MediaQuery.of(context).size.width*0.30,
                        height: MediaQuery.of(context).size.height*0.75,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text('Vous avez fait : ' + random.toString(),
                                style: const TextStyle(
                                    fontSize: 25,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                              const SizedBox(height: 10,),
                              const Text(
                                'MYSTERE ',
                                style:  TextStyle(
                                    fontSize: 30,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                              const Divider(
                                height: 20,
                                color: Colors.blueGrey,
                              ),
                              Container(
                                  height: MediaQuery.of(context).size.height*0.4,
                                  child: Column(
                                      children: <Widget> [
                                        const SizedBox(height: 15,),
                                        Text(
                                          MainMenu.cardlist[randomcard].getName(),
                                          style: const TextStyle(
                                              fontSize: 30,
                                              color: Colors.black87,
                                              fontWeight: FontWeight.bold
                                          ),
                                        ),
                                        SizedBox(height: 10,),
                                        Text(
                                          MainMenu.cardlist[randomcard].getDesc(),
                                          style: const TextStyle(
                                            fontSize: 22,
                                            color: Colors.black54,
                                          ),
                                        ),
                                      ]
                                  )
                              ),

                              const Divider(
                                height: 20,
                                color: Colors.blueGrey,
                              ),
                              const SizedBox(height: 30,),
                              const Text(
                                'Action : ',
                                style: TextStyle(
                                  fontSize: 22,
                                  color: Colors.black54,
                                ),
                              ),
                              SizedBox(height: 5,),
                              Row(
                                children: effectString.map((e) => Text(e, style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.black54,
                                ),)).toList(),
                              ),
                              Row(
                                  children: action
                              ),
                            ]
                        )
                    )
                ),
              );
            }).then((value) {
          setState(() {
            if(playernb == GameMenuSettings.playerList.length-1) playernb = 0;
            else playernb++;
          });
        });

      } else if (MyApp.stringList[playernewcase].startsWith('COURS')) {
        GameMenuSettings.playerList[playernb].addPoint(2);
        showDialog(
            context: context,
            builder: (context){
              return Center(
                child: Material(
                    type: MaterialType.transparency,
                    child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Color(0xFF457B9D),
                        ),
                        padding: EdgeInsets.all(15),
                        width: MediaQuery.of(context).size.width*0.30,
                        height: MediaQuery.of(context).size.height*0.75,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text("Vous avez fait : "+random.toString(),
                                style: const TextStyle(
                                    fontSize: 25,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                              const SizedBox(height: 10,),
                              const Text(
                                'COURS',
                                style:  TextStyle(
                                    fontSize: 30,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                              const Divider(
                                height: 20,
                                color: Colors.black54,
                              ),
                              Container(
                                  height: MediaQuery.of(context).size.height*0.4,
                                  child: Column(
                                      children: const <Widget> [
                                        SizedBox(height: 15,),
                                        Text(
                                          'Cours',
                                          style: TextStyle(
                                              fontSize: 30,
                                              color: Colors.black87,
                                              fontWeight: FontWeight.bold
                                          ),
                                        ),
                                        SizedBox(height: 10,),
                                        Text(
                                          'Vous allez en cours, une journée banale.',
                                          style: TextStyle(
                                            fontSize: 22,
                                            color: Colors.black54,
                                          ),
                                        ),
                                      ]
                                  )
                              ),

                              const Divider(
                                height: 20,
                                color: Colors.black54,
                              ),
                              SizedBox(height: 30,),
                              const Text(
                                "Action : ",
                                style:  TextStyle(
                                  fontSize: 22,
                                  color: Colors.black54,
                                ),
                              ),
                              const Text("Vous gagnez 2 points", style:  TextStyle(
                                fontSize: 18,
                                color: Colors.black54,
                              ),
                              )
                            ]
                        )
                    )
                ),
              );
            }).then((value) {
          setState(() {
            if(playernb == GameMenuSettings.playerList.length-1) playernb = 0;
            else playernb++;
          });
        });

      } else if(MyApp.stringList[playernewcase].startsWith("EXAM")) {
        String anneenom = getYearName();
        int pointanne = 0;
        switch(year) {
          case 1 :
            pointanne = 3;
            break;
          case 2 :
            pointanne = 5;
            break;
          case 3 :
            pointanne = 7;
            break;
          default :
            break;
        }
        GameMenuSettings.playerList[playernb].addPoint(pointanne);
        showDialog(
            context: context,
            builder: (context){
              return Center(
                child: Material(
                    type: MaterialType.transparency,
                    child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Color(0xFF7871aa),
                        ),
                        padding: EdgeInsets.all(15),
                        width: MediaQuery.of(context).size.width*0.30,
                        height: MediaQuery.of(context).size.height*0.75,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text("Vous avez fait : "+random.toString(),
                                style: const TextStyle(
                                    fontSize: 25,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                              const SizedBox(height: 10,),
                              const Text(
                                "EXAMEN",
                                style:  TextStyle(
                                    fontSize: 30,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                              const Divider(
                                height: 20,
                                color: Colors.black54,
                              ),
                              Container(
                                  height: MediaQuery.of(context).size.height*0.4,
                                  child: Column(
                                      children:  <Widget> [
                                        const SizedBox(height: 15,),
                                        const Text(
                                          "EXAMEN",
                                          style: TextStyle(
                                              fontSize: 30,
                                              color: Colors.black87,
                                              fontWeight: FontWeight.bold
                                          ),
                                        ),
                                        const SizedBox(height: 10,),
                                        Text(
                                          "Vous êtes actuellement en train de passer un examen de "+anneenom+ ", cela vous rapporte "+pointanne.toString()+ " points",
                                          style: const TextStyle(
                                            fontSize: 22,
                                            color: Colors.black54,
                                          ),
                                        ),
                                      ]
                                  )
                              ),

                              const Divider(
                                height: 20,
                                color: Colors.black54,
                              ),
                              SizedBox(height: 30,),
                              const Text(
                                "Action : ",
                                style:  TextStyle(
                                  fontSize: 22,
                                  color: Colors.black54,
                                ),
                              ),
                              Text("Vous gagnez "+pointanne.toString()+" points", style:  const TextStyle(
                                fontSize: 18,
                                color: Colors.black54,
                              ),
                              )
                            ]
                        )
                    )
                ),
              );
            }).then((val){
          setState(() {
            if(playernb == GameMenuSettings.playerList.length-1) playernb = 0;
            else playernb++;
          });
        });

      } else if (MyApp.stringList[playernewcase].startsWith("COPINE")) {
          if (!GameMenuSettings.playerList[playernb].hasGf()) {
            GameMenuSettings.playerList[playernb].setGf(true);
            showDialog(
                context: context,
                builder: (context){
                  return Center(
                    child: Material(
                        type: MaterialType.transparency,
                        child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: const Color(0xFFE84A98),
                            ),
                            padding: const EdgeInsets.all(15),
                            width: MediaQuery.of(context).size.width*0.30,
                            height: MediaQuery.of(context).size.height*0.75,
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Text("Vous avez fait : "+random.toString(),
                                    style: const TextStyle(
                                        fontSize: 25,
                                        color: Colors.black87,
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                  const SizedBox(height: 10,),
                                  const Text(
                                    'COPINE',
                                    style:  TextStyle(
                                        fontSize: 30,
                                        color: Colors.black87,
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                  const Divider(
                                    height: 20,
                                    color: Colors.black54,
                                  ),
                                  SizedBox(
                                      height: MediaQuery.of(context).size.height*0.4,
                                      child: Column(
                                          children: const <Widget> [
                                            SizedBox(height: 15,),
                                            Text(
                                              'Copine',
                                              style: TextStyle(
                                                  fontSize: 30,
                                                  color: Colors.black87,
                                                  fontWeight: FontWeight.bold
                                              ),
                                            ),
                                            SizedBox(height: 10,),
                                            Text(
                                              '"Copine à bord, tu perds pas le nord"\nJean de la Fleurette.',
                                              style: TextStyle(
                                                fontSize: 22,
                                                color: Colors.black54,
                                              ),
                                            ),
                                          ]
                                      )
                                  ),

                                  const Divider(
                                    height: 20,
                                    color: Colors.black54,
                                  ),
                                  const SizedBox(height: 30,),
                                  const Text(
                                    "Action : ",
                                    style:  TextStyle(
                                      fontSize: 22,
                                      color: Colors.black54,
                                    ),
                                  ),
                                  const Text("Vous gagnez une copine <3 XOXO", style:  TextStyle(
                                    fontSize: 18,
                                    color: Colors.black54,
                                  ),
                                  )
                                ]
                            )
                        )
                    ),
                  );
                }).then((value) {
              setState(() {
                if(playernb == GameMenuSettings.playerList.length-1) playernb = 0;
                else playernb++;
              });
            });
          } else {
            GameMenuSettings.playerList[playernb].removePoint(2);
            GameMenuSettings.playerList[playernb].setGf(false);
            showDialog(
              context: context,
              builder: (context){
                return Center(
                  child: Material(
                      type: MaterialType.transparency,
                      child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: const Color(0xFFE84A98),
                          ),
                          padding: EdgeInsets.all(15),
                          width: MediaQuery.of(context).size.width*0.30,
                          height: MediaQuery.of(context).size.height*0.75,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text("Vous avez fait : "+random.toString(),
                                  style: const TextStyle(
                                      fontSize: 25,
                                      color: Colors.black87,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                                const SizedBox(height: 10,),
                                const Text(
                                  'COPINE',
                                  style:  TextStyle(
                                      fontSize: 30,
                                      color: Colors.black87,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                                const Divider(
                                  height: 20,
                                  color: Colors.black54,
                                ),
                                Container(
                                    height: MediaQuery.of(context).size.height*0.4,
                                    child: Column(
                                        children: const <Widget> [
                                          SizedBox(height: 15,),
                                          Text(
                                            'Copine',
                                            style: TextStyle(
                                                fontSize: 30,
                                                color: Colors.black87,
                                                fontWeight: FontWeight.bold
                                            ),
                                          ),
                                          SizedBox(height: 10,),
                                          Text(
                                            '"Mesdemoiselles, Mesdames, Messieurs, il n\'existe point châtiment plus cruelle que la tromperie d\'une âme que l\'on aime"\nDaniel Bol D\'avoine.',
                                            style: TextStyle(
                                              fontSize: 22,
                                              color: Colors.black54,
                                            ),
                                          ),
                                        ]
                                    )
                                ),
                                const Divider(
                                  height: 20,
                                  color: Colors.black54,
                                ),
                                const SizedBox(height: 30,),
                                const Text(
                                  "Action : ",
                                  style:  TextStyle(
                                    fontSize: 22,
                                    color: Colors.black54,
                                  ),
                                ),
                                const Text("Vous perdez 2 points et votre copine même si se faire sucer c'est pas tromper..." , style:  TextStyle(
                                  fontSize: 18,
                                  color: Colors.black54,
                                ),
                                )
                              ]
                          )
                      )
                  ),
                );
              }).then((value) {
            setState(() {
              if(playernb == GameMenuSettings.playerList.length-1) playernb = 0;
              else playernb++;
            });
          });
        }
      } else if (MyApp.stringList[playernewcase].startsWith("POTE")) {
        String mate;
        switch (playernewcase) {
          case 3 :
            mateManager(POTE_1);
            mate = POTE_1;
            break;
          case 9 :
            mateManager(POTE_2);
            mate = POTE_2;
            break;
          case 15 :
            mateManager(POTE_3);
            mate = POTE_3;
            break;
          case 21 :
            mateManager(POTE_4);
            mate = POTE_4;
            break;
          default :
            mate = "";
            break;
        }
        showDialog(
            context: context,
            builder: (context){
              return Center(
                child: Material(
                    type: MaterialType.transparency,
                    child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: const Color(0xFF4AE84D)
                        ),
                        padding: const EdgeInsets.all(15),
                        width: MediaQuery.of(context).size.width*0.30,
                        height: MediaQuery.of(context).size.height*0.75,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text("Vous avez fait : "+random.toString(),
                                style: const TextStyle(
                                    fontSize: 25,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                              const SizedBox(height: 10,),
                              const Text(
                                'POTE',
                                style:  TextStyle(
                                    fontSize: 30,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                              const Divider(
                                height: 20,
                                color: Colors.black54,
                              ),
                              SizedBox(
                                  height: MediaQuery.of(context).size.height*0.4,
                                  child: Column(
                                      children: <Widget> [
                                        const SizedBox(height: 15,),
                                        const Text(
                                          'Pote',
                                          style: TextStyle(
                                              fontSize: 30,
                                              color: Colors.black87,
                                              fontWeight: FontWeight.bold
                                          ),
                                        ),
                                        const SizedBox(height: 10,),
                                        Text(
                                          'Trop de la chance, ' + mate + ' est maintenant votre pote !',
                                          style: const TextStyle(
                                            fontSize: 22,
                                            color: Colors.black54,
                                          ),
                                        ),
                                      ]
                                  )
                              ),
                              const Divider(
                                height: 20,
                                color: Colors.black54,
                              ),
                              const SizedBox(height: 30,),
                              const Text(
                                "Action : ",
                                style:  TextStyle(
                                  fontSize: 22,
                                  color: Colors.black54,
                                ),
                              ),
                              const Text("Vous gagnez un pote !", style:  TextStyle(
                                fontSize: 18,
                                color: Colors.black54,
                              ),
                              )
                            ]
                        )
                    )
                ),
              );
            }).then((value) {
              if(isShifumi) return;
          setState(() {
            if(playernb == GameMenuSettings.playerList.length-1) playernb = 0;
            else playernb++;
          });
        });
      }
      GameMenuSettings.playerList[playernb].setCase(playernewcase);
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        //color: Color(0xFFF7F4F3),

        child: Column(
            children: [
              Container(
                color: Colors.red,
                width: double.infinity,
                padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                height: 66,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Numéro de case : " + GameMenuSettings.playerList[playernb].getCase().toString(),
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          color: Colors.black54,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        )),
                    Text("Année : " + getYearName(),
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          color: Colors.black54,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        )),
                    Text("Tour : " + GameMenuSettings.playerList[playernb].getLap().toString(),
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          color: Colors.black54,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        )),
                    Column(
                      children: [
                        Container(
                          child: Text("C'est au tour de ",
                            textAlign: TextAlign.center,

                            style: GoogleFonts.poppins(
                              color: Colors.black54,
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                            ),

                          ),
                        ),
                        Text(GameMenuSettings.playerList[playernb].getName(),
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                          ),
                        ),
                      ],
                    ),
                    Text("Vos points : "+GameMenuSettings.playerList[playernb].getPoint().toString(),
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                          color: Colors.black54,
                          fontSize: 18,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    Text("Vos potes à la compote : "+GameMenuSettings.playerList[playernb].countMates().toString(),
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                          color: Colors.black54,
                          fontSize: 18,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                color: Colors.red,
                child: Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height-100,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: new BorderRadius.vertical(
                      top: Radius.elliptical(150, 30),
                    ),

                  ),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                            onPressed: () {
                              _rollDice();
                            },
                            child: Text('Lancer le dé',
                              style: GoogleFonts.poppins(

                                color: Colors.black54,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                        )
                      ]
                  ),
                ),

              ),

              /*Align(
              alignment: Alignment.topLeft,
              child: Container(
                width: double.infinity/2,
                constraints: BoxConstraints(maxWidth: 200),
                child:
                  Table(
                      border: TableBorder.all(color: Colors.black),
                      children:
                      addLeftTable()
                  )
              )
            ),
            Center(
              
            )*/

            ]
        ),

      ),


    );

  }


}

class PhotoHero extends StatelessWidget {
  const PhotoHero({ Key? key, required this.photo, required this.onTap, required this.width }) : super(key: key);

  final String photo;
  final VoidCallback onTap;
  final double width;

  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Hero(
        tag: photo,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            child: Image.asset(
              photo,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}

class RadialExpansion extends StatelessWidget {
  RadialExpansion({
    Key? key,
    required this.maxRadius,
    required this.child,
  }) : clipRectSize = 2.0 * (maxRadius / sqrt2),
        super(key: key);

  final double maxRadius;
  final clipRectSize;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Center(
        child: SizedBox(
          width: clipRectSize,
          height: clipRectSize,
          child: ClipRect(
            child: child,  // Photo
          ),
        ),
      ),
    );
  }
}
class GameGUIState extends StatefulWidget{
  @override
  GameGUI createState() => GameGUI();
}