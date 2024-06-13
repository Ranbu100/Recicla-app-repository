import 'dart:io';

class DotEnvService {
  final Map<String, String> _map = {};

  DotEnvService({Map<String, String>? mocks}) {
    if (mocks == null) {
      _init();
    } else {
      _map.addAll(mocks);
    }
  }

  void _init() {
    _map['DATABASE_URL'] =
        Platform.environment['DATABASE_URL'] ?? 'default_database_url';
    _map['JWT_KEY'] = Platform.environment['JWT_KEY'] ?? 'default_jwt_key';
  }

  String? operator [](String key) {
    return _map[key];
  }
}
