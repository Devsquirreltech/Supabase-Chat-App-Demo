import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase/supabase.dart';
import 'package:supachat/supabase_config.dart';
import 'package:url_launcher/url_launcher.dart';

class AuthUtils extends ChangeNotifier {
  final _client = SupabaseClient(kSupabaseUrl, kSupabaseKey);
  User? _user;

  // Sign in user with email and password
  Future<void> signIn(String email, String password) async {
    try {
      final response =
          await _client.auth.signIn(email: email, password: password);
      _user = response.user;
      if (response.error != null) {
        print("Error! Could not signin");
        print(response.error!.message);
      } else {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        final String session = response.data!.persistSessionString;
        await prefs.setString('session', session);
        notifyListeners();
      }
    } catch (e) {
      print(e);
    }
  }

  // Sign up user with email and password
  Future<void> signUp(String email, String password) async {
    try {
      final response = await _client.auth.signUp(email, password);
      if (response.error != null) {
        print("Error! Could not signup");
        print(response.error!.message);
      } else {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        final String session = response.data!.persistSessionString;
        await prefs.setString('session', session);
        notifyListeners();
      }
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }


  Future<void> onSignInWithGoogle(BuildContext context) async {
    final response = await _client.auth.signIn(provider: Provider.google);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (response.error != null) {
      print("Error! Could not login with google");
      print(response.error!.message);
    } else {
      if (await canLaunch(response.url!)) {
        print('response.url: ${response.url}');
         await launch(response.url!);
        SystemChannels.platform.invokeMethod('SystemNavigator.pop');
      } else {
        throw 'Could not launch ${response.url}';
      }
    }
  }

  Future<bool> recoverSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? sessionString = prefs.getString('session');
    final String? googleSessionUrl = prefs.getString('googleSessionUrl');
    if(googleSessionUrl != null && googleSessionUrl != 'empty'){
      final callback = await _client.auth.getSessionFromUrl(Uri.parse(googleSessionUrl));
      _user = callback.user;
      notifyListeners();
      return true;
    }
    if (sessionString != null) {
      try {
        final response = await _client.auth.recoverSession(sessionString);
        if (response.error != null) {
          print("Error! Could not recover the session");
          print(response.error!.message);
        } else {
          _user = response.user;
          notifyListeners();
        }
      } catch (e) {
        print(e);
      }
    }
    return true;
  }

  User? get getUser {
    return _user;
  }
}
