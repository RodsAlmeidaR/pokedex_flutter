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
  late Future<PokemonDetail> _pokemonFuture;


  bool _isDetailsVisible = false;

  @override
  void initState() {
    super.initState();
    _pokemonFuture = _pokemonService.fetchPokemonDetails('magneton');
  }

  String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

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

      body: FutureBuilder<PokemonDetail>(
        future: _pokemonFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          }

          if (snapshot.hasData) {
            final pokemon = snapshot.data!;
            return SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    child: Center(
                      child: Column(
                        children: [
                          const Text(
                            'Acesse a Pokédex Online',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
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

                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isDetailsVisible = !_isDetailsVisible;
                      });
                    },
                    child: SizedBox(
                      width: 200, 
                      height: 200, 
                      child: Card(
                        elevation: 4,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.network(
                              pokemon.imageUrl,
                              height: 100,
                              fit: BoxFit.contain,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              capitalize(pokemon.name),
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            Icon(_isDetailsVisible
                                ? Icons.expand_less
                                : Icons.expand_more),
                          ],
                        ),
                      ),
                    ),
                  ),

                  AnimatedCrossFade(
                    duration: const Duration(milliseconds: 300),
                    firstChild: Container(), 
                    secondChild: _buildDetailsWidget(pokemon), 
                    crossFadeState: _isDetailsVisible
                        ? CrossFadeState.showSecond
                        : CrossFadeState.showFirst,
                  ),
                ],
              ),
            );
          }

          return const Center(child: Text('Nenhum Pokémon encontrado.'));
        },
      ),
    );
  }

  Widget _buildDetailsWidget(PokemonDetail pokemon) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text('Altura: ${pokemon.height / 10} m',
                  style: const TextStyle(fontSize: 16)),
              Text('Peso: ${pokemon.weight / 10} kg',
                  style: const TextStyle(fontSize: 16)),
            ],
          ),
          const SizedBox(height: 16),
          _buildInfoCard('Tipos', pokemon.types),
          const SizedBox(height: 10),
          _buildInfoCard('Habilidades', pokemon.abilities),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String title, List<String> items) {
    return Card(
      color: Colors.grey[200],
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...items.map((item) => Text('- ${capitalize(item)}')).toList(),
          ],
        ),
      ),
    );
  }
}