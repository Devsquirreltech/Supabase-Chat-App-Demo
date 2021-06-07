import 'package:flutter/foundation.dart';
import 'package:supabase/supabase.dart';
import 'package:supachat/supabase_config.dart';

class AuthUtils extends ChangeNotifier{
  final _client = SupabaseClient(kSupabaseUrl, kSupabaseKey);
  User? _user;

  // Sign in user with email and password
  Future<void> signIn(String email, String password) async {
    try{
      final response = await _client.auth.signIn(email: email, password: password);
      _user = response.user;
      notifyListeners();
    }
    catch(e){
      print(e);
    }
  }

  // Sign up user with email and password
  Future<void> signUp(String email, String password) async {
    try{
      final response = await _client.auth.signUp(email, password);
      notifyListeners();
    }
    catch(e){
      print(e);
    }
  }

  User? get getUser {
    return _user;
  }
}
