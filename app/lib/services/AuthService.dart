import 'package:pocketbase/pocketbase.dart';

class AuthService {
  static const String pocketBaseUrl = 'http://127.0.0.1:8090/';
  final PocketBase pb = PocketBase(pocketBaseUrl);

  Future<String?> authWithPassword(String email, String password) async {
    try {
      await pb.collection('users').authWithPassword(email, password);
      return null;
    } catch (e) {
      return e.toString();
    }
  }
}