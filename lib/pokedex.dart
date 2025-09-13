import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:proj_pokemon/dados.dart';
import 'dart:convert';
import 'package:proj_pokemon/pokemon.dart';
import 'package:proj_pokemon/favoritos.dart';

class Pokedex extends StatefulWidget {
  const Pokedex({Key? key}) : super(key: key);

  @override
  State<Pokedex> createState() => _PokedexState();
}

class _PokedexState extends State<Pokedex> {

  List<Map<String, dynamic>> _filteredPokemonList = [];
  String _selectedType = 'All';
  TextEditingController _controller = TextEditingController();
  List<Map<String, dynamic>> _pokemonList = [];

  @override
  void initState() {
    super.initState();
    _buscarPokemonList();
  }

  void _navegacaoUsuario() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProfilePage()),
    );
  }

  void _buscarPokemonList() async {
    String url = 'https://pokeapi.co/api/v2/pokemon?limit=10';

    http.Response response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      List<dynamic> results = data['results'];

      results.forEach((pokemon) {
        _buscarPokemon(pokemon['url']);
      });
    }
  }

  void _filterPokemonList() {
    setState(() {
      if (_selectedType == 'All') {
        _filteredPokemonList = List.from(_pokemonList);
      } else {
        _filteredPokemonList = _pokemonList
            .where((pokemon) => pokemon['types'].any(
                (type) => type['type']['name'] == _selectedType.toLowerCase()))
            .toList();
      }

      String searchText = _controller.text.toLowerCase();
      if (searchText.isNotEmpty) {
        _filteredPokemonList = _filteredPokemonList.where((pokemon) {
          return pokemon['name'].toString().toLowerCase().contains(searchText) ||
              pokemon['id'].toString().contains(searchText);
        }).toList();
      }
    });
  }

  void _buscarPokemon(String url) async {
    http.Response response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      Map<String, dynamic> pokemonData = json.decode(response.body);
      setState(() {
        pokemonData['isFavorite'] = false;
        _pokemonList.add(pokemonData);
        _pokemonList.sort((a, b) => a['id'].compareTo(b['id']));
        _filteredPokemonList.add(pokemonData);
        _filterPokemonList();
      });
    }
  }

  void _atualizarPokemonFavorito(int index, bool isFavorite) {
    setState(() {
      _filteredPokemonList[index]['isFavorite'] = isFavorite;
      int id = _filteredPokemonList[index]['id'];
      int pokemonIndex = _pokemonList.indexWhere((pokemon) => pokemon['id'] == id);
      if (pokemonIndex != -1) {
        _pokemonList[pokemonIndex]['isFavorite'] = isFavorite;
      }
    });
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
            child: Row(
              children: [
                Container(
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
              ],
            ),
          ),
        ),
      );
    }
    return typeWidgets;
  }

  void _navigateToPokemonPage(BuildContext context, int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Pokemon(pokemonData: _filteredPokemonList[index]),
      ),
    );
  }

  void _navigateToFavorites(BuildContext context, List<Map<String, dynamic>> favoritePokemonList) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Favoritos(favoritePokemonList: favoritePokemonList),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Color(0xFFFAFAFA),
            expandedHeight: 365.0,
            floating: false,
            pinned: true,
            leading: IconButton(
                  icon: Icon(
                    Icons.account_circle,
                    color: Colors.black87,
                  ),
                  onPressed: _navegacaoUsuario,
                ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                margin: EdgeInsets.only(bottom: 30),
                child: Padding(
                      padding: EdgeInsets.fromLTRB(10, 100, 10, 0),
                      child: Column(
                        children: [
                        Image.asset(
                        'images/FlutterMon.png',
                        height: 200,
                        width: 200,
                      ),
                          TextField(
                        controller: _controller,
                        onChanged: (value) {
                          _filterPokemonList();
                        },
                        decoration: InputDecoration(
                          hintText: 'Nome ou numero do Pokemon',
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                         ),
                   )
                  ],
                 )
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(
                  Icons.star,
                    color: Colors.black87
                ),
                onPressed: () {
                  // Filtrar a lista de Pokémons para obter apenas os favoritos
                  List<Map<String, dynamic>> favoritePokemonList = _pokemonList.where((pokemon) => pokemon['isFavorite'] == true).toList();
                  // Navegar para a página de favoritos passando a lista de Pokémons favoritos
                  _navigateToFavorites(context, favoritePokemonList);
                },
              ),
              DropdownButton<String>(
                value: _selectedType,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedType = newValue!;
                    _filterPokemonList();
                    // Re-filtrar a lista quando o tipo selecionado mudar
                  });
                },
                items: <String>[
                  'All',
                  'Fire',
                  'Water',
                  'Grass',
                  'Electric',
                  'ice',
                  'fighting',
                  'poison',
                  'ground',
                  'flying',
                  'bug',
                  'rock',
                  'ghost',
                  'dragon',
                  'dark',
                  'steel',
                  'fairy'
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ],
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
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
                                _pokemonList[index]['isFavorite'] = !(_pokemonList[index]['isFavorite'] ?? false);
                              });
                            },
                            icon: Icon(
                              _filteredPokemonList[index]['isFavorite'] == true
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
              childCount: _filteredPokemonList.length,
            ),
          ),
        ],
      ),
    );
  }
}
