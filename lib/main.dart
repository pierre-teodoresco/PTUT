import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ptut_game/iu/menu.dart';
const d_red = const Color(0xFFE98170);


void main() {
  //List<Cardobject> cardlist = cardobjectFromJson("cards/cards.json");
  //print(cardlist.toString());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static List<String> stringList = [];

  void initCase(){
    stringList.add("DEPART");
    stringList.add("COURS");
    stringList.add("VACANCES");
    stringList.add("POTE");
    stringList.add("MYSTERE");
    stringList.add("COURS");
    stringList.add("EXAM");
    stringList.add("COURS");
    stringList.add("MYSTERE");
    stringList.add("POTE");
    stringList.add("COURS");
    stringList.add("MYSTERE");
    stringList.add("COPINE");
    stringList.add("COURS");
    stringList.add("VACANCES");
    stringList.add("POTE");
    stringList.add("COURS");
    stringList.add("MYSTERE");
    stringList.add("EXAM");
    stringList.add("MYSTERE");
    stringList.add("COURS");
    stringList.add("POTE");
    stringList.add("MYSTERE");
    stringList.add("COURS");

  }

  @override
  Widget build(BuildContext context) {
    initCase();

    return MaterialApp(
      title: 'Guys and Guys',
      debugShowCheckedModeBanner: false,
      home: MainMenu(),
    );
  }
}
