part of 'convenios_bloc.dart';

abstract class ConveniosEvent extends Equatable {
  const ConveniosEvent();

  @override
  List<Object?> get props => [];
}

class ConveniosLoadRequested extends ConveniosEvent {
  const ConveniosLoadRequested();
}

class ConvenioSelected extends ConveniosEvent {
  final String convenioId;

  const ConvenioSelected(this.convenioId);

  @override
  List<Object?> get props => [convenioId];
}
