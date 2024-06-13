import 'dart:async';
import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:shelf_modular/shelf_modular.dart';

import '../../core/services/database/remote_database.dart';

class ScoreResource extends Resource {
  @override
  List<Route> get routes => [
        Route.put('/score/update', updateScore),
        Route.get('/score/:email', getScorebyEmail),
        Route.post('/score/create', createScore),
      ];
  FutureOr<Response> getScorebyEmail(
      ModularArguments arguments, Injector injector) async {
    final email = arguments.params['email'];
    final database = injector.get<RemoteDatabase>();
    final result = await database.query(
        'SELECT id_score, qntd_residuos, email, date_ FROM "Score"; WHERE email=@email;',
        variables: {'email': email});
    final scoreMap = result.map((element) => element['Score']).first;
    return Response.ok(jsonEncode(scoreMap));
  }

  FutureOr<Response> updateScore(
      ModularArguments arguments, Injector injector) async {
    final email = arguments.params['email'];
    final database = injector.get<RemoteDatabase>();
    final result = await database.query(
        'SELECT id_score, qntd_residuos, email, date_ FROM "Score"; WHERE email=@email;',
        variables: {'email': email});
    final scoreMap = result.map((element) => element['Score']).first;
    return Response.ok(jsonEncode(scoreMap));
  }

  FutureOr<Response> createScore(
      ModularArguments arguments, Injector injector) async {
    final email = arguments.params['email'];
    final database = injector.get<RemoteDatabase>();
    final result = await database.query(
        'SELECT id_score, qntd_residuos, email, date_ FROM "Score"; WHERE email=@email;',
        variables: {'email': email});
    final scoreMap = result.map((element) => element['Score']).first;
    return Response.ok(jsonEncode(scoreMap));
  }
}
