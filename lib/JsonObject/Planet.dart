// To parse this JSON data, do
//
//     final planet = planetFromJson(jsonString);

import 'dart:convert';

class Planet {
  String name;
  String rotationPeriod;
  String orbitalPeriod;
  String diameter;
  String climate;
  String gravity;
  String terrain;
  String surfaceWater;
  String population;
  List<String> residents;
  List<String> films;
  DateTime created;
  DateTime edited;
  String url;

  Planet({
    this.name,
    this.rotationPeriod,
    this.orbitalPeriod,
    this.diameter,
    this.climate,
    this.gravity,
    this.terrain,
    this.surfaceWater,
    this.population,
    this.residents,
    this.films,
    this.created,
    this.edited,
    this.url,
  });

  factory Planet.fromJson(String str) => Planet.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Planet.fromMap(Map<String, dynamic> json) => Planet(
    name: json["name"],
    rotationPeriod: json["rotation_period"],
    orbitalPeriod: json["orbital_period"],
    diameter: json["diameter"],
    climate: json["climate"],
    gravity: json["gravity"],
    terrain: json["terrain"],
    surfaceWater: json["surface_water"],
    population: json["population"],
    residents: List<String>.from(json["residents"].map((x) => x)),
    films: List<String>.from(json["films"].map((x) => x)),
    created: DateTime.parse(json["created"]),
    edited: DateTime.parse(json["edited"]),
    url: json["url"],
  );

  Map<String, dynamic> toMap() => {
    "name": name,
    "rotation_period": rotationPeriod,
    "orbital_period": orbitalPeriod,
    "diameter": diameter,
    "climate": climate,
    "gravity": gravity,
    "terrain": terrain,
    "surface_water": surfaceWater,
    "population": population,
    "residents": List<dynamic>.from(residents.map((x) => x)),
    "films": List<dynamic>.from(films.map((x) => x)),
    "created": created.toIso8601String(),
    "edited": edited.toIso8601String(),
    "url": url,
  };
}
