// ignore_for_file: unused_local_variable

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app_client/src/auth/dto/login_credential.dart';
import 'package:app_client/src/auth/models/tokenization.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:uno/uno.dart';
import '../errors/errors.dart';
import '../states/auth_state.dart';

class AuthStore extends StreamStore<AuthException, AuthState> {
  final Uno uno;
  AuthStore(this.uno) : super(InProcess());

  Future<int> login(LoginCredential credential) async {
    setLoading(true);

    var basic = '${credential.email.value}:${credential.password.value}';
    basic = base64Encode(basic.codeUnits);
    try {
      final response = await uno.get(
        '/auth/login', // URL completa aqui
        headers: {'Authorization': 'Basic $basic'},
      );

      final statusCode = response.status;

      if (statusCode == 200) {
        final tokenization = Tokenization.fromMap(response.data);
        update(Logged(tokenization));

        // Salvando o email nos SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_email', credential.email.value);
      } else {
        setError(AuthException('Erro no login: $statusCode', null));
      }

      return statusCode; // Retorna o código de resposta
    } catch (e, stackTrace) {
      print('Erro durante o login: $e');
      print('StackTrace: $stackTrace');
      setError(AuthException('Erro durante o login: $e', stackTrace));
      return 500; // Retorna 500 em caso de erro
    } finally {
      setLoading(false);
    }
  }

  Future<void> refreshToken() async {
    final state = this.state;
    if (state is Logged) {
      final refreshTokenString = state.tokenization.refreshToken;

      final response = await uno.get('/auth/refresh_token', headers: {
        // Ajuste aqui
        'refreshed_token': '',
        'authorization': 'bearer $refreshTokenString',
      });
      final tokenization = Tokenization.fromMap(response.data);
      update(Logged(tokenization));
    }
  }

  logout() {
    update(Unlogged());
  }
}
