import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ptut_game/cards/cardobject.dart';
import 'package:ptut_game/delayed_animation.dart';
import 'package:ptut_game/iu/game_settings.dart';
import 'package:ptut_game/main.dart';

class MainMenu extends StatelessWidget {
  static List _card = [];
  static List<CardObject> cardlist = [];

  Future<void> readJson() async {
    final String response = await rootBundle.loadString('assets/cards.json');
    final data = await json.decode(response);
    _card = data["cards"];
    print(_card.length.toString() + ' cartes de dispo');
    for (int i = 0; i < _card.length; i++) {
      List<String> effect = List<String>.from(_card[i]["effect"]);
      cardlist.add(CardObject(
          _card[i]["name"], _card[i]["description"], _card[i]["type"], effect));
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(scaffoldBackgroundColor: const Color(0xFFEDECF2)),
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            body: SingleChildScrollView(
              child: Container(
                  margin: const EdgeInsets.symmetric(
                    vertical: 60,
                    horizontal: 30,
                  ),
                  child: Column(
                    children: [
                      DelayedAnimation(
                        delay: 500,
                        child: SizedBox(
                          height: 300,
                          child: Image.asset('../assets/Logo.png'),
                        ),
                      ),
                      DelayedAnimation(
                        delay: 1500,
                        child: Container(
                          margin: const EdgeInsets.only(
                            bottom: 100,
                          ),
                          child: Text(
                            'Application réalisée pour le PTut S3-S4 ',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                                color: Colors.grey, fontSize: 15),
                          ),
                        ),
                      ),
                      DelayedAnimation(
                        delay: 2500,
                        child: Container(
                          margin: const EdgeInsets.only(top: 20, bottom: 50),
                          height: 50,
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: d_red,
                                shape: const StadiumBorder(),
                                padding: const EdgeInsets.all(13)),
                            child: const Text('Jouer'),
                            onPressed: () {
                              readJson();
                              print(_card.toString());
                              SystemChrome.setPreferredOrientations(
                                  [DeviceOrientation.landscapeLeft]);
                              GameMenuSettings().controllers = List.generate(
                                  6, (index) => TextEditingController());
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (builder) =>
                                          GameMenuSettingsState()));
                              },
                          ),
                        ),
                      ),
                      DelayedAnimation(
                        delay: 2500,
                        child: Container(
                          margin: const EdgeInsets.only(top: 50, bottom: 20),
                          height: 50,
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: d_red,
                                shape: const StadiumBorder(),
                                padding: const EdgeInsets.all(13)),
                            child: const Text('Options'),
                            onPressed: () {
                              print('Nombre de carte recup : ');
                              },
                          ),
                        ),
                      ),
                    ],
                  )
              ),
            )
        )
    );
  }
}
