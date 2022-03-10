import 'package:cambrio/pages/responsive_main_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
// import 'dashboard_screen.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

const users = {
  'dribbble@gmail.com': '12345',
  'hunter@gmail.com': 'hunter',
};

class LoginScreen extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Duration get loginTime => Duration(milliseconds: 2250);
  Future<String?> _authUser(LoginData data) async {
    try {
      final User user = (await _auth.signInWithEmailAndPassword(
        email: data.name,
        password: data.password,
      ))
          .user!;
      debugPrint('${user.email} signed in');
      return null;
    } catch (e) {
      debugPrint('Failed to sign in with Email & Password');
      return 'Failed to sign in with Email & Password';
    }
  }

  Future<String?> _signupUser(SignupData data) async {
    // debugPrint('Signup Name: ${data.name}, Password: ${data.password}');

    final User? user = (await _auth.createUserWithEmailAndPassword(
      email: data.name ?? '',
      password: data.password ?? '',
    ))
        .user;
    if (user != null) {
      return null;
    } else {
      return 'failure';
    }
  }

  Future<String?> _recoverPassword(String name) {
    debugPrint('Name: $name');
    return Future.delayed(loginTime).then((_) {
      if (!users.containsKey(name)) {
        return 'User not exists';
      }
      return null;
    });
  }

  @override
  Widget build(BuildContext context) {
    // debugPrint(Theme.of(context).colorScheme.onBackground.toString());
    return FlutterLogin(

      title: 'Cambrio',
      logo: const AssetImage('assets/images/app_icon.png'),
      // theme: ,
      onLogin: _authUser,
      onSignup: _signupUser,
      onSubmitAnimationCompleted: () {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => ResponsivePage(title: ""),
        ));
      },
      onRecoverPassword: _recoverPassword,
      loginProviders: [
        LoginProvider(
          icon: FontAwesomeIcons.google,
          label: 'Google',
          callback: () async {
            return null;
          },
        ),
      ],


      theme: LoginTheme(
        titleStyle: TextStyle(fontFamily: "Unna",color: Theme.of(context).colorScheme.onSecondary),
        // switchAuthTextColor: Theme.of(context).colorScheme.onSurface,
        pageColorLight: Theme.of(context).colorScheme.secondary,
        pageColorDark: Theme.of(context).colorScheme.secondary,
        cardTheme: Theme.of(context).cardTheme,
        buttonStyle: TextStyle(
          color: Theme.of(context).colorScheme.onPrimary,
        ),

        // Theme.of(context).colorScheme.onSecondary,
      ),
    );

  }
}
