import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supachat/utils/auth_utils.dart';
import 'package:supachat/views/signup_page.dart';
import 'package:supachat/widgets/styled_widgets.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isObscure = true;
  bool _lights = false;
  bool isLoading = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  @override
  void initState() {
    getCurrentTheme();
    super.initState();
  }

  getCurrentTheme() async {
    final currentTheme = await AdaptiveTheme.getThemeMode();
    if (currentTheme == AdaptiveThemeMode.light)
      setState(() {
        _lights = true;
      });
    else
      setState(() {
        _lights = false;
      });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.backgroundColor,
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: size.height * 0.1,
                width: size.width,
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: CupertinoSwitch(
                    value: _lights,
                    activeColor: theme.primaryColor,
                    onChanged: (bool value) {
                      value
                          ? AdaptiveTheme.of(context).setLight()
                          : AdaptiveTheme.of(context).setDark();
                      setState(() {
                        _lights = value;
                      });
                    },
                  ),
                ),
              ),
              Text(
                'Welcome Back!',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: size.height * 0.02,
              ),
              Text(
                'Please sign in to your account',
                style: TextStyle(
                  fontSize: 12.0,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: size.height * 0.1,
              ),
              StyledTextField(
                hintText: 'Email',
                controller: _emailController,
                validator: (String value) {
                  if (value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
              StyledTextField(
                hintText: 'Password',
                controller: _passwordController,
                validator: (String value) {
                  if (value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
                isObscure: isObscure,
                trailing: GestureDetector(
                    onTap: () {
                      setState(() {
                        isObscure = !isObscure;
                      });
                    },
                    child: Icon(
                      isObscure ? Icons.visibility_off : Icons.visibility,
                      color: Colors.grey,
                    )),
              ),
              SizedBox(
                height: size.height * 0.02,
              ),
              Container(
                width: size.width * 0.85,
                child: Text(
                  'Forget Password?',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontSize: 12.0,
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: SizedBox(),
              ),
              StyledButton(
                'Sign In',
                status: true,
                isLoading: isLoading,
                onPressed: () async {
                  setState(() {
                    isLoading = true;
                  });
                  await Provider.of<AuthUtils>(context, listen: false).signIn(
                      _emailController.text.trim(),
                      _passwordController.text.trim());
                  setState(() {
                    isLoading = false;
                  });
                },
              ),
              StyledButton(
                'Sign In with Google',
                status: true,
                onPressed: () {},
                color: theme.buttonColor,
                fontColor: theme.accentColor,
                leading: Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: Image.network(
                    'https://img.icons8.com/fluent/48/000000/google-logo.png',
                    width: 26.0,
                  ),
                ),
              ),
              SizedBox(
                height: size.height * 0.04,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Don\'t have an Account? ',
                    style: TextStyle(
                      fontSize: 12.0,
                      color: theme.buttonColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SignUpPage(),
                        ),
                      );
                    },
                    child: Text(
                      'Sign Up',
                      style: TextStyle(
                        fontSize: 12.0,
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: size.height * 0.06,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
