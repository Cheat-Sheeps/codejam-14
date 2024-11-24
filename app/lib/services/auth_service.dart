import 'package:app/services/config_service.dart';
import 'package:get_it/get_it.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthResult {
  AuthResult({required this.isFailure, required this.data});

  bool isFailure;
  String data;
}

class AuthService {
  Future<AuthResult> authFromToken() async {
    PocketBase pb = GetIt.instance<PocketBase>();

    String? token = await _getTokenFromStorage();
    if (token == null || token.isEmpty) {
      return AuthResult(isFailure: true, data: 'No token found');
    }

    pb.authStore.save(token, {});
    if (!pb.authStore.isValid) {
      return AuthResult(isFailure: true, data: 'No token found');
    }

    final result = await pb.collection('users').authRefresh();
    _saveToken(token);

    return AuthResult(isFailure: false, data: result.token);
  }

  Future<AuthResult> authWithPassword(String email, String password) async {
    PocketBase pb = GetIt.instance<PocketBase>();

    try {
      final result = await pb.collection('users').authWithPassword(email, password);
      _saveToken(result.token);
      return AuthResult(isFailure: false, data: result.token);
    } catch (e) {
      return AuthResult(isFailure: true, data: e.toString());
    }
  }

  Future<String?> _getTokenFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('authToken');
  }

  void clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('authToken');
  }

  void _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('authToken', token);
  }
}