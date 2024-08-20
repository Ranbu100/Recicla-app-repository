import 'dart:async';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_router/shelf_router.dart';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';

Future<Response> _serveGoogleDriveImage(Request request) async {
  // Substitua pelo ID do seu arquivo do Google Drive
  final fileId = '11LdmXRunVds6NELLZFJ0rkTjlkInvMLY';
  final driveUrl = 'https://drive.google.com/uc?export=download&id=$fileId';

  // Fazendo a requisição HTTP para obter a imagem
  final response = await http.get(Uri.parse(driveUrl));

  if (response.statusCode != 200) {
    return Response.notFound('Imagem não encontrada no Google Drive.');
  }

  // Determina o tipo MIME da imagem
  final mimeType = lookupMimeType('', headerBytes: response.bodyBytes) ??
      'application/octet-stream';

  // Retorna a resposta com a imagem e o tipo MIME correto
  return Response.ok(response.bodyBytes, headers: {
    'Content-Type': mimeType,
  });
}

void main() async {
  final router = Router();

  // Rota para servir a imagem
  router.get('/imagem', _serveGoogleDriveImage);

  final handler =
      const Pipeline().addMiddleware(logRequests()).addHandler(router);

  // Inicia o servidor
  final server = await io.serve(handler, 'localhost', 8080);
  print('Servidor rodando em http://${server.address.host}:${server.port}');
}
