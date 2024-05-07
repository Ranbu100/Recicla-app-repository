import 'package:app_client/src/auth/states/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'auth/stores/auth_store.dart';

class AppWidget extends StatefulWidget {
  const AppWidget({Key? key}) : super(key: key);

  @override
  State<AppWidget> createState() => _AppWidgetState();
}

class _AppWidgetState extends State<AppWidget> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    final store = context.read<AuthStore>();

    store.observer(onState: (state) {
      if (state is Logged) {
        // home
        Modular.to.navigate('/home');
      } else if (state is Unlogged) {
        // auth
        Modular.to.navigate('/on/t');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Modular.setInitialRoute('/on');

    return MaterialApp.router(
      title: 'Recicla',
      theme: ThemeData(
        primarySwatch: Colors.lightGreen,
      ),
      routeInformationParser: Modular.routeInformationParser,
      routerDelegate: Modular.routerDelegate,
    );
  }
}
