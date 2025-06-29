import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../models/pokemon.dart';
import '../services/pokemon_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PokemonService _pokemonService = PokemonService();
  late Future<List<Pokemon>> _pokemonFuture;

  @override
  void initState() {
    super.initState();
    _pokemonFuture = _pokemonService.fetchPokemons();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pokédex'),
        backgroundColor: Colors.red,
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            color: Colors.grey[200],
            child: Center(
              child: Column(
                children: [
                  const Text(
                    'Acesse a Pokédex Online',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    color: Colors.white,
                    child: QrImageView(
                      data: 'https://www.pokemon.com/br/pokedex',
                      version: QrVersions.auto,
                      size: 150.0,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const Padding(
            padding: EdgeInsets.all(12.0),
            child: Text(
              '151 Pokémons',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Pokemon>>(
              future: _pokemonFuture,
              builder: (context, snapshot) {
                // Enquanto os dados estão carregando, mostra um círculo de progresso
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } 
                else if (snapshot.hasError) {
                  return Center(child: Text('Erro ao carregar: ${snapshot.error}'));
                } 
                else if (snapshot.hasData) {
                  final pokemons = snapshot.data!;
                  return ListView.builder(
                    itemCount: pokemons.length,
                    itemBuilder: (context, index) {
                      final pokemon = pokemons[index];
                      final pokemonId = pokemon.url.split('/')[6];
                      final imageUrl = 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/$pokemonId.png';
                      
                      return ListTile(
                        leading: Image.network(
                          imageUrl,
                          width: 60,
                          height: 60,
                          loadingBuilder: (context, child, progress) {
                            return progress == null ? child : const CircularProgressIndicator();
                          },
                        ),
                        title: Text(
                          pokemon.name[0].toUpperCase() + pokemon.name.substring(1),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text('Nº $pokemonId'),
                      );
                    },
                  );
                }
                // Caso não se encaixe em nenhum caso acima
                return const Center(child: Text('Nenhum Pokémon encontrado.'));
              },
            ),
          ),
        ],
      ),
    );
  }
}