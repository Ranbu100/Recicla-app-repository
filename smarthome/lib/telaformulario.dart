import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smarthome/calendario.dart';
import 'package:smarthome/homepage.dart';
import 'package:smarthome/multiselected.dart';

class telaFormulario extends StatefulWidget {
  telaFormulario({Key? key}) : super(key: key);

  @override
  State<telaFormulario> createState() => _telaFormularioState();
}

class _telaFormularioState extends State<telaFormulario> {
  DateTime _dateTime = new DateTime.now();

  List<String> _selecteditems = [];

  String Droppdownvalue = "one";

  void _showMultiselected() async {
    final List<String> items = [
      'eletronico',
      'papel',
      'metal',
      'plastico',
      'orgânico',
    ];

    final List<String>? results = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return multiselected(
          items: items,
        );
      },
    );

    if (results != null) {
      setState(() {
        _selecteditems = results;
      });
    }
  }

  void _showdatepicker(BuildContext context) {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    ).then((value) {
      setState(() {
        _dateTime = value!;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade50,
      appBar: AppBar(
        backgroundColor: Colors.green.shade100,
        title: Text(
          "Marque sua coleta",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => CalendarPage()));
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 10,
            ),
            Text(
              "sua data:\n" +
                  _dateTime.day.toString() +
                  "/" +
                  _dateTime.month.toString() +
                  "/" +
                  _dateTime.year.toString(),
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10,
            ),
            MaterialButton(
              onPressed: () {
                _showdatepicker(context);
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "selecione a data ",
                  style: TextStyle(color: Colors.green, fontSize: 15),
                ),
              ),
              color: Colors.green.shade100,
            ),
            SizedBox(
              height: 20,
            ),

            // este widjet serve para criar o botão que  acessará o droppdown
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.horizontal(right: Radius.zero)),
                    backgroundColor: Colors.green.shade100),
                onPressed: _showMultiselected,
                child: Text(
                  "selecionar o lixo",
                  style: TextStyle(color: Colors.green, fontSize: 15),
                ))
          ],
        ),
      ),
    );
  }
}
