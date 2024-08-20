import 'package:app_client/src/auth/login_page.dart';
import 'package:app_client/src/home/pages/scorepage/scorepage.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:modular_triple_bind/modular_triple_bind.dart';
import 'package:uno/uno.dart';
import 'package:app_client/src/home/pages/homepage/homepage.dart';
import 'package:app_client/src/resgistration/cadastro_page.dart';
import 'package:app_client/src/onboarding/onboarding_screen.dart';
import 'package:app_client/src/transition/tela_transicao.dart';
import 'auth/interceptors/interceptors.dart';
import 'auth/stores/auth_store.dart';
import 'home/pages/agendamentos/telaformulario.dart';
import 'home/pages/ajuda/ajuda.dart';
import 'home/pages/agendamentos/calendario.dart';
import 'home/pages/conta/myaccount.dart';

class AppModule extends Module {
  @override
  List<Bind<Object>> get binds => [
        Bind.singleton((i) {
          final uno = Uno(baseURL: 'http://localhost:1212');
          uno.interceptors.request.use(addToken);
          uno.interceptors.response.use(
            (response) => response,
            onError: tryRefreshToken,
          );
          return uno;
        }),
        TripleBind.singleton((i) => AuthStore(i())),
      ];

  @override
  List<ModularRoute> get routes => [
        ChildRoute('/auth/login', child: (_, __) => const LoginPage()),
        ChildRoute('/home', child: (_, __) => const HomePage()),
        ChildRoute('/user', child: (_, __) => const RegistrationPage()),
        ChildRoute('/on', child: (_, __) => const OnboardingScreen()),
        ChildRoute('/on/t', child: (_, __) => const TransitionPage()),
        ChildRoute('/home/ajuda', child: (_, __) => const HelpPage()),
        ChildRoute('/home/lixo', child: (_, __) => const ScorePage()),
        ChildRoute('/home/date', child: (_, __) => const CalendarPage()),
        ChildRoute('/home/date/ag', child: (_, __) => const TelaFormulario()),
        ChildRoute('/home/conta', child: (_, __) => const MinhaContaScreen()),
      ];
}
