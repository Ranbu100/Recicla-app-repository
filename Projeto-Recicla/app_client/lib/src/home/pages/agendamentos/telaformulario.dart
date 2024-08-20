// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'calendario.dart';
import 'multiselected.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TelaFormulario extends StatefulWidget {
  const TelaFormulario({Key? key}) : super(key: key);

  @override
  State<TelaFormulario> createState() => _TelaFormularioState();
}

class _TelaFormularioState extends State<TelaFormulario> {
  DateTime _dateTime = DateTime.now();
  TimeOfDay _timeOfDay = TimeOfDay.now();
  final TextEditingController _descriptionController = TextEditingController();
  List<String> _selectedItems = [];
  String dropdownValue = 'one';

  void _showMultiselected() async {
    final List<String> items = [
      'Eletronico',
      'Papel',
      'Metal',
      'Plastico',
      'Orgânico',
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
        _selectedItems = results;
      });
    }
  }

  void _showDatePicker(BuildContext context) {
    showDatePicker(
      context: context,
      initialDate: _dateTime,
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    ).then((date) {
      if (date != null) {
        setState(() {
          _dateTime = date;
        });
      }
    });
  }

  void _showTimePicker(BuildContext context) {
    showTimePicker(
      context: context,
      initialTime: _timeOfDay,
    ).then((time) {
      if (time != null) {
        setState(() {
          _timeOfDay = time;
        });
      }
    });
  }

  Future<void> _submitForm() async {
    const String url =
        'https://yourapi.com/endpoint'; // Replace with your API endpoint
    final Map<String, dynamic> data = {
      'date': '${_dateTime.year}-${_dateTime.month}-${_dateTime.day}',
      'time': '${_timeOfDay.hour}:${_timeOfDay.minute}',
      'type': _selectedItems,
      'description': _descriptionController.text,
    };

    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(data),
    );

    if (response.statusCode == 200) {
      // Handle successful response
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Agendamento realizado com sucesso!')),
      );
    } else {
      // Handle error response
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao realizar o agendamento.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade50,
      appBar: AppBar(
        backgroundColor: Colors.green.shade100,
        title: const Text(
          "Marque sua coleta",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const CalendarPage()));
          },
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Card(
            shape:
                BeveledRectangleBorder(borderRadius: BorderRadius.circular(15)),
            color: Colors.green.shade200,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                const Text(
                  "Data:",
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 25, 107, 4)),
                  textAlign: TextAlign.center,
                ),
                Card(
                  elevation: 8.0,
                  shape: ContinuousRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  color: Colors.green.shade300,
                  child: SizedBox(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          "${_dateTime.day}/${_dateTime.month}/${_dateTime.year}",
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green.shade100,
                            shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12)),
                            ),
                          ),
                          onPressed: () => _showDatePicker(context),
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              "Selecione a data",
                              style: TextStyle(
                                  color: Color.fromARGB(255, 20, 87, 3),
                                  fontSize: 15),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Hora:",
                  style: TextStyle(
                    fontSize: 22,
                    color: Color.fromARGB(255, 25, 107, 4),
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                Card(
                  elevation: 8.0,
                  shape: ContinuousRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  color: Colors.green.shade300,
                  child: SizedBox(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          _timeOfDay.format(context),
                          style: const TextStyle(
                            fontSize: 22,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green.shade100,
                            shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12)),
                            ),
                          ),
                          onPressed: () => _showTimePicker(context),
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              "Selecione a hora",
                              style: TextStyle(
                                  color: Color.fromARGB(255, 20, 87, 3),
                                  fontSize: 15),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                    backgroundColor: Colors.green.shade100,
                  ),
                  onPressed: _showMultiselected,
                  child: const Text(
                    "Tipo de lixo",
                    style: TextStyle(
                        color: Color.fromARGB(255, 20, 87, 3), fontSize: 15),
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 30,
                    right: 30,
                  ),
                  child: TextField(
                    controller: _descriptionController,
                    maxLength: 200,
                    decoration: const InputDecoration(
                      labelText:
                          'Descrição do lixo (ex: Tenho cinco sacolas de papelão)',
                      labelStyle: TextStyle(fontSize: 14.5),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12))),
                    ),
                    maxLines: 5,
                  ),
                ),
                const SizedBox(height: 15),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                    backgroundColor: Colors.green.shade100,
                  ),
                  onPressed: _submitForm,
                  child: const Text(
                    "Enviar Agendamento",
                    style: TextStyle(
                        color: Color.fromARGB(255, 20, 87, 3), fontSize: 15),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
