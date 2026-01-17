import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lost_n_found/core/api/api_client.dart';
import 'package:lost_n_found/core/api/api_endpoints.dart';
import 'package:lost_n_found/core/services/storage/user_session_service.dart';
import 'package:lost_n_found/features/auth/data/datasources/auth_datasource.dart';
import 'package:lost_n_found/features/auth/data/models/user_api_model.dart';

final authRemoteDatasourceProvider = Provider<IAuthRemoteDatasource>((ref) {
  final apiClient = ref.read(apiClientProvider);
  final userSessionService = ref.read(userSessionServiceProvider);
  return AuthRemoteDatasource(
    apiClient: apiClient,
    userSessionService: userSessionService,
  );
});

class AuthRemoteDatasource implements IAuthRemoteDatasource {
  final ApiClient _apiClient;
  final UserSessionService _userSessionService;

  AuthRemoteDatasource({
    required ApiClient apiClient,
    required UserSessionService userSessionService,
  }) : _apiClient = apiClient,
       _userSessionService = userSessionService;

  @override
  Future<UserApiModel?> signUp(UserApiModel userModel) async {
    final response = await _apiClient.post(
      ApiEndpoints.students,
      data: userModel.toJson(),
    );

    if (response.data["success"] as bool) {
      final data = response.data["data"] as Map<String, dynamic>;
      final newUser = UserApiModel.fromJson(data);
      return newUser;
    }

    return null;
  }

  @override
  Future<UserApiModel?> login(String identifier, String password) async {
    final response = await _apiClient.post(
      ApiEndpoints.studentLogin,
      data: {"identifier": identifier, "password": password},
    );

    if (!(response.data["success"] as bool)) {
      return null;
    }

    final data = response.data["data"] as Map<String, dynamic>;
    final user = UserApiModel.fromJson(data);
    await _userSessionService.storeUserSession(
      userId: user.id!,
      email: user.email,
      username: user.username,
      fullName: user.fullName,
      phoneNumber: user.phoneNumber,
      profilePictureUrl: user.profilePictureUrl,
    );
    return user;
  }

  @override
  Future<bool> logout() async {
    final response = await _apiClient.get(ApiEndpoints.studentLogout);
    if (!(response.data["success"] as bool)) {
      return false;
    }

    await _userSessionService.clearUserSession();
    return true;
  }

  @override
  Future<UserApiModel?> getCurrentUser(String userId) async {
    final response = await _apiClient.get(ApiEndpoints.studentById(userId));
    final data = response.data["data"];
    return UserApiModel.fromJson(data);
  }

  @override
  Future<bool> isEmailExists(String email) async {
    final response = await _apiClient.get(ApiEndpoints.studentByEmail(email));
    return response.data["success"] as bool;
  }
}
