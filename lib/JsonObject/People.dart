// To parse this JSON data, do
//
//     final peopleFactory = peopleFactoryFromJson(jsonString);

import 'dart:convert';

class PeopleFactory {
  int count;
  String next;
  dynamic previous;
  List<People> results;

  PeopleFactory({
    this.count,
    this.next,
    this.previous,
    this.results,
  });

  factory PeopleFactory.fromJson(String str) => PeopleFactory.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory PeopleFactory.fromMap(Map<String, dynamic> json) => PeopleFactory(
    count: json["count"],
    next: json["next"],
    previous: json["previous"],
    results: List<People>.from(json["results"].map((x) => People.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "count": count,
    "next": next,
    "previous": previous,
    "results": List<dynamic>.from(results.map((x) => x.toMap())),
  };
}

class People {
  String name;
  String height;
  String mass;
  String hairColor;
  String skinColor;
  String eyeColor;
  String birthYear;
  Gender gender;
  String homeworld;
  List<String> films;
  List<String> species;
  List<String> vehicles;
  List<String> starships;
  DateTime created;
  DateTime edited;
  String url;

  People({
    this.name,
    this.height,
    this.mass,
    this.hairColor,
    this.skinColor,
    this.eyeColor,
    this.birthYear,
    this.gender,
    this.homeworld,
    this.films,
    this.species,
    this.vehicles,
    this.starships,
    this.created,
    this.edited,
    this.url,
  });

  factory People.fromJson(String str) => People.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory People.fromMap(Map<String, dynamic> json) => People(
    name: json["name"],
    height: json["height"],
    mass: json["mass"],
    hairColor: json["hair_color"],
    skinColor: json["skin_color"],
    eyeColor: json["eye_color"],
    birthYear: json["birth_year"],
    gender: genderValues.map[json["gender"]],
    homeworld: json["homeworld"],
    films: List<String>.from(json["films"].map((x) => x)),
    species: List<String>.from(json["species"].map((x) => x)),
    vehicles: List<String>.from(json["vehicles"].map((x) => x)),
    starships: List<String>.from(json["starships"].map((x) => x)),
    created: DateTime.parse(json["created"]),
    edited: DateTime.parse(json["edited"]),
    url: json["url"],
  );

  Map<String, dynamic> toMap() => {
    "name": name,
    "height": height,
    "mass": mass,
    "hair_color": hairColor,
    "skin_color": skinColor,
    "eye_color": eyeColor,
    "birth_year": birthYear,
    "gender": genderValues.reverse[gender],
    "homeworld": homeworld,
    "films": List<dynamic>.from(films.map((x) => x)),
    "species": List<dynamic>.from(species.map((x) => x)),
    "vehicles": List<dynamic>.from(vehicles.map((x) => x)),
    "starships": List<dynamic>.from(starships.map((x) => x)),
    "created": created.toIso8601String(),
    "edited": edited.toIso8601String(),
    "url": url,
  };
}

enum Gender { MALE, N_A, FEMALE }

final genderValues = EnumValues({
  "female": Gender.FEMALE,
  "male": Gender.MALE,
  "n/a": Gender.N_A
});

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
