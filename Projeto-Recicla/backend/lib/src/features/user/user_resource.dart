import 'dart:async';
import 'dart:convert';

import 'package:backend/src/core/services/bcrypt/bcrypt_service.dart';
import 'package:backend/src/core/services/database/remote_database.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_modular/shelf_modular.dart';

class UserResource extends Resource {
  @override
  List<Route> get routes => [
        Route.get('/user', _getAllUser),
        Route.get('/user/:id', _getUserByid),
        Route.get('/user/:email', _getUserByemail),
        Route.put('/up/:email', _updateUserByemail),
        Route.get('/user/bairro', _getAllBairro),
        Route.get('/user/bairro/:bairro', _getBairroBybairro),
        Route.post('/user', _createUser),
        Route.put('/user', _updateUser),
        Route.delete('/user/:id', _deleteUser),
      ];

  FutureOr<Response> _getAllUser(Injector injector) async {
    final database = injector.get<RemoteDatabase>();
    final result = await database.query(
        'SELECT usuario_id, nome, email, senha, rua, num_casa, bairro, cep, cpf, cnpj, role FROM "User";');

    final listUsers = result.map((e) => e['User']).toList();

    return Response.ok(jsonEncode(listUsers));
  }

  FutureOr<Response> _getUserByid(
      ModularArguments arguments, Injector injector) async {
    final id = arguments.params['usuario_id'];
    final database = injector.get<RemoteDatabase>();
    final result = await database.query(
        'SELECT usuario_id, nome, email, senha, rua, num_casa, bairro, cep, cpf, cnpj, role FROM "User" WHERE usuario_id=@usuario_id;',
        variables: {'usuario_id': id});
    final userMap = result.map((element) => element['User']).first;
    return Response.ok(jsonEncode(userMap));
  }

  FutureOr<Response> _getUserByemail(
      ModularArguments arguments, Injector injector) async {
    final email = arguments.params['email'];
    final database = injector.get<RemoteDatabase>();
    final result = await database.query(
        'SELECT usuario_id, nome, email, senha, rua, num_casa, bairro, cep, cpf, cnpj, role FROM "User" WHERE email=@email;',
        variables: {'email': email});
    final userMap = result.map((element) => element['User']).first;
    return Response.ok(jsonEncode(userMap));
  }

  FutureOr<Response> _updateUserByemail(
      ModularArguments arguments, Injector injector) async {
    final email = arguments.params['email'];
    final rua = arguments.data['rua'];
    final numCasa = arguments.data['num_casa'];
    final bairro = arguments.data['bairro'];
    final cep = arguments.data['cep'];
    final database = injector.get<RemoteDatabase>();
    final result = await database.query(
        'UPDATE "User" SET rua=@rua, num_casa=@num_casa, bairro=@bairro, cep=@cep WHERE email=@email RETURNING usuario_id, nome, email, rua, num_casa, bairro, cep, cpf, cnpj, role;',
        variables: {
          'rua': rua,
          'num_casa': numCasa,
          'bairro': bairro,
          'cep': cep,
          'email': email,
        });
    final userMap = result.map((element) => element['User']).first;
    return Response.ok(jsonEncode(userMap));
  }

  FutureOr<Response> _getAllBairro(Injector injector) async {
    final database = injector.get<RemoteDatabase>();
    final result = await database.query('SELECT DISTINCT bairro FROM "User";');
    final listBairros = result.map((e) => e['User']).toList();
    return Response.ok(jsonEncode(listBairros));
  }

  FutureOr<Response> _getBairroBybairro(
      ModularArguments arguments, Injector injector) async {
    final bairro = arguments.params['bairro'];
    final database = injector.get<RemoteDatabase>();
    final result = await database.query(
        'SELECT usuario_id, nome, email, senha, rua, num_casa, bairro, cep, cpf, cnpj, role FROM "User" WHERE bairro=@bairro;',
        variables: {'bairro': bairro});
    final userMap = result.map((element) => element['User']).first;
    return Response.ok(jsonEncode(userMap));
  }

  FutureOr<Response> _deleteUser(
      ModularArguments arguments, Injector injector) async {
    final id = arguments.params['usuario_id'];

    final database = injector.get<RemoteDatabase>();
    await database.query('DELETE FROM "User" WHERE usuario_id=@usuario_id;',
        variables: {'usuario_id': id});
    return Response.ok(jsonEncode({'message': 'deleted $id'}));
  }

  FutureOr<Response> _createUser(
      ModularArguments arguments, Injector injector) async {
    final bcrypt = injector.get<BCryptService>();

    final userParams = (arguments.data as Map).cast<String, dynamic>();
    userParams['senha'] = bcrypt.generateHash(userParams['senha']);

    final database = injector.get<RemoteDatabase>();
    final result = await database.query(
      'INSERT INTO "User"(nome, email, telefone, senha, rua, num_casa, bairro, cep, cpf, cnpj, role) VALUES (@nome, @email, @telefone, @senha, @rua, @num_casa, @bairro, @cep, @cpf, @cnpj, @role) RETURNING usuario_id, nome, email, rua, num_casa, bairro, cep, cpf, cnpj, role;',
      variables: userParams,
    );
    final userMap = result.map((element) => element['User']).first;
    return Response.ok(jsonEncode(userMap));
  }

  FutureOr<Response> _updateUser(
      ModularArguments arguments, Injector injector) async {
    final userParams = (arguments.data as Map).cast<String, dynamic>();

    final columns = userParams.keys
        .where((key) => key != 'usuario_id' || key != 'senha')
        .map(
          (key) => '$key=@$key',
        )
        .toList();

    final query =
        'UPDATE "User" SET ${columns.join(',')} WHERE usuario_id = @usuario_id RETURNING usuario_id, nome, email, rua, num_casa, bairro, cep, cpf, cnpj, role;';

    final database = injector.get<RemoteDatabase>();
    final result = await database.query(
      query,
      variables: userParams,
    );
    final userMap = result.map((element) => element['User']).first;
    return Response.ok(jsonEncode(userMap));
  }
}
