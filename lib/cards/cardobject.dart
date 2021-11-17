// To parse this JSON data, do
//
//     final cardobject = cardobjectFromJson(jsonString);

import 'dart:convert';

List<Cardobject> cardobjectFromJson(String str) => List<Cardobject>.from(json.decode(str).map((x) => Cardobject.fromJson(x)));

String cardobjectToJson(List<Cardobject> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Cardobject {
  Cardobject({
    required this.name,
    required this.description,
    required this.type,
    required this.effect,
  });

  String name;
  String description;
  String type;
  List<String> effect;

  factory Cardobject.fromJson(Map<String, dynamic> json) => Cardobject(
    name: json["name"],
    description: json["description"],
    type: json["type"],
    effect: List<String>.from(json["effect"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "description": description,
    "type": type,
    "effect": List<dynamic>.from(effect.map((x) => x)),
  };
}
