import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'dto/login_credential.dart';
import 'stores/auth_store.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isObscured = true;

  final credential = LoginCredential();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final store = Modular.get<AuthStore>();

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/7.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(50.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 60),
              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                onChanged: credential.setEmail,
                validator: (value) => credential.email.validate(),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  labelText: 'Email',
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                onChanged: credential.setPassword,
                validator: (value) => credential.password.validate(),
                obscureText: isObscured,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  labelText: 'Password',
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        isObscured = !isObscured;
                      });
                    },
                    icon: Icon(
                      isObscured ? Icons.visibility_off : Icons.visibility,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () async {
                  final validate = credential.validate();
                  if (validate == null) {
                    final statusCode = await store.login(credential);
                    if (statusCode == 200) {
                      _showSuccessSnackbar();
                    } else {
                      _showErrorSnackbar('Erro no login');
                    }
                  } else {
                    _showErrorSnackbar(validate);
                  }
                },
                child: const Text('Entrar',
                    style: TextStyle(
                      color: Colors.green,
                    )),
              ),
            ],
          ),
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
        content: Text('Login bem-sucedido!'),
        backgroundColor: Colors.green,
      ),
    );
  }
}
