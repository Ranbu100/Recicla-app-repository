// // ignore_for_file: await_only_futures

// import 'dart:async';

// import 'package:backend/src/core/services/database/remote_database.dart';
// import 'package:postgres/postgres.dart';
// import 'package:shelf_modular/shelf_modular.dart';

// class PostgreDatabase implements RemoteDatabase, Disposable {
//   final completer = Completer<Connection>();
  
//   PostgreDatabase(){
//     _init();
//   }

//   _init() async {
//     final conn = await Connection.open(Endpoint(
//       host: 'localhost',
//       database: 'postgres',
//       username: 'user',
//       password: 'pass',
//     ));
//     completer.complete(conn);
//   }

//   @override
//   Future<List<List<Map<String, Map<String, dynamic>>>>> query(
//     String queryText, {
//     Map<String, dynamic> substitutionValues = const {},
//   }) async {
//     final connection = await completer.future;

//     return connection.mappedResultsQuery(
//       queryText,
//       substitutionValues
//     );
//   }

//   @override
//   void dispose() async {
//     final connection = await completer.future;
//     connection.close();
//   }
// }
