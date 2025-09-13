import 'package:flutter/material.dart';
import 'package:proj_pokemon/dados.dart';
import 'package:proj_pokemon/favoritos.dart';
import 'package:proj_pokemon/login.dart';
import 'package:proj_pokemon/pokedex.dart';
import 'package:proj_pokemon/cadastro.dart';
import 'package:proj_pokemon/pokemon.dart';

void main() {
  runApp(const MaterialApp(
    home: Cadastro(),
    debugShowCheckedModeBanner: false,
  ));
}
