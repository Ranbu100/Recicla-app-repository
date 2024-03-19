import 'dart:convert';

import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'model_cadastro.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({Key? key}) : super(key: key);

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage>
    with SingleTickerProviderStateMixin {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController cpfController = TextEditingController();
  final TextEditingController ruaController = TextEditingController();
  final TextEditingController numcasaController = TextEditingController();
  final TextEditingController cepController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();

  final TextEditingController empresaController = TextEditingController();
  final TextEditingController cnpjController = TextEditingController();
  final TextEditingController enderecoController = TextEditingController();
  final TextEditingController emailempresaController = TextEditingController();

  Future<void> _registerUser(BuildContext context) async {
    try {
      String apiUrl = 'http://localhost:4466/user';

      User user = User(
        nome: nomeController.text,
        email: emailController.text,
        senha: senhaController.text,
        rua: ruaController.text,
        numCasa: numcasaController.text,
        bairro: selectedBairro ?? 'Bairro não selecionado',
        cep: cepController.text,
        cpf: cpfController.text,
        cnpj: null,
        role: 'user',
      );

      User enterprise = User(
        nome: nomeController.text,
        email: emailController.text,
        senha: senhaController.text,
        rua: ruaController.text,
        numCasa: numcasaController.text,
        bairro: selectedBairro ?? 'Bairro não selecionado',
        cep: cepController.text,
        cpf: null,
        cnpj: cnpjController.text,
        role: 'enterprise',
      );

      final dados = currentTabIndex == 0 ? user : enterprise;
      final response = await http.post(
        Uri.parse(apiUrl),
        body: jsonEncode(dados.toJson()),
      );

      if (response.statusCode == 200) {
        // Cadastro bem-sucedido
        _showSuccessSnackbar();
        Modular.to.navigate('/auth/login');
      } else if (response.statusCode == 400) {
        // E-mail já cadastrado
        setState(() {
          mensagemErro = 'E-mail já cadastrado.';
        });
        _showErrorSnackbar('E-mail já cadastrado.');
      } else {
        // Erro desconhecido
        setState(() {
          mensagemErro = 'Erro ao cadastrar usuário.';
        });
        _showErrorSnackbar('Erro ao cadastrar usuário.');
      }
    } catch (error) {
      print('Erro ao cadastrar usuário: $error');
      setState(() {
        mensagemErro = 'Erro interno do aplicativo.';
      });
      _showErrorSnackbar('Erro interno do aplicativo.');
    }
  }

  String mensagemErro = '';
  int currentTabIndex = 0;

  final List<String> bairros = [
    'Bairro 1',
    'Bairro 2',
    'Bairro 3',
    'Bairro 4',
  ];

  String? selectedBairro;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: currentTabIndex,
    ); // Crie o TabController aqui

    _tabController.addListener(() {
      setState(() {
        currentTabIndex = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: currentTabIndex,
      child: Scaffold(
        body: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                "6.png",
                fit: BoxFit.cover,
              ),
            ),
            Column(
              children: [
                const SizedBox(
                  height: 230,
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: TabBar(
                    controller: _tabController,
                    tabs: [
                      const Tab(
                        icon: Icon(
                          Icons.person,
                          color: Colors.green,
                        ),
                      ),
                      const Tab(
                        icon: Icon(
                          Icons.business,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildCadastroPessoa(),
                      _buildCadastroEmpresa(),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              top: 0,
              left: 0,
              child: IconButton(
                color: Colors.white,
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Modular.to.navigate('/on/t');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCadastroPessoa() {
    return SingleChildScrollView(
      child: ListView(
        shrinkWrap: true,
        children: [
          Padding(
            padding:
                const EdgeInsets.only(bottom: 10, left: 40, right: 40, top: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTextField(emailController, "Email", Icons.email),
                const SizedBox(height: 5),
                _buildTextField(
                    nomeController, "Nome Completo", Icons.account_box),
                const SizedBox(height: 5),
                _buildNumericCpfTextField(
                    cpfController, "CPF (Somente números)", Icons.person),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Expanded(
                      flex: 5,
                      child: _buildTextField(
                          ruaController, "Rua", Icons.maps_home_work),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 1,
                      child: _buildTextNumCasaField(numcasaController, "Nº"),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                _buildCEPTextField(
                    cepController, "CEP (Somente números)", Icons.co_present),
                const SizedBox(height: 5),
                _buildBairroDropdown("Bairro"),
                const SizedBox(height: 5),
                _buildPasswordTextField(senhaController, "Senha"),
                const SizedBox(height: 15),
                _buildRegisterButton(),
                const SizedBox(
                  height: 250,
                ),
                Text(
                  mensagemErro,
                  style: const TextStyle(
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCadastroEmpresa() {
    return ListView(
      children: [
        Padding(
          padding:
              const EdgeInsets.only(bottom: 10, left: 40, right: 40, top: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField(
                  emailempresaController, "Email da Empresa", Icons.email),
              const SizedBox(height: 5),
              _buildTextField(
                  empresaController, "Nome da Empresa", Icons.business),
              const SizedBox(height: 5),
              _buildNumericCnpjTextField(
                  cnpjController, "CNPJ", Icons.business),
              const SizedBox(height: 5),
              Row(
                children: [
                  Expanded(
                    flex: 5,
                    child: _buildTextField(
                        ruaController, "Rua", Icons.maps_home_work),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 1,
                    child: _buildTextNumCasaField(numcasaController, "Nº"),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              _buildCEPTextField(
                  cepController, "CEP (Somente números)", Icons.co_present),
              const SizedBox(height: 5),
              _buildBairroDropdown("Selecione o Bairro"),
              const SizedBox(height: 5),
              _buildPasswordTextField(senhaController, "Senha"),
              const SizedBox(height: 15),
              _buildRegisterButton(),
              const SizedBox(
                height: 250,
              ),
              Text(
                mensagemErro,
                style: const TextStyle(
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String label, IconData icon) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        suffixIcon: Icon(
          icon,
          color: Colors.grey.withOpacity(0.5),
        ),
      ),
    );
  }

  Widget _buildTextNumCasaField(
      TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }

  Widget _buildCEPTextField(
      TextEditingController controller, String label, IconData icon) {
    return TextFormField(
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        CepInputFormatter(),
      ],
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        suffixIcon: Icon(
          icon,
          color: Colors.grey.withOpacity(0.5),
        ),
      ),
    );
  }

  Widget _buildNumericCpfTextField(
      TextEditingController controller, String label, IconData icon) {
    return TextFormField(
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        CpfInputFormatter(),
      ],
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        suffixIcon: Icon(
          icon,
          color: Colors.grey.withOpacity(0.5),
        ),
      ),
    );
  }

  Widget _buildNumericCnpjTextField(
      TextEditingController controller, String label, IconData icon) {
    return TextFormField(
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        CnpjInputFormatter(),
      ],
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        suffixIcon: Icon(
          icon,
          color: Colors.grey.withOpacity(0.5),
        ),
      ),
    );
  }

  Widget _buildPasswordTextField(
      TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      obscureText: true,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        suffixIcon: Icon(
          Icons.lock_rounded,
          color: Colors.grey.withOpacity(0.5),
        ),
      ),
    );
  }

  Widget _buildBairroDropdown(String label) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey,
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Column(
          children: <Widget>[
            Text(label),
            DropdownButton<String>(
              value: selectedBairro,
              isExpanded: true,
              items: bairros.map((String bairro) {
                return DropdownMenuItem<String>(
                  value: bairro,
                  child: Text(bairro),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedBairro = newValue;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showErrorSnackbar(String errorMessage) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(errorMessage),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _showSuccessSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Cadastro realizado com sucesso!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void __registerUser(BuildContext context) {
    Modular.to.navigate('/auth/login');
  }

  Widget _buildRegisterButton() {
    return Align(
      alignment: Alignment.center,
      child: ElevatedButton(
        onPressed: () {
          String cpf = cpfController.text;
          String cnpj = cnpjController.text;
          if (GetUtils.isCpf(cpf) || GetUtils.isCnpj(cnpj)) {
            _registerUser(context);
          }
        },
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          backgroundColor: Colors.green,
        ),
        child: Container(
          width: 100,
          height: 30,
          alignment: Alignment.center,
          child: const Text(
            'Cadastrar',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
