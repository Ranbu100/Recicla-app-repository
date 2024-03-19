import 'dart:async';
import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:shelf_modular/shelf_modular.dart';

import '../../core/services/database/remote_database.dart';

class NewsResource extends Resource {
  @override
  List<Route> get routes => [
        Route.put('news/image', newImage),
      ];
}

FutureOr<Response> newImage(Injector injector) async {
  String link = "";
  final database = injector.get<RemoteDatabase>();
  final result = await database.query(
      'UPDATE "Noticias" SET link=@link, imagem=@imagem, manchete=@manchete WHERE noticia_id=@noticia_id;',
      variables: {'link': link});
  final newsMap = result.map((element) => element['Noticias']).first;
  return Response.ok(jsonEncode(newsMap));
}
