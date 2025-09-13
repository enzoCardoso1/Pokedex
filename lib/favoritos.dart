import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:proj_pokemon/pokemon.dart';

class Favoritos extends StatefulWidget {

  final List<Map<String, dynamic>> favoritePokemonList;

  Favoritos({Key? key, required this.favoritePokemonList}) : super(key: key);


  @override
  State<Favoritos> createState() => _FavoritosState();
}

class _FavoritosState extends State<Favoritos> {
  List<Map<String, dynamic>> _filteredPokemonList = [];
  String _selectedType = 'All';
  TextEditingController _controller = TextEditingController();
  List<Map<String, dynamic>> _pokemonList = [];

  @override
  void initState() {
    super.initState();
    _fetchPokemonList();
  }

  void _fetchPokemonList() async {
    String url = 'https://pokeapi.co/api/v2/pokemon?limit=150';

    http.Response response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      List<dynamic> results = data['results'];

      results.forEach((pokemon) {
        _fetchPokemon(pokemon['url']);
      });
    }
  }

  void _filterPokemonList() {
    setState(() {
      if (_selectedType == 'All') {
        _filteredPokemonList = List.from(widget.favoritePokemonList.where((pokemon) => pokemon['isFavorite']));
      } else {
        _filteredPokemonList = widget.favoritePokemonList
            .where((pokemon) => pokemon['types'].any((type) => type['type']['name'] == _selectedType.toLowerCase()))
            .toList();
      }
    });
  }

  void _fetchPokemon(String url) async {
    http.Response response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      Map<String, dynamic> pokemonData = json.decode(response.body);
      setState(() {
        pokemonData['isFavorite'] = false;
        _pokemonList.add(pokemonData);
        _pokemonList.sort((a, b) => a['id'].compareTo(b['id']));
        _filterPokemonList();
      });
    }
  }

  void _navigateToPokemonPage(BuildContext context, int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Pokemon(pokemonData: _filteredPokemonList[index]),
      ),
    );
  }

  Color CorTipo(String types) {
    switch (types) {
      case 'normal':
        return Colors.grey[600]!;
      case 'fire':
        return Colors.orange[400]!;
      case 'water':
        return Colors.blue[400]!;
      case 'grass':
        return Colors.green[300]!;
      case 'electric':
        return Colors.amber[300]!;
      case 'ice':
        return Colors.lightBlueAccent[200]!;
      case 'fighting':
        return Colors.pink[600]!;
      case 'poison':
        return Colors.purple;
      case 'ground':
        return Colors.orange[900]!;
      case 'flying':
        return Colors.indigo;
      case 'psychic':
        return Colors.pink;
      case 'bug':
        return Colors.lightGreen;
      case 'rock':
        return Colors.brown;
      case 'ghost':
        return Colors.deepPurpleAccent;
      case 'dragon':
        return Colors.deepPurple;
      case 'dark':
        return Colors.black87;
      case 'steel':
        return Colors.blueGrey;
      case 'fairy':
        return Colors.pinkAccent[100]!;
      default:
        return Colors.grey;
    }
  }

  Color _pegarCorType(String type) {
    switch (type) {
      case 'normal':
        return Colors.grey[700]!;
      case 'fire':
        return Colors.orange[600]!;
      case 'water':
        return Colors.blue[300]!;
      case 'grass':
        return Colors.green[500]!;
      case 'electric':
        return Colors.amber[400]!;
      case 'ice':
        return Colors.lightBlueAccent[100]!;
      case 'fighting':
        return Colors.pink[700]!;
      case 'poison':
        return Colors.purple[300]!;
      case 'ground':
        return Colors.orange[800]!;
      case 'flying':
        return Colors.indigo[300]!;
      case 'psychic':
        return Colors.pink[300]!;
      case 'bug':
        return Colors.lightGreen[300]!;
      case 'rock':
        return Colors.brown[400]!;
      case 'ghost':
        return Colors.deepPurpleAccent[100]!;
      case 'dragon':
        return Colors.deepPurple[300]!;
      case 'dark':
        return Colors.black87;
      case 'steel':
        return Colors.blueGrey[300]!;
      case 'fairy':
        return Colors.pinkAccent[200]!;
      default:
        return Colors.grey[300]!;
    }
  }

  List<Widget> renderTypes(List<dynamic> types) {
    List<Widget> typeWidgets = [];
    for (var type in types) {
      typeWidgets.add(
        Padding(
          padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
          child: Container(
            decoration: BoxDecoration(
              color: _pegarCorType(type['type']['name'].toString()),
              borderRadius: BorderRadius.circular(5),
            ),
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Text(
              type['type']['name'].toString(),
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      );
    }
    return typeWidgets;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFAFAFA),
        iconTheme: IconThemeData(
            color: Colors.black87
        ),
        title: Text(
          'Favoritos',
          style: TextStyle(
            color: Colors.black87,
          ),
        ),
        actions: [
          DropdownButton<String>(
            value: _selectedType,
            onChanged: (String? newValue) {
              setState(() {
                _selectedType = newValue!;
                _filterPokemonList();
              });
            },
            items: <String>[
              'All',
              'Fire',
              'Water',
              'Grass',
              'Electric',
              'Ice',
              'Fighting',
              'Poison',
              'Ground',
              'Flying',
              'Psychic',
              'Bug',
              'Rock',
              'Ghost',
              'Dragon',
              'Dark',
              'Steel',
              'Fairy'
            ].map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _filteredPokemonList.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              _navigateToPokemonPage(context, index);
            },
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
              child: Container(
                height: 110,
                width: 300,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: CorTipo(_filteredPokemonList[index]['types'][0]['type']['name'].toString()),
                ),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        setState(() {
                          widget.favoritePokemonList[index]['isFavorite'] = !(widget.favoritePokemonList[index]['isFavorite'] ?? false);
                          int id = widget.favoritePokemonList[index]['id'];
                          int pokemonIndex = _pokemonList.indexWhere((pokemon) => pokemon['id'] == id);
                          if (pokemonIndex != -1) {
                            _pokemonList[pokemonIndex]['isFavorite'] = widget.favoritePokemonList[index]['isFavorite'];
                          }
                        });
                      },
                      icon: Icon(
                        widget.favoritePokemonList[index]['isFavorite'] == true
                            ? Icons.star
                            : Icons.star_border,
                        color: Colors.yellow,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "#${_filteredPokemonList[index]['id'].toString().padLeft(3, '0')}",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            _filteredPokemonList[index]['name'],
                            style: TextStyle(
                              color: Color(0xFFFAFAFA),
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Row(
                            children: renderTypes(_filteredPokemonList[index]['types']),
                          ),
                        ],
                      ),
                    ),
                    Stack(
                      children: [
                        Positioned(
                          child: Align(
                            alignment: Alignment.bottomRight,
                            child: SizedBox(
                              width: 115,
                              height: 115,
                              child: Image.asset(
                                'images/bg_pokeball_gradient.png',
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: SizedBox(
                            width: 115,
                            height: 115,
                            child: Image.network(
                              'https://raw.githubusercontent.com/wellrccity/pokedex-html-js/master/assets/img/pokemons/poke_${_filteredPokemonList[index]['id']}.gif',
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
