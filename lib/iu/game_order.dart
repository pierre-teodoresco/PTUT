import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ptut_game/delayed_animation.dart';
import 'package:ptut_game/iu/game.dart';
import 'package:ptut_game/iu/game_settings.dart';
import 'package:ptut_game/scheduler/player.dart';
import 'package:flutter/services.dart';

class GameMenuOrder extends State<GameMenuOrderState>{

  @override
  Widget build(BuildContext contect){
    return Scaffold(
        backgroundColor: Color(0xFFEDECF2),
        body: SingleChildScrollView(

          child: Container(
            margin: const EdgeInsets.symmetric(
              vertical: 60,
              horizontal: 30,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children:  [
                DelayedAnimation(
                  delay: 200,
                  child: Container(
                    height: 150,
                    child: const FlutterLogo(size:100),
                  ),
                ),
                DelayedAnimation(
                  delay: 800,
                  child: Container(
                    margin: const EdgeInsets.only(
                      top: 30,
                      bottom: 20,
                    ),
                    child: Text('Qui d\'entre vous a eu la meilleur note au bac philo ?',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        color: Colors.grey,
                        fontSize: 15,
                      ),),

                  ),
                ),

                OutlinedButton.icon(
                  onPressed: () {
                    //checkButton(contect);
                  },
                  icon: const Icon(Icons.check, size: 18),
                  label: const Text("Commencer la partie"),
                )
              ],
            )
        ),)
    );
  }

}


class GameMenuOrderState extends StatefulWidget{
  @override
  GameMenuOrder createState() => GameMenuOrder();
}