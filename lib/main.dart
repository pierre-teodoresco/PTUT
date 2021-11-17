import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ptut_game/cards/cardobject.dart';
import 'package:ptut_game/menu.dart';
const d_red = const Color(0xFFE98170);

void main() {
  //List<Cardobject> cardlist = cardobjectFromJson("cards/cards.json");
  //print(cardlist.toString());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Guys and Guys',
      debugShowCheckedModeBanner: false,
      home: MainMenu(),
    );
  }
}
