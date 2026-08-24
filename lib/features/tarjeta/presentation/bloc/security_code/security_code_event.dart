part of 'security_code_bloc.dart';

abstract class SecurityCodeEvent extends Equatable {
  const SecurityCodeEvent();

  @override
  List<Object?> get props => [];
}

class SecurityCodeGenerateRequested extends SecurityCodeEvent {
  final String convenioId;

  const SecurityCodeGenerateRequested(this.convenioId);

  @override
  List<Object?> get props => [convenioId];
}

/// Interno: lo dispara el timer cada segundo mientras el código está vigente.
class SecurityCodeTicked extends SecurityCodeEvent {
  const SecurityCodeTicked();
}

class SecurityCodeSimulateUsoRequested extends SecurityCodeEvent {
  const SecurityCodeSimulateUsoRequested();
}
