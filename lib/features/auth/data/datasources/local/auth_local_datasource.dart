import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lost_n_found/core/services/hive/hive_service.dart';
import 'package:lost_n_found/core/services/storage/user_session_service.dart';
import 'package:lost_n_found/features/auth/data/datasources/auth_datasource.dart';
import 'package:lost_n_found/features/auth/data/models/user_hive_model.dart';

final authLocalDatasourceProvider = Provider<IAuthLocalDatasource>((ref) {
  final hiveService = ref.read(hiveServiceProvider);
  final userSessionService = ref.read(userSessionServiceProvider);
  return AuthLocalDatasource(
    hiveService: hiveService,
    userSessionService: userSessionService,
  );
});

class AuthLocalDatasource implements IAuthLocalDatasource {
  final HiveService _hiveService;
  final UserSessionService _userSessionService;

  AuthLocalDatasource({
    required HiveService hiveService,
    required UserSessionService userSessionService,
  }) : _hiveService = hiveService,
       _userSessionService = userSessionService;

  @override
  Future<UserHiveModel?> signUp(UserHiveModel userModel) async {
    try {
      await _hiveService.signUp(userModel);
      return Future.value(userModel);
    } catch (e) {
      return Future.value(null);
    }
  }

  @override
  Future<UserHiveModel?> login(String identifier, String password) async {
    try {
      final user = await _hiveService.login(identifier, password);
      if (user != null) {
        await _userSessionService.storeUserSession(
          userId: user.userId!,
          email: user.email,
          username: user.username,
          fullName: user.fullName,
          phoneNumber: user.phoneNumber,
          profilePictureUrl: user.profilePictureUrl,
        );
      }
      return Future.value(user);
    } catch (e) {
      return Future.value(null);
    }
  }

  @override
  Future<bool> logout() async {
    try {
      final isLoggedOut = await _hiveService.logout();

      if (isLoggedOut) {
        await _userSessionService.clearUserSession();
      }

      return Future.value(isLoggedOut);
    } catch (e) {
      return Future.value(false);
    }
  }

  @override
  Future<UserHiveModel?> getCurrentUser(String userId) async {
    try {
      final user = await _hiveService.getCurrentUser(userId);
      return Future.value(user);
    } catch (e) {
      return Future.value(null);
    }
  }

  @override
  Future<bool> isEmailExists(String email) async {
    try {
      final isExists = await _hiveService.isEmailExists(email);
      return Future.value(isExists);
    } catch (e) {
      return Future.value(false);
    }
  }
}
