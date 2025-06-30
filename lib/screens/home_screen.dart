import 'package:flutter/material.dart';
import 'package:pokemon_pokedex_app/screens/details_screen.dart';
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
  late Future<PokemonDetail> _pokemonFuture;

  @override
  void initState() {
    super.initState();

    _pokemonFuture = _pokemonService.fetchPokemonDetails('magneton');
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
          
          const SizedBox(height: 20),

          Expanded(
            child: FutureBuilder<PokemonDetail>(
              future: _pokemonFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Erro: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  final pokemon = snapshot.data!;
                  // Usamos GestureDetector para tornar o card clicável
                  return GestureDetector(
                    onTap: () {
                      // Ação de clique: navegar para a tela de detalhes
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailsScreen(pokemon: pokemon),
                        ),
                      );
                    },
                    child: Card(
                      elevation: 4,
                      margin: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(height: 20),
                          Image.network(
                            pokemon.imageUrl,
                            height: 150,
                            width: 150,
                            fit: BoxFit.contain,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            pokemon.name[0].toUpperCase() + pokemon.name.substring(1),
                            style: const TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          const Text('Clique para ver detalhes'),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  );
                }
                return const Center(child: Text('Nenhum Pokémon encontrado.'));
              },
            ),
          ),
        ],
      ),
    );
  }
}