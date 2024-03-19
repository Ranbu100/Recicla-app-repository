import 'package:flutter/material.dart';

class FormularioPage extends StatefulWidget {
  const FormularioPage({Key? key}) : super(key: key);

  @override
  _FormularioPageState createState() => _FormularioPageState();
}

class _FormularioPageState extends State<FormularioPage> {
  String nome = "";
  List<String> itensMarcados = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand, // Preenche todo o espaço da tela
        children: <Widget>[
          // Adicione a imagem de fundo
          Image.asset(
            'assets/9.jpeg', // Substitua com o caminho para a sua imagem de fundo
            fit: BoxFit.cover,
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // Adicione itens de marcação dinamicamente
                  CheckboxListTile(
                    title: Text('Vidro'),
                    value: itensMarcados.contains('Vidro'),
                    onChanged: (value) {
                      setState(() {
                        if (value!) {
                          itensMarcados.add('Vidro');
                        } else {
                          itensMarcados.remove('Vidro');
                        }
                      });
                    },
                  ),
                  CheckboxListTile(
                    title: Text('Metal'),
                    value: itensMarcados.contains('Metal'),
                    onChanged: (value) {
                      setState(() {
                        if (value!) {
                          itensMarcados.add('Metal');
                        } else {
                          itensMarcados.remove('Metal');
                        }
                      });
                    },
                  ),
                  CheckboxListTile(
                    title: Text('Plastico'),
                    value: itensMarcados.contains('Plastico'),
                    onChanged: (value) {
                      setState(() {
                        if (value!) {
                          itensMarcados.add('Plastico');
                        } else {
                          itensMarcados.remove('Plastico');
                        }
                      });
                    },
                  ),
                  CheckboxListTile(
                    title: Text('Papel'),
                    value: itensMarcados.contains('Papel'),
                    onChanged: (value) {
                      setState(() {
                        if (value!) {
                          itensMarcados.add('Papel');
                        } else {
                          itensMarcados.remove('Papel');
                        }
                      });
                    },
                  ),
                  CheckboxListTile(
                    title: Text('Lixo Eletrônico'),
                    value: itensMarcados.contains('Lixo Eletrônico'),
                    onChanged: (value) {
                      setState(() {
                        if (value!) {
                          itensMarcados.add('Lixo Eletrônico');
                        } else {
                          itensMarcados.remove('Lixo Eletrônico');
                        }
                      });
                    },
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    child: Text('Enviar'),
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
