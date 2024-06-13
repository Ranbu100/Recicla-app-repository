import 'package:flutter/material.dart';
import 'package:smarthome/ajuda.dart';
import 'package:smarthome/calendario.dart';
import 'package:smarthome/meulixo.dart';
import 'cardmenu.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade50,
      body: SafeArea(
          child: Container(
        margin: const EdgeInsets.only(top: 18, left: 24, right: 24),
        child: Column(children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Bem-vindo",
                style: TextStyle(
                  fontSize: 18,
                  color: Color.fromARGB(255, 71, 162, 75),
                  fontWeight: FontWeight.bold,
                ),
              ),
              RotatedBox(
                  quarterTurns: 135,
                  child: Icon(
                    Icons.bar_chart_rounded,
                    size: 28,
                    color: Color.fromARGB(255, 71, 162, 75),
                  ))
            ],
          ),
          Expanded(
              child: ListView(
            physics: const BouncingScrollPhysics(),
            children: [
              const SizedBox(
                height: 32,
              ),
              Center(
                child: Image.asset(
                  'assets/images/pessoabannerR.png',
                  scale: 1.2,
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              const Center(
                child: Text(
                  'dashboard',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              const Text(
                'serviços',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  cardmenu(
                    title: 'agendamento',
                    icon: 'assets/images/icones (1).png',
                    ontap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CalendarApp()));
                    },
                  ),
                  cardmenu(
                    ontap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const MeuLixo()));
                    },
                    title: 'meu lixo',
                    icon: 'assets/images/caminhaoofc.jpg',
                    color: Color.fromARGB(255, 255, 255, 255),
                    fontcolor: Colors.grey,
                    //164,255,164,1.000)
                  ),
                ],
              ),
              const SizedBox(
                height: 28,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  cardmenu(
                      title: 'conta',
                      icon: 'assets/images/pessoa.jpg',
                      fontcolor: Colors.grey,
                      color: Color.fromARGB(255, 255, 255, 255)),
                  cardmenu(
                    title: 'ajuda',
                    icon: 'assets/images/ajuda.jpg',
                    ontap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Ajuda()));
                    },
                    color: Color.fromARGB(255, 255, 255, 255),
                    fontcolor: Colors.grey,
                  ),
                ],
              ),
            ],
          ))
        ]),
      )),
    );
  }
}
