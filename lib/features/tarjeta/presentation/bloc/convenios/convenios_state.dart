part of 'convenios_bloc.dart';

abstract class ConveniosState extends Equatable {
  const ConveniosState();

  @override
  List<Object?> get props => [];
}

class ConveniosInitial extends ConveniosState {
  const ConveniosInitial();
}

class ConveniosLoading extends ConveniosState {
  const ConveniosLoading();
}

class ConveniosLoaded extends ConveniosState {
  final List<ConvenioEntity> convenios;
  final String selectedConvenioId;

  const ConveniosLoaded({
    required this.convenios,
    required this.selectedConvenioId,
  });

  double get cupoTotal => convenios.fold(0, (sum, c) => sum + c.cupoDisponible);

  ConvenioEntity get selected =>
      convenios.firstWhere((c) => c.id == selectedConvenioId);

  ConveniosLoaded copyWith({String? selectedConvenioId}) {
    return ConveniosLoaded(
      convenios: convenios,
      selectedConvenioId: selectedConvenioId ?? this.selectedConvenioId,
    );
  }

  @override
  List<Object?> get props => [convenios, selectedConvenioId];
}

class ConveniosError extends ConveniosState {
  final String message;

  const ConveniosError(this.message);

  @override
  List<Object?> get props => [message];
}
