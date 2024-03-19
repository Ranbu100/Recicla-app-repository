import '../models/tokenization.dart';

abstract class AuthState {}

class InProcess extends AuthState {}

class Logged extends AuthState {
  final Tokenization tokenization;

  Logged(this.tokenization);
}

class Unlogged extends AuthState {}
