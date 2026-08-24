import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/security_code_entity.dart';
import '../../../domain/usecases/generate_security_code.dart';
import '../../../domain/usecases/simulate_uso_en_caja.dart';

part 'security_code_event.dart';
part 'security_code_state.dart';

/// Un código dura 5 minutos y se descuenta segundo a segundo. Se crea una
/// instancia nueva de este BLoC por cada visita a la pantalla de código.
class SecurityCodeBloc extends Bloc<SecurityCodeEvent, SecurityCodeState> {
  final GenerateSecurityCode generateSecurityCode;
  final SimulateUsoEnCaja simulateUsoEnCaja;

  Timer? _ticker;

  SecurityCodeBloc({
    required this.generateSecurityCode,
    required this.simulateUsoEnCaja,
  }) : super(const SecurityCodeInitial()) {
    on<SecurityCodeGenerateRequested>(_onGenerateRequested);
    on<SecurityCodeTicked>(_onTicked);
    on<SecurityCodeSimulateUsoRequested>(_onSimulateUso);
  }

  Future<void> _onGenerateRequested(
    SecurityCodeGenerateRequested event,
    Emitter<SecurityCodeState> emit,
  ) async {
    _ticker?.cancel();
    emit(const SecurityCodeLoading());
    final result = await generateSecurityCode(event.convenioId);
    result.fold((failure) => emit(SecurityCodeError(failure.message)), (code) {
      emit(
        SecurityCodeActive(
          code: code,
          remaining: code.remaining(DateTime.now()),
        ),
      );
      _startTicker();
    });
  }

  void _onTicked(SecurityCodeTicked event, Emitter<SecurityCodeState> emit) {
    final current = state;
    if (current is! SecurityCodeActive) return;

    final remaining = current.code.remaining(DateTime.now());
    if (remaining == Duration.zero) {
      _ticker?.cancel();
      emit(SecurityCodeExpired(current.code.convenioId));
      return;
    }
    emit(SecurityCodeActive(code: current.code, remaining: remaining));
  }

  Future<void> _onSimulateUso(
    SecurityCodeSimulateUsoRequested event,
    Emitter<SecurityCodeState> emit,
  ) async {
    final current = state;
    if (current is! SecurityCodeActive) return;

    final result = await simulateUsoEnCaja(current.code.code);
    result.fold((failure) => emit(SecurityCodeError(failure.message)), (_) {
      _ticker?.cancel();
      emit(SecurityCodeUsed(current.code.convenioId));
    });
  }

  void _startTicker() {
    _ticker = Timer.periodic(
      const Duration(seconds: 1),
      (_) => add(const SecurityCodeTicked()),
    );
  }

  @override
  Future<void> close() {
    _ticker?.cancel();
    return super.close();
  }
}
