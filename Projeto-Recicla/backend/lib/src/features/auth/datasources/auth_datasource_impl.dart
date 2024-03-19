import 'package:backend/src/core/services/database/remote_database.dart';
import 'package:backend/src/features/auth/repositories/auth_repository.dart';

class AuthDatasourceImpl implements AuthDatasource {
  final RemoteDatabase database;

  AuthDatasourceImpl(this.database);

  @override
  Future<Map> getIdAndRoleByEmail(String email) async {
    final result = await database.query(
      'SELECT usuario_id, role, senha FROM "User" WHERE email = @email;',
      variables: {
        'email': email,
      },
    );

    if (result.isEmpty) {
      return {};
    }

    return result.map((element) => element['User']).first!;
  }

  @override
  Future<String> getRoleById(id) async {
    final result = await database.query(
      'SELECT role FROM "User" WHERE usuario_id = @usuario_id;',
      variables: {
        'usuario_id': id,
      },
    );

    return result.map((element) => element['User']).first!['role'];
  }

  @override
  Future<String> getPasswordById(id) async {
    final result = await database.query(
      'SELECT senha FROM "User" WHERE usuario_id = @usuario_id;',
      variables: {
        'usuario_id': id,
      },
    );
    return result.map((element) => element['User']).first!['senha'];
  }

  @override
  Future<void> updatePasswordById(id, String password) async {
    final queryUpdate =
        'UPDATE "User" SET senha=@senha WHERE usuario_id=@usuario_id;';

    await database.query(queryUpdate, variables: {
      'usuario_id': id,
      'senha': password,
    });
  }
}
