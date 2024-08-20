import 'package:shelf/shelf.dart';
import 'package:shelf_modular/shelf_modular.dart';

import 'src/app_module.dart';

Future<Handler> startShelfModular() async {
  final handler = Modular(module: AppModule(), middlewares: [
    logRequests(),
    jsonResponse(),
    corsMiddleware(), // Certifique-se de que o middleware CORS está antes de outros middlewares que possam alterar a resposta
  ]);
  return handler;
}

Middleware jsonResponse() {
  return (handler) {
    return (request) async {
      var response = await handler(request);

      response = response.change(headers: {
        'Content-Type': 'application/json',
        ...response.headers,
      });

      return response;
    };
  };
}

Middleware corsMiddleware() {
  return (Handler handler) {
    return (Request request) async {
      // Verifica se a solicitação é uma solicitação preflight (OPTIONS)
      if (request.method == 'OPTIONS') {
        return Response.ok(null, headers: {
          'Access-Control-Allow-Origin': '*',
          'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
          'Access-Control-Allow-Headers':
              'Origin, Content-Type, Accept, Authorization',
        });
      }

      // Adiciona os cabeçalhos CORS em todas as outras solicitações
      final response = await handler(request);
      return response.change(headers: {
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
        'Access-Control-Allow-Headers':
            'Origin, Content-Type, Accept, Authorization',
        ...response
            .headers, // Certifique-se de manter os cabeçalhos da resposta original
      });
    };
  };
}
