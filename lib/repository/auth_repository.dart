import '../services/api_service.dart';

class AuthRepository {
  Future<Map<String, dynamic>> login(
      String email, String password) {
    return ApiService.login(email, password);
  }

  Future<Map<String, dynamic>> signup(
      String name, String email, String password) {
    return ApiService.signup(name, email, password);
  }
}