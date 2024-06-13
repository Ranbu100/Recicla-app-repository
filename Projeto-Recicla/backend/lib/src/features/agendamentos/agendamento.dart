import 'dart:async';
import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:shelf_modular/shelf_modular.dart';

import '../../core/services/database/remote_database.dart';

class AgendamentosResource extends Resource {
  @override
  List<Route> get routes =>
      [Route.get('/ag', getAg), Route.post('/ag/new', createAg)];
  FutureOr<Response> getAg(
      Injector injector, ModularArguments arguments) async {
    final database = injector.get<RemoteDatabase>();
    final result = await database.query(
      'SELECT ag.id_agendamento, ag.data_agendamento, ag.horario, ag.status, ag.tipo_residuo, ag.quantidade_residuo, ag.usuario_id, u.rua, u.bairro, u.cep, u.num_casa, u.usuario_id FROM "Agendamentos" as ag inner join "User" as u on u.usuario_id=ag.usuario_id ;',
    );

    final listAg = result.map((e) => e['Agendamentos']).toList();
    return Response.ok(jsonEncode(listAg));
  }

  FutureOr<Response> createAg(
      ModularArguments arguments, Injector injector) async {
    final agParams = (arguments.data as Map).cast<String, dynamic>();
    final database = injector.get<RemoteDatabase>();
    final result = await database.query(
      'INSERT INTO "Agendamentos" (data_agendamento, horario, status, tipo_residuo, quantidade_residuo, usuario_id) VALUES  (@data_agendamento, @horario, @status, @tipo_residuo, @quantidade_residuo, @usuario_id) RETURNING id_agendamento, data_agendamento, horario, status, tipo_residuo, quantidade_residuo, usuario_id;',
      variables: agParams,
    );
    final agMap = result.map((element) => element['Agendamentos']).first;
    return Response.ok(jsonEncode(agMap));
  }
}
