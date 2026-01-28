import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lost_n_found/core/error/failures.dart';
import 'package:lost_n_found/core/usecases/app_usecase.dart';
import 'package:lost_n_found/features/auth/data/repositories/auth_repository.dart';
import 'package:lost_n_found/features/auth/domain/entities/user_entity.dart';
import 'package:lost_n_found/features/auth/domain/repositories/auth_repository.dart';

// Sign Up Params
class SignUpUsecaseParams extends Equatable {
  final String fullName;
  final String email;
  final String username;
  final String? phoneNumber;
  final String? password;
  final String? batchId;
  final String? profilePictureUrl;

  const SignUpUsecaseParams({
    required this.fullName,
    required this.email,
    required this.username,
    this.phoneNumber,
    this.password,
    this.batchId,
    this.profilePictureUrl,
  });

  @override
  List<Object?> get props => [
    fullName,
    email,
    username,
    phoneNumber,
    password,
    batchId,
    profilePictureUrl,
  ];
}

// Provider for SignUp Usecase
final signUpUsecaseProvider = Provider<SignUpUsecase>((ref) {
  final authRepository = ref.read(authRepositoryProvider);
  return SignUpUsecase(authRepository: authRepository);
});

// SignUp Usecase
class SignUpUsecase
    implements UsecaseWithParams<UserEntity, SignUpUsecaseParams> {
  final IAuthRepository _authRepository;

  SignUpUsecase({required IAuthRepository authRepository})
    : _authRepository = authRepository;

  @override
  Future<Either<Failure, UserEntity>> call(SignUpUsecaseParams params) async {
    // Validate email fields
    if (params.email.isEmpty) {
      return const Left(ValidationFailure(message: "Email is required."));
    }

    // create user entity
    UserEntity userEntity = UserEntity(
      email: params.email,
      username: params.username,
      fullName: params.fullName,
      phoneNumber: params.phoneNumber,
      password: params.password,
      batchId: params.batchId,
    );

    return await _authRepository.signUp(userEntity);
  }
}
