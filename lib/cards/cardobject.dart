// To parse this JSON data, do
//
//     final cardobject = cardobjectFromJson(jsonString);

import 'package:flutter/widgets.dart';

class CardObject {

  late String name, description, type;
  late List<String> effect;
  late List<Widget> widgets;

  CardObject(this.name, this.description, this.type, this.effect);

  String getName() {
    return name;
  }

  void setName(String name) {
    this.name = name;
  }
  String getDesc() {
    return description;
  }

  void setDesc(String description) {
    this.description = description;
  }

  List<String> getEffect() {
    return effect;
  }

  void setEffect(List<String> effect) {
    this.effect = effect;
  }

  List<Widget> getWidget(){
    return widgets;
  }

  void setWidget(List<Widget> widgets){
    this.widgets = widgets;
  }
}
