import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lost_n_found/core/error/failures.dart';
import 'package:lost_n_found/core/usecases/app_usecase.dart';
import 'package:lost_n_found/features/auth/data/repositories/auth_repository.dart';
import 'package:lost_n_found/features/auth/domain/entities/user_entity.dart';
import 'package:lost_n_found/features/auth/domain/repositories/auth_repository.dart';

// Login Params
class LoginUsecaseParams extends Equatable {
  final String identifier;
  final String password;

  const LoginUsecaseParams({required this.identifier, required this.password});
  @override
  List<Object?> get props => [identifier, password];
}

// Provider for Login Usecase
final loginUsecaseProvider = Provider<LoginUsecase>((ref) {
  final authRepository = ref.read(authRepositoryProvider);
  return LoginUsecase(authRepository: authRepository);
});

class LoginUsecase
    implements UsecaseWithParams<UserEntity, LoginUsecaseParams> {
  final IAuthRepository _authRepository;

  LoginUsecase({required IAuthRepository authRepository})
    : _authRepository = authRepository;

  @override
  Future<Either<Failure, UserEntity>> call(LoginUsecaseParams params) async {
    return await _authRepository.login(params.identifier, params.password);
  }
}
