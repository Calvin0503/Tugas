import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pokedex/models/pokemon.model.dart';
import 'package:pokedex/screens/home.screen.dart';
import 'package:http/http.dart';

void main() => runApp(pokedux());

class pokedux extends StatelessWidget {
  // Client is used for HTTP requests
  final client = Client();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'pokedux',
      home: Scaffold(
        backgroundColor: Colors.orange[900],
        appBar: AppBar(
          title: Text("pokedux"),
          backgroundColor: Colors.green[600],
        ),
        body: buildPokemonScreen(),
      ),
    );
  }

  Widget buildPokemonScreen() {

    return FutureBuilder(
      future: fetchPokemonsFromAPI(),


      builder: (BuildContext context, AsyncSnapshot<List<Pokemon>> snapshot) {
        if (snapshot.hasData) {
          return HomeScreen(pokemons: snapshot.data);
        } else {
          // Show a loading spinner
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Future<List<Pokemon>> fetchPokemonsFromAPI() async {
    final response = await client.get(
        'https://raw.githubusercontent.com/rsr-itminds/flutter-workshop/master/data/pokedex.json');


    final List<dynamic> data = json.decode(response.body);

    return data.map((json) => Pokemon.fromJson(json)).toList();
  }
}
