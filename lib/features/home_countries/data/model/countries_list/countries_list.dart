import 'name.dart';

class CountriesList {
  int? id;
  Name? name;
  String? capital;
  String? flag, population;
  String? flagImg;
  String? currencies;
  String? languages;
  int isFavorite = 0;
  CountriesList(
      {this.name,
      this.capital,
      this.flag,
      this.isFavorite = 0,
      this.flagImg,
      this.languages,
      this.currencies,
      this.id,
      this.population});

  factory CountriesList.fromJson(Map<String, dynamic> json) => CountriesList(
      id: (json.containsKey('id')) ? json['id'] : null,
      name: json['name'] == null
          ? null
          : Name.fromJson(json['name'] as Map<String, dynamic>),
      capital: json['capital'].first as String?,
      flag: json['flag'] as String?,
      population: json['population'].toString() as String?,
      flagImg: json['flags']['png'] as String?,
      currencies: json['currencies'].values.first['name'],
      isFavorite:
          (json.containsKey('isFavorite') ? json['isFavorite'] : 0) as int,
      languages: json['languages'].values.join(', '));

  Map<String, dynamic> toJson() => {
        // 'id': id,
        'name': name?.common ?? "",
        'capital': capital,
        'flag': flag,
        'isFavorite': isFavorite,
        'flagImg': flagImg,
        'population': population.toString(),
        'languages': languages,
        'currencies': currencies,
        // 'id': id
      };
  factory CountriesList.fromDB(Map<String, dynamic> json) => CountriesList(
        id: (json.containsKey('id')) ? json['id'] : null,
        name: Name(common: json['name']),
        capital: json['capital'],
        flag: json['flag'] as String?,
        population: json['population'].toString() as String?,
        flagImg: json['flagImg'] as String?,
        currencies: json['currencies'] as String?,
        isFavorite:
            (json.containsKey('isFavorite') ? json['isFavorite'] : 0) as int,
        languages: json['languages'] as String?,
      );
}

class Currencies {
  COP? cOP;

  Currencies({this.cOP});

  Currencies.fromJson(Map<String, dynamic> json) {
    cOP = json['COP'] != null ? COP.fromJson(json['COP']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (cOP != null) {
      data['COP'] = cOP!.toJson();
    }
    return data;
  }
}

class COP {
  String? name;
  String? symbol;

  COP({this.name, this.symbol});

  COP.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    symbol = json['symbol'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['symbol'] = symbol;
    return data;
  }
}
