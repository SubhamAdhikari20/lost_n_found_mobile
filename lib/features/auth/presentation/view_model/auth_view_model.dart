import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lost_n_found/features/auth/domain/usecases/login_usecase.dart';
import 'package:lost_n_found/features/auth/domain/usecases/logout_usecase.dart';
import 'package:lost_n_found/features/auth/domain/usecases/sign_up_usecase.dart';
import 'package:lost_n_found/features/auth/presentation/state/auth_state.dart';

// Auth View Model Notifier Provider
final authViewModelProvider = NotifierProvider<AuthViewModel, AuthState>(() {
  return AuthViewModel();
});

class AuthViewModel extends Notifier<AuthState> {
  late final SignUpUsecase _signUpUsecase;
  late final LoginUsecase _loginUsecase;
  late final LogoutUsecase _logoutUsecase;

  @override
  AuthState build() {
    // Initialize
    _signUpUsecase = ref.read(signUpUsecaseProvider);
    _loginUsecase = ref.read(loginUsecaseProvider);
    _logoutUsecase = ref.read(logoutUsecaseProvider);
    return AuthState();
  }

  Future<void> signUp({
    required String email,
    required String username,
    required String fullName,
    String? phoneNumber,
    String? password,
    String? batchId,
  }) async {
    state = state.copywith(authStatus: AuthStatus.loading);
    final signUpParams = SignUpUsecaseParams(
      fullName: fullName,
      email: email,
      username: username,
      phoneNumber: phoneNumber,
      password: password,
      batchId: batchId,
    );

    // Wait for few seconds
    await Future.delayed(Duration(seconds: 3));
    final result = await _signUpUsecase(signUpParams);

    result.fold(
      (failure) {
        state = state.copywith(
          authStatus: AuthStatus.error,
          errorMessage: failure.message,
        );
      },
      (user) {
        state = state.copywith(authStatus: AuthStatus.created);
      },
    );
  }

  Future<void> login({required String email, required String password}) async {
    state = state.copywith(authStatus: AuthStatus.loading);
    final loginParams = LoginUsecaseParams(email: email, password: password);

    // Wait for few seconds
    await Future.delayed(Duration(seconds: 3));
    final result = await _loginUsecase(loginParams);

    result.fold(
      (failure) {
        state = state.copywith(
          authStatus: AuthStatus.error,
          errorMessage: failure.message,
        );
      },
      (buyer) {
        state = state.copywith(authStatus: AuthStatus.authenticated);
      },
    );
  }

  Future<void> logout() async {
    state = state.copywith(authStatus: AuthStatus.loading);

    // Wait for few seconds
    await Future.delayed(Duration(seconds: 2));
    final result = await _logoutUsecase();

    result.fold(
      (failure) {
        state = state.copywith(
          authStatus: AuthStatus.error,
          errorMessage: failure.message,
        );
      },
      (isLoggedOut) {
        state = state.copywith(authStatus: AuthStatus.unauthenticated);
      },
    );
  }
}
