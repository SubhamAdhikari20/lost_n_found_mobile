import 'package:lost_n_found/features/auth/data/models/user_api_model.dart';
import 'package:lost_n_found/features/auth/data/models/user_hive_model.dart';

abstract interface class IAuthLocalDatasource {
  Future<UserHiveModel?> signUp(UserHiveModel userModel);
  Future<UserHiveModel?> login(String identifier, String password);
  Future<UserHiveModel?> getCurrentUser(String userId);
  Future<bool> logout();

  Future<bool> isEmailExists(String email);
}

abstract interface class IAuthRemoteDatasource {
  Future<UserApiModel?> signUp(UserApiModel userModel);
  Future<UserApiModel?> login(String identifier, String password);
  Future<UserApiModel?> getCurrentUser(String userId);
  Future<bool> logout();

  Future<bool> isEmailExists(String email);
}
