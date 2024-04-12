import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../auth/stores/auth_store.dart';
import '../features/cardmenu.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  HomePageState createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final PageController _pageController = PageController();
  int _currentPage = 0; // Página atual do carrossel
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (_currentPage < 2) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.ease,
      );
    });
  }

  void _logout() {
    final store = Modular.get<AuthStore>();
    store.logout(); // Chamar método de logout no AuthStore
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final carouselHeight = screenHeight / 2.6;
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.green.shade50,
      drawer: Drawer(
        child: Column(
          children: [
            const ListTile(
              leading: Icon(Icons.home),
              title: Text('Página Inicial'),
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
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.only(top: 18, left: 24, right: 24),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Projeto RECICLA",
                    style: TextStyle(
                      fontSize: 18,
                      color: Color.fromARGB(255, 71, 162, 75),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      _scaffoldKey.currentState?.openDrawer();
                    },
                    icon: const Icon(
                      Icons.bar_chart_rounded,
                      size: 28,
                      color: Color.fromARGB(255, 71, 162, 75),
                    ),
                  ),
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
                      child: SizedBox(
                        height: carouselHeight,
                        width: screenWidth,
                        child: PageView.builder(
                          controller: _pageController,
                          itemCount: 3,
                          onPageChanged: (int page) {
                            setState(() {
                              _currentPage = page;
                            });
                          },
                          itemBuilder: (context, index) {
                            final Uri? url;
                            if (index == 0) {
                              url = Uri.parse(
                                  'https://itapipoca.ce.gov.br/informa.php?id=574');
                            } else if (index == 1) {
                              url = Uri.parse(
                                  'https://itapipoca.ce.gov.br/informa.php?id=580');
                            } else {
                              url = Uri.parse(
                                  'https://itapipoca.ce.gov.br/informa.php?id=572');
                            }
                            return InformationPage(
                              imagePath: index == 0
                                  ? 'images/pag1.jpeg'
                                  : (index == 1
                                      ? 'images/pag2.jpeg'
                                      : 'images/pag3.jpeg'),
                              url: url,
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    const SizedBox(height: 40),
                    const Text(
                      'Serviços',
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
                          ontap: () {
                            Modular.to.navigate('/home/date');
                          },
                          title: 'dia da coleta',
                          icon: 'images/icones.png',
                        ),
                        cardmenu(
                          ontap: () {
                            Modular.to.navigate('/home/lixo');
                          },
                          title: 'meu lixo',
                          icon: 'images/caminhaoofc.jpg',
                          color: const Color.fromARGB(255, 255, 255, 255),
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
                            ontap: () {
                              Modular.to.navigate('/home/conta');
                            },
                            title: 'conta',
                            icon: 'images/pessoa.jpg',
                            fontcolor: Colors.grey,
                            color: const Color.fromARGB(255, 255, 255, 255)),
                        cardmenu(
                          ontap: () {
                            Modular.to.navigate('/home/ajuda');
                          },
                          title: 'ajuda',
                          icon: 'images/ajuda.jpg',
                          color: const Color.fromARGB(255, 255, 255, 255),
                          fontcolor: Colors.grey,
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class InformationPage extends StatelessWidget {
  final String imagePath;
  final Uri? url;

  const InformationPage({
    Key? key,
    required this.imagePath,
    required this.url,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _launchURL(context, url!);
      },
      child: Image.asset(
        imagePath,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      ),
    );
  }

  Future<void> _launchURL(BuildContext context, Uri url) async {
    if (await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw "Não foi possível abrir a URL";
    }
    //  else {
    //   // Exiba uma mensagem de erro para o usuário
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(
    //       content: Text('Não foi possível abrir a URL.'),
    //     ),
    //   );
    // }
  }
}
