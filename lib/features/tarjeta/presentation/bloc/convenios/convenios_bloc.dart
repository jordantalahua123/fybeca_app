import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/usecases/usecase.dart';
import '../../../domain/entities/convenio_entity.dart';
import '../../../domain/usecases/get_convenios.dart';

part 'convenios_event.dart';
part 'convenios_state.dart';

class ConveniosBloc extends Bloc<ConveniosEvent, ConveniosState> {
  final GetConvenios getConvenios;

  ConveniosBloc({required this.getConvenios})
    : super(const ConveniosInitial()) {
    on<ConveniosLoadRequested>(_onLoadRequested);
    on<ConvenioSelected>(_onConvenioSelected);
  }

  Future<void> _onLoadRequested(
    ConveniosLoadRequested event,
    Emitter<ConveniosState> emit,
  ) async {
    emit(const ConveniosLoading());
    final result = await getConvenios(const NoParams());
    result.fold((failure) => emit(ConveniosError(failure.message)), (
      convenios,
    ) {
      if (convenios.isEmpty) {
        emit(
          const ConveniosError('No tienes convenios activos por el momento.'),
        );
        return;
      }
      emit(
        ConveniosLoaded(
          convenios: convenios,
          selectedConvenioId: convenios.first.id,
        ),
      );
    });
  }

  void _onConvenioSelected(
    ConvenioSelected event,
    Emitter<ConveniosState> emit,
  ) {
    final current = state;
    if (current is ConveniosLoaded) {
      emit(current.copyWith(selectedConvenioId: event.convenioId));
    }
  }
}
