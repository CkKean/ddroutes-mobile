class UtilityModel {
  int id;
  String name;
  String abbr;

  UtilityModel({this.id, this.name, this.abbr});

  UtilityModel.copy(UtilityModel from)
      : this(id: from.id, name: from.name, abbr: from.abbr);

  UtilityModel.fromJson(json)
      : this(id: json["id"], name: json["name"], abbr: json["abbr"]);

  Map<String, dynamic> toJson() => {"id": id, "name": name, "abbr": abbr};
}

class UtilitiesModel {
  List<UtilityModel> state;
  List<UtilityModel> race;
  List<UtilityModel> religion;

  UtilitiesModel({this.state, this.race, this.religion});

  UtilitiesModel.copy(UtilitiesModel from)
      : this(
            state: [...from.state],
            race: [...from.race],
            religion: [...from.religion]);

  UtilitiesModel.fromJson(json)
      : this(
          state: json["state"]
              .map<UtilityModel>((state) => UtilityModel.fromJson(state))
              .toList(),
          race: json["race"]
              .map<UtilityModel>((state) => UtilityModel.fromJson(state))
              .toList(),
          religion: json["religion"]
              .map<UtilityModel>((state) => UtilityModel.fromJson(state))
              .toList(),
        );

  Map<String, dynamic> toJson() =>
      {"state": state, "race": race, "religion": religion};
}
