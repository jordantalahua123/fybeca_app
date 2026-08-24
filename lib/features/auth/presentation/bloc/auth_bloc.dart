import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/get_current_user.dart';
import '../../domain/usecases/login_with_email.dart';
import '../../domain/usecases/login_with_google.dart';
import '../../domain/usecases/login_with_microsoft.dart';
import '../../domain/usecases/logout.dart';

part 'auth_event.dart';
part 'auth_state.dart';

/// Único punto de entrada de la UI a la lógica de autenticación.
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginWithEmail loginWithEmail;
  final LoginWithGoogle loginWithGoogle;
  final LoginWithMicrosoft loginWithMicrosoft;
  final GetCurrentUser getCurrentUser;
  final Logout logout;

  AuthBloc({
    required this.loginWithEmail,
    required this.loginWithGoogle,
    required this.loginWithMicrosoft,
    required this.getCurrentUser,
    required this.logout,
  }) : super(const AuthInitial()) {
    on<AuthCheckRequested>(_onCheckRequested);
    on<AuthLoginWithEmailRequested>(_onLoginWithEmail);
    on<AuthLoginWithGoogleRequested>(_onLoginWithGoogle);
    on<AuthLoginWithMicrosoftRequested>(_onLoginWithMicrosoft);
    on<AuthLogoutRequested>(_onLogout);
  }

  Future<void> _onCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthSessionChecking());
    final result = await getCurrentUser(const NoParams());
    result.fold(
      (failure) => emit(const AuthUnauthenticated()),
      (user) => emit(AuthAuthenticated(user)),
    );
  }

  Future<void> _onLoginWithEmail(
    AuthLoginWithEmailRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    final result = await loginWithEmail(
      LoginWithEmailParams(email: event.email, password: event.password),
    );
    _emitAuthResult(result, emit);
  }

  Future<void> _onLoginWithGoogle(
    AuthLoginWithGoogleRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    final result = await loginWithGoogle(const NoParams());
    _emitAuthResult(result, emit);
  }

  Future<void> _onLoginWithMicrosoft(
    AuthLoginWithMicrosoftRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    final result = await loginWithMicrosoft(const NoParams());
    _emitAuthResult(result, emit);
  }

  Future<void> _onLogout(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    await logout(const NoParams());
    emit(const AuthUnauthenticated());
  }

  void _emitAuthResult(
    Either<Failure, UserEntity> result,
    Emitter<AuthState> emit,
  ) {
    result.fold(
      (failure) => emit(AuthFailureState(failure.message)),
      (user) => emit(AuthAuthenticated(user)),
    );
  }
}
