// To parse this JSON data, do
//
//     final cardobject = cardobjectFromJson(jsonString);

import 'dart:convert';

import 'package:flutter/widgets.dart';

class Cardobject {

  late String name,description, type;
  late List<String>  effect;
  late List<Widget> widgets;
  //late List<a_card> cardList;

  Cardobject(String name, String description, String type, List<String> effect, /*List<a_card> cardList*/) {
    this.name = name;
    this.description = description;
    this.type = type;
    this.effect = effect;
    //this.cardList = cardList;
  }
  String getName() {
    return name;
  }

  void setName(String name) {
    this.name = name;
  }
  String getDesc() {
    return description;
  }


  void setDesc(String desc) {
    this.description = desc;
  }

  List<String> getEffect() {
    return effect;
  }

  void setEffect(List<String> eff) {
    this.effect = eff;
  }

  List<Widget> getWidget(){
    return widgets;
  }

  void setWidget(List<Widget> wid){
    this.widgets = wid;
  }
}
