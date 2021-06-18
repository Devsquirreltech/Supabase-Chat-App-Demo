import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase/supabase.dart' as sb;
import 'package:supachat/utils/auth_utils.dart';
import 'package:supachat/views/home_page.dart';
import 'package:supachat/views/login_page.dart';
import 'dart:async';
import 'package:uni_links/uni_links.dart';
import 'package:flutter/services.dart' show PlatformException;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initUniLinks();
  final savedThemeMode = await AdaptiveTheme.getThemeMode();
  runApp(MyApp(
    savedThemeMode: savedThemeMode,
  ));
}


Future<void> initUniLinks() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  // Platform messages may fail, so we use a try/catch PlatformException.
  try {
    final initialLink = await getInitialLink();
    print(initialLink);
    await prefs.setString('googleSessionUrl', initialLink ?? 'empty');
    // Parse the link and warn the user, if it is not correct,
    // but keep in mind it could be `null`.
  } on PlatformException {
    // Handle exception by warning the user their action did not succeed
    // return?
  }
}

class MyApp extends StatefulWidget {
  final savedThemeMode;

  const MyApp({
    Key? key,
    required this.savedThemeMode,
  }) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _navigatorKey = GlobalKey<NavigatorState>();
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthUtils>.value(
          value: AuthUtils(),
        ),
      ],
      child: AdaptiveTheme(
        light: ThemeData(
          brightness: Brightness.light,
          primarySwatch: Colors.blue,
          accentColor: Colors.white,
          backgroundColor: Color.fromRGBO(243, 243, 243, 1.0),
          fontFamily: 'George',
          buttonColor: Colors.black,
          primaryColor: Color.fromRGBO(84, 104, 255, 1.0),
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.white,
            elevation: 5,
            iconTheme: IconThemeData(color: Colors.black),
            titleTextStyle: TextStyle(color: Colors.black),
            systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: Colors.white,
            ),
          ),
        ),
        dark: ThemeData(
          brightness: Brightness.dark,
          primarySwatch: Colors.blue,
          accentColor: Color.fromRGBO(38, 42, 53, 1.0),
          backgroundColor: Color.fromRGBO(25, 26, 31, 1.0),
          fontFamily: 'George',
          buttonColor: Colors.white,
          primaryColor: Color.fromRGBO(84, 104, 255, 1.0),
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.black,
            elevation: 5,
            systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: Colors.black,
            ),
          ),
        ),
        initial: widget.savedThemeMode ?? AdaptiveThemeMode.dark,
        builder: (theme, darkTheme) => MaterialApp(
          navigatorKey: _navigatorKey,
          theme: theme,
          darkTheme: darkTheme,
          home: SplashScreen(),
        ),
      ),
    );
  }
}

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final sb.User? _user = Provider.of<AuthUtils>(context).getUser;
    return FutureBuilder(
      future: Provider.of<AuthUtils>(context, listen: false).recoverSession(),
      initialData: false,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData && snapshot.data) {
          return _user == null ? LoginPage() : Homepage();
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
