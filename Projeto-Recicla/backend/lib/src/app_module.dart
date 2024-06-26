import 'package:shelf/shelf.dart';
import 'package:shelf_modular/shelf_modular.dart';

import 'core/core_module.dart';
import 'features/agendamentos/agendamento.dart';
import 'features/auth/auth_module.dart';
import 'features/news/news.dart';
import 'features/swagger/swagger_handler.dart';
import 'features/user/user_resource.dart';

class AppModule extends Module {
  @override
  List<Module> get imports => [
        CoreModule(),
      ];

  @override
  List<ModularRoute> get routes => [
        Route.get('/', (Request request) => Response.ok('Inicial')),
        Route.get('/doc/**', swaggerHandler),
        Route.resource(UserResource()),
        Route.resource(NewsResource()),
        Route.resource(AgendamentosResource()),
        Route.module('/auth', module: AuthModule()),
      ];
}
