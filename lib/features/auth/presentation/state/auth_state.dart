import 'package:equatable/equatable.dart';
import 'package:lost_n_found/features/auth/domain/entities/user_entity.dart';

enum AuthStatus {
  initial,
  loading,
  authenticated,
  unauthenticated,
  created,
  error,
}

class AuthState extends Equatable {
  final AuthStatus authStatus;
  final List<UserEntity> users;
  final String? errorMessage;

  const AuthState({
    this.authStatus = AuthStatus.initial,
    this.users = const [],
    this.errorMessage,
  });

  // copywith function
  AuthState copywith({
    AuthStatus? authStatus,
    List<UserEntity>? users,
    String? errorMessage,
  }) {
    return AuthState(
      authStatus: authStatus ?? this.authStatus,
      users: users ?? this.users,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [authStatus, users, errorMessage];
}
