import 'package:backend/backend.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'dart:io';

void main(List<String> arguments) async {
  final handler = await startShelfModular();

  // Verifica todas as interfaces de rede para encontrar uma associada ao IP desejado
  var serverAddress = await _findIPv4Address('192.168.21.79');

  if (serverAddress == null) {
    print(
        'Endereço IP $serverAddress não encontrado na lista de interfaces de rede.');
    return;
  }

  // Inicia o servidor Shelf no endereço IP e porta específicos
  final server = await io.serve(handler, serverAddress, 4466);

  print('Server online - ${server.address.address}:${server.port}');
}

Future<InternetAddress?> _findIPv4Address(String ipAddress) async {
  try {
    // Lista todas as interfaces de rede
    List<NetworkInterface> interfaces = await NetworkInterface.list();

    // Procura por uma interface que tenha o endereço IP desejado
    for (var interface in interfaces) {
      for (var addr in interface.addresses) {
        if (addr.type == InternetAddressType.IPv4 &&
            addr.address == ipAddress) {
          return addr; // Retorna o endereço IP se encontrado
        }
      }
    }
  } catch (e) {
    print('Erro ao encontrar endereço IP: $e');
  }

  return null;
}
