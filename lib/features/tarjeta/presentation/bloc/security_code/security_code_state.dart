part of 'security_code_bloc.dart';

abstract class SecurityCodeState extends Equatable {
  const SecurityCodeState();

  @override
  List<Object?> get props => [];
}

class SecurityCodeInitial extends SecurityCodeState {
  const SecurityCodeInitial();
}

class SecurityCodeLoading extends SecurityCodeState {
  const SecurityCodeLoading();
}

class SecurityCodeActive extends SecurityCodeState {
  final SecurityCodeEntity code;
  final Duration remaining;

  const SecurityCodeActive({required this.code, required this.remaining});

  @override
  List<Object?> get props => [code, remaining];
}

class SecurityCodeExpired extends SecurityCodeState {
  final String convenioId;

  const SecurityCodeExpired(this.convenioId);

  @override
  List<Object?> get props => [convenioId];
}

class SecurityCodeUsed extends SecurityCodeState {
  final String convenioId;

  const SecurityCodeUsed(this.convenioId);

  @override
  List<Object?> get props => [convenioId];
}

class SecurityCodeError extends SecurityCodeState {
  final String message;

  const SecurityCodeError(this.message);

  @override
  List<Object?> get props => [message];
}
