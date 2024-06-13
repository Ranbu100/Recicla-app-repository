import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:smarthome/roudedbutton.dart';

class MeuLixo extends StatefulWidget {
  const MeuLixo({super.key});

  @override
  State<MeuLixo> createState() => _MeuLixoState();
}

class _MeuLixoState extends State<MeuLixo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo.shade50,
      body: SafeArea(
          child: Container(
        margin: const EdgeInsets.only(top: 18, left: 24, right: 24),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(
                      Icons.arrow_back_ios,
                      color: Color.fromARGB(255, 71, 162, 75),
                    )),
                const RotatedBox(
                  quarterTurns: 135,
                  child: Icon(
                    Icons.bar_chart_rounded,
                    color: Color.fromARGB(255, 71, 162, 75),
                    size: 28,
                  ),
                ),
              ],
            ),
            Expanded(
                child: ListView(
              physics: const BouncingScrollPhysics(),
              children: [
                const SizedBox(height: 32),
                CircularPercentIndicator(
                  radius: 180,
                  lineWidth: 14,
                  percent: 0.75,
                  progressColor: Color.fromARGB(255, 71, 162, 75),
                  center: const Text(
                    'total:\n  26g',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                const Center(
                  child: Text(
                    'lixo reciclado',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black54),
                  ),
                ),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    roundedButton(title: 'geral', isActive: true),
                    roundedButton(title: 'serviços'),
                  ],
                ),
                const SizedBox(height: 37),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24),
                        child: Text(
                          'bom',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                )
              ],
            )),
          ],
        ),
      )),
    );
  }
}
