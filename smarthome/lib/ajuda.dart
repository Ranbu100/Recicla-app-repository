import 'package:flutter/material.dart';
import 'package:smarthome/tipos_ajuda.dart';
import 'homepage.dart';

class Ajuda extends StatefulWidget {
  const Ajuda({super.key});

  @override
  State<Ajuda> createState() => _AjudaState();
}

class _AjudaState extends State<Ajuda> {
  final List<TipoAjuda> _products = TipoAjuda.generateitems(8);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            "assets/images/fundojuda.png",
            fit: BoxFit.cover,
          ),
          SingleChildScrollView(
            child: ExpansionPanelList(
              expansionCallback: (int index, bool isExpanded) {
                setState(() => _products[index].isExpanded = !isExpanded);
              },
            ),
          )
        ],
      ),
      appBar: AppBar(
        title: Text(
          'ajuda',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color.fromARGB(255, 82, 188, 86),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(
                context, MaterialPageRoute(builder: (context) => HomePage()));
          },
        ),
      ),
    );
  }
}
