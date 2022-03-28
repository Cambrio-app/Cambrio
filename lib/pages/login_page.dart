import 'package:cambrio/pages/responsive_main_page.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';

import '../widgets/alert.dart';
// import 'dashboard_screen.dart';

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

      // report that the login was made
      await FirebaseAnalytics.instance
          .logLogin(
        loginMethod: 'EmailAndPassword',
      ).then((value) => debugPrint('hopefully, analytics ran.'));


      return null;
    } catch (e) {
      debugPrint('Failed to sign in with Email & Password');
      return 'Failed to sign in with Email & Password';
    }
  }

  Future<String?> _signupUser(SignupData data) async {
    // debugPrint('Signup Name: ${data.name}, Password: ${data.password}');

    try{
    final User? user = (await _auth.createUserWithEmailAndPassword(
      email: data.name ?? '',
      password: data.password ?? '',
    ))
        .user;
    if (user != null) {
      // report that the signup was successful
      await FirebaseAnalytics.instance
          .logSignUp(
          signUpMethod: 'EmailAndPassword'
      );

      return null;
    }
    } catch (error, _) {
      String? res;
      try {
        RegExp regex = RegExp(r'(?<=\[.*\])(.*)');
        res = regex.firstMatch(error.toString())?.group(0);
        debugPrint(res);
      } catch (e) {
        debugPrint('the error even failed');
      }
      return (res ?? error.toString());
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
    // FirebaseCrashlytics.instance.crash();
    return FlutterLogin(

      title: 'Cambrio',
      logo: const AssetImage('assets/images/logo_padded.png'),
      // theme: ,
      messages: LoginMessages(
        loginButton: 'Log In',
        signupButton: 'Sign Up'
      ),
      onLogin: _authUser,
      onSignup: _signupUser,
      onSubmitAnimationCompleted: () {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => ResponsivePage(title: ""),
        ));
      },
      onRecoverPassword: _recoverPassword,
      loginProviders: [
        // LoginProvider(
        //   icon: FontAwesomeIcons.google,
        //   label: 'Google',
        //   callback: () async {
        //     return null;
        //   },
        // ),
      ],


      theme: LoginTheme(
        logoWidth: 1,
        titleStyle: TextStyle(fontFamily: "Unna",color: Theme.of(context).colorScheme.onSecondary),
        // switchAuthTextColor: Theme.of(context).colorScheme.onSurface,
        pageColorLight: Theme.of(context).colorScheme.secondary,
        pageColorDark: Theme.of(context).colorScheme.secondary,
        cardTheme: Theme.of(context).cardTheme,
        buttonStyle: TextStyle(
          color: Theme.of(context).colorScheme.onPrimary,
        ),
        inputTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black.withOpacity(0.4))),
        ),
        buttonTheme: const LoginButtonTheme(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(3))
            ),
            elevation: 5,
        ),
        bodyStyle: const TextStyle(
          fontStyle: FontStyle.italic,
        ),

        // Theme.of(context).colorScheme.onSecondary,
      ),
    );

  }
}
