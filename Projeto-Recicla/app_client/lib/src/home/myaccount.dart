import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'homepage.dart';

class MinhaContaScreen extends StatefulWidget {
  const MinhaContaScreen({Key? key}) : super(key: key);

  @override
  _MinhaContaScreenState createState() => _MinhaContaScreenState();
}

class _MinhaContaScreenState extends State<MinhaContaScreen> {
  String _usuarioEmail = ''; // Email do usuário recuperado do SharedPreferences
  Map<String, dynamic> _userData = {}; // Dados do usuário

  final TextEditingController _ruaController = TextEditingController();
  final TextEditingController _numCasaController = TextEditingController();
  final TextEditingController _bairroController = TextEditingController();
  final TextEditingController _cepController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nomeController = TextEditingController();

  bool _editingEnabled = false; // Estado de edição dos campos de texto

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  Future<void> _getUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? usuarioEmail = prefs.getString('user_email');

    setState(() {
      _usuarioEmail = usuarioEmail!;
    });

    final response =
        await http.get(Uri.parse('http://localhost:4466/user/$_usuarioEmail'));

    if (response.statusCode == 200) {
      final userData = json.decode(response.body);

      setState(() {
        _userData = userData;

        // Preencher os campos de texto com os dados do usuário
        _ruaController.text = _userData['rua'];
        _emailController.text = _userData['email'];
        _numCasaController.text = _userData['num_casa'];
        _bairroController.text = _userData['bairro'];
        _cepController.text = _userData['cep'];
        _nomeController.text = _userData['nome'];
      });
    } else {
      // Tratar erro de busca de dados do usuário
      print('Erro ao buscar dados do usuário: ${response.body}');
    }
  }

  Future<void> _updateUserData() async {
    final Map<String, dynamic> updatedUserData = {
      'rua': _ruaController.text,
      'num_casa': _numCasaController.text,
      'bairro': _bairroController.text,
      'cep': _cepController.text,
    };
    final response = await http.put(
      Uri.parse('http://localhost:4466/up/$_usuarioEmail'),
      body: jsonEncode(updatedUserData),
    );

    if (response.statusCode == 200) {
      // Atualizar os dados na tela
      _getUserData();
      setState(() {
        _editingEnabled = false; // Desabilitar a edição após a atualização
      });
    } else {
      // Tratar erro de atualização
      print('Erro ao atualizar dados: ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Minha Conta',
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          color: Colors.white,
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const HomePage()));
          },
        ),
        backgroundColor: Colors.green,
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  "fundojuda.png",
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 10),
                TextField(
                  decoration: InputDecoration(labelText: 'Nome:'),
                  controller: _nomeController,
                  enabled: false,
                ),
                TextField(
                  decoration: InputDecoration(labelText: 'Email:'),
                  controller: _emailController,
                  enabled: false,
                ),
                TextField(
                  decoration: InputDecoration(labelText: 'Rua:'),
                  controller: _ruaController,
                  enabled: _editingEnabled,
                ),
                TextField(
                  decoration: InputDecoration(labelText: 'Número da Casa:'),
                  controller: _numCasaController,
                  enabled: _editingEnabled,
                ),
                TextField(
                  decoration: InputDecoration(labelText: 'Bairro:'),
                  controller: _bairroController,
                  enabled: _editingEnabled,
                ),
                TextField(
                  decoration: InputDecoration(labelText: 'CEP:'),
                  controller: _cepController,
                  enabled: _editingEnabled,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (!_editingEnabled) {
                      setState(() {
                        _editingEnabled = true;
                      });
                    } else {
                      _updateUserData();
                    }
                  },
                  child: Text(
                    _editingEnabled ? 'Atualizar Dados' : 'Editar',
                    style: TextStyle(color: Colors.green),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                if (_editingEnabled)
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _editingEnabled = false;
                        _getUserData(); // Reseta os campos para os dados atuais
                      });
                    },
                    child: Text(
                      'Cancelar',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
