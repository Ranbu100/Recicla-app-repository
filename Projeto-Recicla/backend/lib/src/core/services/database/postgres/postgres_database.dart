import 'dart:async';
import 'package:backend/src/core/services/database/remote_database.dart';
import 'package:backend/src/core/services/dot_env/dot_env_service.dart';
import 'package:postgres/postgres.dart';
import 'package:shelf_modular/shelf_modular.dart';

class PostgresDatabase implements RemoteDatabase, Disposable {
  final completer = Completer<PostgreSQLConnection>();
  final DotEnvService dotEnv;

  PostgresDatabase(this.dotEnv) {
    _init();
  }

  _init() async {
    final url = dotEnv['DATABASE_URL']!;
    final uri = Uri.parse(url);

    var connection = PostgreSQLConnection(
      'localhost',
      5432,
      'postgres',
      username: 'postgres',
      password: 'qwe123',
    );

    try {
      await connection.open();
      completer.complete(connection);
      print('Conexão com o banco de dados estabelecida com sucesso.');
    } catch (e) {
      print('Erro ao conectar ao banco de dados: $e');
      completer.completeError(e);
    }
  }

  @override
  Future<List<Map<String, Map<String, dynamic>>>> query(
    String queryText, {
    Map<String, dynamic> variables = const {},
  }) async {
    final connection = await completer.future;
    return await connection.mappedResultsQuery(
      queryText,
      substitutionValues: variables,
    );
  }

  @override
  void dispose() async {
    final connection = await completer.future;
    await connection.close();
  }
}
