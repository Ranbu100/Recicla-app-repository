import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:http/http.dart' as http;
import '../../../auth/stores/auth_store.dart';
import '../homepage/homepage.dart';

class ScorePage extends StatefulWidget {
  const ScorePage({Key? key}) : super(key: key);

  @override
  State<ScorePage> createState() => _ScorePageState();
}

class _ScorePageState extends State<ScorePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _logout() {
    final store = Modular.get<AuthStore>();
    store.logout(); // Chamar método de logout no AuthStore
  }

  void _openDrawer() {
    _scaffoldKey.currentState?.openDrawer();
  }

  Future<void> fetchData() async {
    final response =
        await http.get(Uri.parse('http://localhost:3000/sales-data'));

    if (response.statusCode == 200) {
      final List<dynamic> responseData = jsonDecode(response.body);
      setState(() {
        final data = responseData
            .map((item) => FlSpot(
                DateTime.parse(item['date']).millisecondsSinceEpoch.toDouble(),
                item['qntd_residuos'].toDouble()))
            .toList();
      });
    } else {
      throw Exception('Falhou em Puxar os Scores');
    }
  }

  final List<FlSpot> data = [
    FlSpot(1, 100),
    FlSpot(2, 75),
    FlSpot(3, 150),
    FlSpot(4, 200),
    FlSpot(5, 50),
    FlSpot(6, 300),
    FlSpot(7, 100),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Página Inicial'),
              onTap: () {
                Modular.to.pushNamed('/home');
              },
            ),
            ListTile(
              leading: const Icon(Icons.calendar_month_outlined),
              title: const Text('Calendário'),
              onTap: () {
                Modular.to.pushNamed('/home/date');
              },
            ),
            ListTile(
              leading: const Icon(Icons.pest_control_rodent_sharp),
              title: const Text('Meu Lixo'),
              onTap: () {
                Modular.to.pushNamed('/home/lixo');
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Minha Conta'),
              onTap: () {
                Modular.to.pushNamed('/home/conta');
              },
            ),
            ListTile(
              leading: const Icon(Icons.help),
              title: const Text('Ajuda'),
              onTap: () {
                Modular.to.pushNamed('/home/ajuda');
              },
            ),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text('Logout'),
                  onTap: () {
                    _logout();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text(
          'Scoreboard',
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const HomePage()));
          },
        ),
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.bar_chart_rounded,
              size: 28,
              color: Colors.white,
            ),
            onPressed: _openDrawer,
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Dados de Reciclagem',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10.0),
            Expanded(
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: true),
                  titlesData: FlTitlesData(show: true),
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(
                      color: const Color(0xff37434d),
                      width: 1,
                    ),
                  ),
                  lineBarsData: [
                    LineChartBarData(
                      spots: data,
                      isCurved: true,
                      color: Colors.blue,
                      barWidth: 4,
                      isStrokeCapRound: true,
                      belowBarData: BarAreaData(
                        show: true,
                        color: Colors.blue.withOpacity(0.3),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FilterButton(
                  text: '24h',
                  onPressed: () {
                    setState(() {
                      // Atualizar dados para as últimas 24 horas
                    });
                  },
                ),
                FilterButton(
                  text: 'Essa Semana',
                  onPressed: () {
                    setState(() {
                      // Atualizar dados para esta semana
                    });
                  },
                ),
                FilterButton(
                  text: 'Esse Mês',
                  onPressed: () {
                    setState(() {
                      // Atualizar dados para este mês
                    });
                  },
                ),
                FilterButton(
                  text: 'Esse Ano',
                  onPressed: () {
                    setState(() {
                      // Atualizar dados para este ano
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class FilterButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const FilterButton({Key? key, required this.text, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(text),
    );
  }
}

class TimeSeriesSales {
  final DateTime time;
  final int sales;

  TimeSeriesSales(this.time, this.sales);
}
