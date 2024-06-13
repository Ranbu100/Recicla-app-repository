import 'dart:async';
import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:shelf_modular/shelf_modular.dart';

import '../../core/services/database/remote_database.dart';

class NewsResource extends Resource {
  @override
  List<Route> get routes => [
        Route.put('/news/image', newImage),
        Route.get('/news', getImage),
      ];
  FutureOr<Response> newImage(
      ModularArguments arguments, Injector injector) async {
    final newsParams = (arguments.data as Map).cast<String, dynamic>();

    final columns = newsParams.keys
        .where((key) => key != 'noticia_id')
        .map(
          (key) => '$key=@$key',
        )
        .toList();

    final query =
        'UPDATE "Noticias" SET ${columns.join(',')} WHERE noticia_id = @noticia_id RETURNING noticia_id, link_, imagem, manchete;';

    final database = injector.get<RemoteDatabase>();
    final result = await database.query(
      query,
      variables: newsParams,
    );

    if (result.isNotEmpty) {
      final newsMap = result.map((element) => element['Noticias']).first;
      return Response.ok(jsonEncode(newsMap));
    } else {
      return Response.notFound(
          jsonEncode({'error': 'O id procurado não existe'}));
    }
  }

  FutureOr<Response> getImage(Injector injector) async {
    final database = injector.get<RemoteDatabase>();
    final result = await database
        .query('SELECT noticia_id, link_, imagem, manchete FROM "Noticias";');

    final listNews = result.map((e) => e['Noticias']).toList();
    return Response.ok(jsonEncode(listNews));
  }
}
