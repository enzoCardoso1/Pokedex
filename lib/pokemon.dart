import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Pokemon extends StatefulWidget {
  final Map<String, dynamic> pokemonData;

  const Pokemon({Key? key, required this.pokemonData}) : super(key: key);

  @override
  State<Pokemon> createState() => _PokemonState();
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

Color _corStatus(String statName) {
  switch (statName) {
    case 'hp':
      return Colors.red;
    case 'attack':
      return Colors.orange;
    case 'defense':
      return Colors.yellow;
    case 'special-attack':
      return Colors.blue;
    case 'special-defense':
      return Colors.green;
    case 'speed':
      return Colors.pink;
    default:
      return Colors.grey;
  }
}

class _PokemonState extends State<Pokemon> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Map<String, dynamic>> _filteredMoves = [];
  List<dynamic> _pokemonCards = [];

  Future<void> _fetchPokemonCards(String searchText) async {
    String pokemonName = widget.pokemonData['name'];
    String apiUrl = 'https://api.pokemontcg.io/v2/cards?q=name:$pokemonName';

    try {
      var response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        setState(() {
          _pokemonCards = jsonData['data'];
          if (searchText.isNotEmpty) {
            _pokemonCards = _filterCards(searchText);
          }
        });
      } else {
        throw Exception('Failed to load cards');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  List<Map<String, dynamic>> _filterMoves(String searchText) {
    List<Map<String, dynamic>> filteredMoves = [];
    for (var move in widget.pokemonData['moves']) {
      String moveName = move['move']['name'].toString();
      if (moveName.toLowerCase().contains(searchText.toLowerCase())) {
        filteredMoves.add(move);
      }
    }
    return filteredMoves;
  }

  List<dynamic> _filterCards(String searchText) {
    List<dynamic> filteredCards = [];
    for (var card in _pokemonCards) {
      String cardName = card['name'].toString();
      if (cardName.toLowerCase().contains(searchText.toLowerCase())) {
        filteredCards.add(card);
      }
    }
    return filteredCards;
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this); // Mudança para 4 abas
    _fetchPokemonCards(''); // Carregar as cartas do Pokémon
  }

  @override
  Widget build(BuildContext context) {
    Color appBarColor = CorTipo(widget.pokemonData['types'][0]['type']['name']);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: Text(
          widget.pokemonData['name'],
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 45),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.asset(
                        'images/bg_pokeball_gradient.png',
                        height: 200,
                        width: 200,
                        fit: BoxFit.cover,
                      ),
                      Image.network(
                        'https://raw.githubusercontent.com/wellrccity/pokedex-html-js/master/assets/img/pokemons/poke_${widget.pokemonData['id']}.gif',
                        height: 200,
                        fit: BoxFit.contain,
                      ),
                    ],
                  ),
                  SizedBox(height: 40),
                  Container(
                    color: appBarColor,
                    height: 400,
                    child: Column(
                      children: [
                        TabBar(
                          controller: _tabController,
                          tabs: [
                            Tab(text: 'Overview'),
                            Tab(text: 'Stats'),
                            Tab(text: 'Moves'),
                            Tab(text: 'Cards'),
                          ],
                        ),
                        SizedBox(height: 20),
                        SizedBox(
                          height: 300, // Altura definida para acomodar o conteúdo da aba
                          child: TabBarView(
                            controller: _tabController,
                            children: [
                              SingleChildScrollView(
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(40, 0, 40, 0), // Adiciona um espaçamento horizontal
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'ID: ${widget.pokemonData['id'].toString().padLeft(3, '0')}',
                                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        'Name: ${widget.pokemonData['name']}',
                                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        'Types:',
                                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                                      ),
                                      Row(
                                        children: [
                                          for (var type in widget.pokemonData['types'])
                                            Padding(
                                              padding: const EdgeInsets.only(right: 10),
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
                                        ],
                                      ),
                                      SizedBox(height: 20), // Adiciona um espaçamento entre as informações do Pokémon
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Height: ${widget.pokemonData['height']}',
                                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                                          ),
                                          SizedBox(height: 10),
                                          Text(
                                            'Weight: ${widget.pokemonData['weight']}',
                                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                                          ),
                                          SizedBox(height: 10),
                                          Text(
                                            'Base Experience: ${widget.pokemonData['base_experience']}',
                                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SingleChildScrollView(
                                  child: Padding(padding: EdgeInsets.fromLTRB(40, 0, 40, 0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Stats:',
                                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                                            ),
                                            for (var stat in widget.pokemonData['stats'])
                                              Padding(
                                                padding: const EdgeInsets.only(bottom: 10),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      '${stat['stat']['name']}: ${stat['base_stat']}',
                                                      style: TextStyle(fontSize: 16),
                                                    ),
                                                    SizedBox(height: 5),
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        border: Border.all(color: Colors.white), // Adiciona uma borda preta
                                                        borderRadius: BorderRadius.circular(5), // Arredonda as bordas
                                                      ),
                                                      child: LinearProgressIndicator(
                                                        value: stat['base_stat'] / 255, // Ajuste se a base de stats for diferente
                                                        minHeight: 10,
                                                        backgroundColor: Colors.grey[300],
                                                        valueColor: AlwaysStoppedAnimation<Color>(
                                                          _corStatus(stat['stat']['name']),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  )
                              ),
                              SingleChildScrollView(
                                  child: Padding(padding: EdgeInsets.fromLTRB(40, 0, 40, 0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: TextField(
                                            decoration: InputDecoration(
                                              labelStyle: TextStyle(
                                                  color: Colors.white
                                              ),
                                              labelText: 'Search move',
                                              prefixIcon: Icon(Icons.search,color: Colors.white,),
                                              border: OutlineInputBorder(),
                                            ),
                                            onChanged: (value) {
                                              setState(() {
                                                _filteredMoves = _filterMoves(value);
                                              });
                                            },
                                          ),
                                        ),
                                        Text(
                                          'Moves:',
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white
                                          ),
                                        ),
                                        for (var move in _filteredMoves.isNotEmpty ? _filteredMoves : widget.pokemonData['moves'])
                                          ListTile(
                                            title: Text(
                                              move['move']['name'].toString(),
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.white
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  )
                              ),
                              SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: TextField(
                                        decoration: InputDecoration(
                                          labelStyle: TextStyle(
                                            color: Colors.white,
                                          ),
                                          labelText: 'Search card',
                                          prefixIcon: Icon(
                                            Icons.search,
                                            color: Colors.white,
                                          ),
                                          border: OutlineInputBorder(),
                                        ),
                                        onChanged: (value) {
                                          _fetchPokemonCards(value);
                                        },
                                      ),
                                    ),
                                    GridView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3,
                                        mainAxisSpacing: 4.0,
                                        crossAxisSpacing: 4.0,
                                        childAspectRatio: 0.7,
                                      ),
                                      itemCount: _pokemonCards.length,
                                      itemBuilder: (BuildContext context, int index) {
                                        return GestureDetector(
                                          onTap: () {
                                            showDialog(
                                              context: context,
                                              builder: (_) => AlertDialog(
                                                content: Image.network(
                                                  _pokemonCards[index]['images']['large'],
                                                  height: 400,
                                                  width: 400,
                                                  fit: BoxFit.contain,
                                                ),
                                              ),
                                            );
                                          },
                                          child: ListTile(
                                            title: Image.network(
                                              _pokemonCards[index]['images']['small'],
                                              height: 100,
                                              width: 100,
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}