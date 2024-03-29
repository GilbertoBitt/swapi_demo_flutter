// To parse this JSON data, do
//
//     final vehicle = vehicleFromJson(jsonString);

import 'dart:convert';

class Vehicle {
  String name;
  String model;
  String manufacturer;
  String costInCredits;
  String length;
  String maxAtmospheringSpeed;
  String crew;
  String passengers;
  String cargoCapacity;
  String consumables;
  String vehicleClass;
  List<String> pilots;
  List<String> films;
  DateTime created;
  DateTime edited;
  String url;

  Vehicle({
    this.name,
    this.model,
    this.manufacturer,
    this.costInCredits,
    this.length,
    this.maxAtmospheringSpeed,
    this.crew,
    this.passengers,
    this.cargoCapacity,
    this.consumables,
    this.vehicleClass,
    this.pilots,
    this.films,
    this.created,
    this.edited,
    this.url,
  });

  factory Vehicle.fromJson(String str) => Vehicle.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Vehicle.fromMap(Map<String, dynamic> json) => Vehicle(
    name: json["name"],
    model: json["model"],
    manufacturer: json["manufacturer"],
    costInCredits: json["cost_in_credits"],
    length: json["length"],
    maxAtmospheringSpeed: json["max_atmosphering_speed"],
    crew: json["crew"],
    passengers: json["passengers"],
    cargoCapacity: json["cargo_capacity"],
    consumables: json["consumables"],
    vehicleClass: json["vehicle_class"],
    pilots: List<String>.from(json["pilots"].map((x) => x)),
    films: List<String>.from(json["films"].map((x) => x)),
    created: DateTime.parse(json["created"]),
    edited: DateTime.parse(json["edited"]),
    url: json["url"],
  );

  Map<String, dynamic> toMap() => {
    "name": name,
    "model": model,
    "manufacturer": manufacturer,
    "cost_in_credits": costInCredits,
    "length": length,
    "max_atmosphering_speed": maxAtmospheringSpeed,
    "crew": crew,
    "passengers": passengers,
    "cargo_capacity": cargoCapacity,
    "consumables": consumables,
    "vehicle_class": vehicleClass,
    "pilots": List<dynamic>.from(pilots.map((x) => x)),
    "films": List<dynamic>.from(films.map((x) => x)),
    "created": created.toIso8601String(),
    "edited": edited.toIso8601String(),
    "url": url,
  };
}
