import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get_connect/http/src/request/request.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import '../../../auth/stores/auth_store.dart';
import '../../features/cardmenu.dart';
import 'extensoes/information_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:mime/mime.dart';

class News {
  final String linkImage;
  final String linkSite;
  final String manchete;

  News(
      {required this.linkImage,
      required this.linkSite,
      required this.manchete});
}

Future<List<News>> _getNews() async {
  final List<News> newsList = [];
  final response = await http.get(Uri.parse('http://localhost:1212/news'));

  if (response.statusCode == 200) {
    final List<dynamic> jsonData = json.decode(response.body);

    for (var data in jsonData) {
      final linkImagem = data['imagem'];
      final regex = RegExp(r'/d/([a-zA-Z0-9_-]+)');
      final match = regex.firstMatch(linkImagem);

      String directImageUrl = '';
      if (match != null && match.groupCount > 0) {
        // Extrai o ID do arquivo e cria o link direto
        final fileId = match.group(1);
        print(fileId);
        directImageUrl = 'https://drive.google.com/uc?export=view&id=$fileId';
      } else {
        print('ID do arquivo não encontrado.');
      }

      News news = News(
        linkImage: directImageUrl,
        manchete: data['manchete'] ?? '',
        linkSite: data['link_'] ?? '',
      );
      newsList.add(news);
    }
  }
  return newsList;
}

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
  int _currentPage = 0;
  late Timer _timer;
  late List<News> _newsList = [];

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
    _fetchNews();
  }

  void _fetchNews() async {
    List<News> newsList = await _getNews();
    setState(() {
      _newsList = newsList;
    });
  }

  void _logout() {
    final store = Modular.get<AuthStore>();
    store.logout();
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
            SizedBox(
              height: 10,
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
                        child: Stack(
                          children: [
                            PageView.builder(
                              controller: _pageController,
                              itemCount: _newsList.length,
                              onPageChanged: (int page) {
                                setState(() {
                                  _currentPage = page;
                                });
                              },
                              itemBuilder: (context, index) {
                                final news = _newsList[index];
                                return InformationPage(
                                  imagePath: news.linkImage,
                                  url: Uri.parse(news.linkSite),
                                  headline: news.manchete,
                                );
                              },
                            ),
                            Positioned(
                              left: 0,
                              right: 0,
                              bottom: 0,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List<Widget>.generate(
                                    _newsList.length, (int index) {
                                  return Container(
                                    width: 10.0,
                                    height: 10.0,
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 4.0),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: _currentPage == index
                                          ? Colors.white
                                          : Colors.grey.shade400,
                                    ),
                                  );
                                }),
                              ),
                            ),
                          ],
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
                            Modular.to.pushNamed('/home/date');
                          },
                          title: 'dia da coleta',
                          icon: 'images/icones.png',
                        ),
                        cardmenu(
                          ontap: () {
                            Modular.to.pushNamed('/home/lixo');
                          },
                          title: 'meu lixo',
                          icon: 'images/caminhaoofc.jpg',
                          color: const Color.fromARGB(255, 255, 255, 255),
                          fontcolor: Colors.grey,
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
                            Modular.to.pushNamed('/home/conta');
                          },
                          title: 'conta',
                          icon: 'images/pessoa.jpg',
                          fontcolor: Colors.grey,
                          color: const Color.fromARGB(255, 255, 255, 255),
                        ),
                        cardmenu(
                          ontap: () {
                            Modular.to.pushNamed('/home/ajuda');
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
