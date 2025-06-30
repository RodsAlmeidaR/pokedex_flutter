import 'package:flutter/material.dart';
import '../models/pokemon.dart';

class DetailsScreen extends StatelessWidget {
  final PokemonDetail pokemon;

  const DetailsScreen({super.key, required this.pokemon});

  String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(capitalize(pokemon.name)),
        backgroundColor: Colors.red,
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.network(
                  pokemon.imageUrl,
                  height: 200,
                  width: 200,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 16),
                Text(
                  'Nº ${pokemon.id}',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text('Altura: ${pokemon.height / 10} m',
                        style: const TextStyle(fontSize: 16)),
                    Text('Peso: ${pokemon.weight / 10} kg',
                        style: const TextStyle(fontSize: 16)),
                  ],
                ),
                const SizedBox(height: 20),
                _buildInfoCard('Tipos', pokemon.types),
                const SizedBox(height: 10),
                _buildInfoCard('Habilidades', pokemon.abilities),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, List<String> items) {
    return Card(
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