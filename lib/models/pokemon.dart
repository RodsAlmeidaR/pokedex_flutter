import 'dart:convert';

class PokemonDetail {
  final int id;
  final String name;
  final int height; 
  final int weight; 
  final String imageUrl;
  final List<String> types;
  final List<String> abilities;

  PokemonDetail({
    required this.id,
    required this.name,
    required this.height,
    required this.weight,
    required this.imageUrl,
    required this.types,
    required this.abilities,
  });

  factory PokemonDetail.fromJson(Map<String, dynamic> json) {

    final typesList = (json['types'] as List)
        .map((typeInfo) => typeInfo['type']['name'] as String)
        .toList();

    final abilitiesList = (json['abilities'] as List)
        .map((abilityInfo) => abilityInfo['ability']['name'] as String)
        .toList();

    return PokemonDetail(
      id: json['id'],
      name: json['name'],
      height: json['height'],
      weight: json['weight'],
      imageUrl: json['sprites']['front_default'],
      types: typesList,
      abilities: abilitiesList,
    );
  }
}