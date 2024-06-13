import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../../../auth/stores/auth_store.dart';
import '../../models/product.dart';

class HelpPage extends StatefulWidget {
  const HelpPage({Key? key}) : super(key: key);

  @override
  State<HelpPage> createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  final List<Product> _products = Product.generateItems(3);
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _openDrawer() {
    _scaffoldKey.currentState?.openDrawer();
  }

  void _logout() {
    final store = Modular.get<AuthStore>();
    store.logout(); // Chamar método de logout no AuthStore
  }

  // Mapa que associa cada ID a um texto de pergunta específico
  final Map<int, String> questionMap = {
    1: 'Reciclagem é o processo de transformação de materiais considerados lixo em novos produtos, reduzindo o consumo de recursos naturais e a quantidade de resíduos enviados para aterros sanitários.',
    2: 'A reciclagem ajuda a reduzir a poluição, conserva os recursos naturais, economiza energia, diminui a quantidade de resíduos enviados para aterros sanitários e contribui para a geração de empregos na indústria recicladora.',
    3: 'Materiais como papel, plástico, vidro, metal e alguns tipos de tecido podem ser reciclados, desde que separados corretamente e encaminhados para os locais de coleta seletiva.',
  };
  final Map<int, String> descriptionMap = {
    1: 'O que é reciclagem?',
    2: 'Quais são os benefícios da reciclagem?',
    3: 'Quais materiais podem ser reciclados?',
  };
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
          'Ajuda',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
          ),
          onPressed: () {
            Modular.to.navigate('/home');
          },
        ),
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
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/fundojuda.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: ExpansionPanelList.radio(
                expansionCallback: (int index, bool isExpanded) {
                  setState(() => _products[index].isExpanded = !isExpanded);
                },
                children: _products.map<ExpansionPanel>((Product product) {
                  return ExpansionPanelRadio(
                    // isExpanded: product.isExpanded,
                    value: product.id,
                    canTapOnHeader: true,
                    headerBuilder: (BuildContext context, bool isExpanded) {
                      return ListTile(
                        leading:
                            CircleAvatar(child: Text(product.id.toString())),
                        title: Text(product.title),
                      );
                    },
                    body: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: Text(
                            descriptionMap[product.id] ?? '',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        // Acessa o mapa para obter o texto da pergunta com base no ID
                        Text(
                          questionMap[product.id] ?? '',
                          textAlign: TextAlign.justify,
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
