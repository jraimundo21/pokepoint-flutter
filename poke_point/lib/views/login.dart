import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import '../utils/theme.dart';
import 'base.dart';
import 'package:flutter/widgets.dart';

//  > Flutter Login
//  package:        flutter_login 2.0.0
//  manual url:     https://pub.dev/packages/flutter_login

// Test user, apagar
const users = const {
  'a@a.a': '12345',
};

class LoginScreen extends StatelessWidget {
  Duration get loginTime => Duration(milliseconds: 2250);

  Future<String> _authUser(LoginData data) {
    print('Name: ${data.name}, Password: ${data.password}');
    return Future.delayed(loginTime).then((_) {
      if (!users.containsKey(data.name)) {
        return 'User not exists';
      }
      if (users[data.name] != data.password) {
        return 'Password does not match';
      }
      return null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final inputBorder = BorderRadius.vertical(
      bottom: Radius.circular(5.0),
      top: Radius.circular(10.0),
    );

    return new FlutterLogin(
      title: 'POKE POINT',
      logo: 'assets/images/poke_point_transparent_onlylogo.png',
      onLogin: _authUser,
      hideSignUpButton: true,
      onSignup: (_) => Future(null),
      hideForgotPasswordButton: true,
      onRecoverPassword: (_) => Future(null),
      onSubmitAnimationCompleted: () {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => BaseView(),
        ));
      },
      theme: LoginTheme(
        primaryColor: PrimaryColorLight.withOpacity(0.3),
        errorColor: Colors.deepOrange,
        titleStyle: TextStyle(
            color: PrimaryColor,
            fontFamily: 'Quicksand',
            letterSpacing: -2,
            fontWeight: FontWeight.w400),
        bodyStyle: TextStyle(
          fontStyle: FontStyle.italic,
          decoration: TextDecoration.underline,
        ),
        textFieldStyle: TextStyle(
          color: PrimaryColorDark,
          shadows: [Shadow(color: PrimaryColorLight, blurRadius: 2)],
        ),
        buttonStyle: TextStyle(
          fontWeight: FontWeight.w800,
          color: Colors.yellow,
        ),
        cardTheme: CardTheme(
          color: PrimaryColor,
          elevation: 5,
          margin: EdgeInsets.only(top: 15),
          shape: ContinuousRectangleBorder(
              borderRadius: BorderRadius.circular(50.0)),
        ),
        inputTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white.withOpacity(0.8),
          contentPadding: EdgeInsets.zero,
          errorStyle: TextStyle(
            backgroundColor: Colors.orange,
            color: Colors.white,
          ),
          labelStyle: TextStyle(fontSize: 14),
          enabledBorder: UnderlineInputBorder(
            borderSide:
                BorderSide(color: PrimaryColorLight.withOpacity(.4), width: 4),
            borderRadius: inputBorder,
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.blue.shade400, width: 5),
            borderRadius: inputBorder,
          ),
          errorBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.red.shade700, width: 7),
            borderRadius: inputBorder,
          ),
          focusedErrorBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.red.shade400, width: 8),
            borderRadius: inputBorder,
          ),
          disabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 5),
            borderRadius: inputBorder,
          ),
        ),
        buttonTheme: LoginButtonTheme(
          splashColor: Colors.purple,
          backgroundColor: Colors.deepOrange,
          highlightColor: Colors.lightGreen,
          elevation: 9.0,
          highlightElevation: 6.0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }
}
