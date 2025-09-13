import 'package:flutter/material.dart';
import 'package:proj_pokemon/pokedex.dart';

enum Equipe { instinto, sabedoria, valor }

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Equipe? _equipes;
  bool _mostrarInformacoes = false;
  double _valorSlider = 0;
  String _imgEstrela = "images/estrela1.png";

  void _avaliarApp() {
    setState(() {
      if (_valorSlider == 0) {
        _imgEstrela = "images/estrela1.png";
      }
      else if (_valorSlider == 1) {
        _imgEstrela = "images/estrela1.png";
      }
      else if (_valorSlider >= 1 && _valorSlider < 2) {
        _imgEstrela = "images/estrela2.png";
      } else if (_valorSlider >= 2 && _valorSlider < 3) {
        _imgEstrela = "images/estrela3.png";
      } else if (_valorSlider >= 3 && _valorSlider < 4) {
        _imgEstrela = "images/estrela4.png";
      } else if (_valorSlider >= 5) {
        _imgEstrela = "images/estrela5.png";
      }
    });
  }

  void _navegacao() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Pokedex()),
    );
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
          'Perfil',
          style: TextStyle(
            color: Colors.black87,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Center(
              child: CircleAvatar(
                radius: 60,
                backgroundImage: AssetImage('images/usuarioPerfil.jpg'),
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: Text(
                'Nome do Usuário', // nome do usuário
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 20),
            // informações pessoais
            Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        _mostrarInformacoes = !_mostrarInformacoes;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Icon(Icons.person,
                              color: Colors.black),
                          SizedBox(width: 10),
                          Text(
                            'Informações da Conta',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Spacer(),
                          Icon(
                            _mostrarInformacoes
                                ? Icons.keyboard_arrow_up
                                : Icons.keyboard_arrow_down,
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (_mostrarInformacoes)
                    Column(
                      children: [
                        ListTile(
                          leading: Icon(Icons.person),
                          title: Text('Nome Completo'), // nome completo do usuário
                        ),
                        ListTile(
                          leading: Icon(Icons.phone),
                          title: Text('Número de Telefone'), // número de telefone do usuário
                        ),
                        ListTile(
                          leading: Icon(Icons.email),
                          title: Text('Email'), // email do usuário
                        ),
                      ],
                    ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: Text(
                'Escolha uma equipe!', // nome do usuário
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          Column(
            children: [
              RadioListTile(
                activeColor: Colors.amber,
                title: const Text('Instinto'),
                value: Equipe.instinto,
                groupValue: _equipes,
                onChanged: (Equipe? value) {
                  setState(() {
                    _equipes = value;
                  });
                },
              ),
              RadioListTile(
                activeColor: Colors.blueAccent,
                title: const Text('Sabedoria'),
                value: Equipe.sabedoria,
                groupValue: _equipes,
                onChanged: (Equipe? value) {
                  setState(() {
                    _equipes = value;
                  });
                },
              ),
              RadioListTile(
                activeColor: Colors.red,
                title: const Text("Valor"),
                value: Equipe.valor,
                groupValue: _equipes,
                onChanged: (Equipe? value) {
                  setState(() {
                    _equipes = value;
                  });
                },
              ),
            ],
          ),
            SizedBox(height: 20),
            Center(
              child: Text(
                'Deixe um feedback!', // nome do usuário
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Column(
              children: [
                Slider(
                  activeColor: Colors.black87,
                  inactiveColor: Colors.grey,
                  value: _valorSlider,
                  max: 5,
                  divisions: 4,
                  onChanged: (double? value) {
                    setState((){
                      _valorSlider = value!;
                      _avaliarApp();
                    });
                  },
                ),
                Image.asset(
                  _imgEstrela,
                height: 130,
                  width: 130,
                ),
                ElevatedButton(
                  onPressed: _navegacao,
                  child: Text("Entrar"),
                ),
                SizedBox(height: 20),
              ],
            ),
          ],
        ),
      ),
    );
  }
}