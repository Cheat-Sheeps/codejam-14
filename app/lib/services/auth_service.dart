import 'package:get_it/get_it.dart';
import 'package:pocketbase/pocketbase.dart';

class AuthService {
  Future<String?> authWithPassword(String email, String password) async {
    try {
      await GetIt.instance<PocketBase>().collection('users').authWithPassword(email, password);
      return null;
    } catch (e) {
      return e.toString();
    }
  }
}