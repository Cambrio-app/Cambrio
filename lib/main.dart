import 'package:cambrio/pages/login_page.dart';
import 'package:cambrio/pages/responsive_main_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'unused_rn/main_page.dart';

class White {
  static const MaterialColor kToLight = MaterialColor(
    0xFFFFFFFF, // 0% comes in here, this will be color picked if no shade is selected when defining a Color property which doesn’t require a swatch.
    <int, Color>{
      50:   Color(0xFFFFFFFF),//10%
      100:  Color(0xFFFFFFFF),//20%
      200:  Color(0xFFFFFFFF),//30%
      300:  Color(0xFFFFFFFF),//40%
      400:  Color(0xFFFFFFFF),//50%
      500:  Color(0xFFFFFFFF),//60%
      600:  Color(0xFFFFFFFF),//70%
      700:  Color(0xFFFFFFFF),//80%
      800:  Color(0xFFFFFFFF),//90%
      900:  Color(0xFFFFFFFF),//100%
    },
  );
}

class Whites {
  static const MaterialColor kToLight = MaterialColor(
    0xFFFFFFFF, // 0% comes in here, this will be color picked if no shade is selected when defining a Color property which doesn’t require a swatch.
    <int, Color>{
      50:   Color(0xFFFFFFFF),//10%
      100:  Color(0xFFfafafa),//20%
      200:  Color(0xFFf5f5f5),//30%
      300:  Color(0xFFf0f0f0),//40%
      400:  Color(0xFFdedede),//50%
      500:  Color(0xFFc2c2c2),//60%
      600:  Color(0xFF979797),//70%
      700:  Color(0xFF818181),//80%
      800:  Color(0xFF606060),//90%
      900:  Color(0xFF3c3c3c),//100%
    },
  );
}

class Purple {
  static const MaterialColor kToLight = MaterialColor(
    0xFF778dfc, // 0% comes in here, this will be color picked if no shade is selected when defining a Color property which doesn’t require a swatch.
    <int, Color>{
      50:   Color(0xFFe9ecff),//10%
      100:  Color(0xFFc8cefd),//20%
      200:  Color(0xFFa2aefc),//30%
      300:  Color(0xFF778dfc),//40%
      400:  Color(0xFF5372fa),//50%
      500:  Color(0xFF3457ef),//60%
      600:  Color(0xFF2e4ee3),//70%
      700:  Color(0xFF2343d6),//80%
      800:  Color(0xFF1b38c8),//90%
      900:  Color(0xFF0e22b1),//100%
    },
  );
}

final ColorScheme colorScheme = ColorScheme.fromSwatch(
  primarySwatch: Purple.kToLight,
  // primaryColorDark: const Color(0xff0e22b1),
  // backgroundColor: Colors.white,
).copyWith(
  // secondary: const Color(0x778dfc),
  secondary: Colors.white, //Whites.kToLight,
  onSecondary: Colors.black, //Purple.kToLight,
);
// final ColorScheme colorScheme = ColorScheme.fromSwatch(primarySwatch: Colors.grey);

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
      home:App(),
      theme: ThemeData(

        colorScheme: colorScheme,
        accentColor: colorScheme.secondary,
        primaryColor: colorScheme.primary,
        canvasColor: colorScheme.secondary,
        // bottomNavigationBarTheme: BottomNavigationBarThemeData(),
        // scaffoldBackgroundColor: colorScheme.background,
        // backgroundColor: colorScheme.background,
        // primaryColorBrightness: Brightness.light,
        appBarTheme: AppBarTheme(
          color: colorScheme.secondary,
          // toolbarTextStyle: TextStyle(color:colorScheme.primary),
          iconTheme: IconThemeData(color: colorScheme.onSecondary),
          // shape: const Border(bottom: BorderSide(width: 1.0, color: Colors.black),),
        ),
        tabBarTheme: TabBarTheme(
          labelColor: colorScheme.onSecondary,
        ),
        cardTheme: CardTheme(
          color: colorScheme.surface,
          shape: const Border(
              top:BorderSide(width: 1.50, color: Colors.white),
              left:BorderSide(width: 1.50, color: Colors.white),
              bottom:BorderSide(width: 5.0, color: Colors.white),
              right:BorderSide(width: 5.0, color: Colors.white)
          ),
          shadowColor: Colors.transparent,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(elevation: 0),
      ),
  ));
}

class App extends StatefulWidget {
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  // Set default `_initialized` and `_error` state to false
  bool _initialized = false;
  bool _error = false;

  // Define an async function to initialize FlutterFire
  void initializeFlutterFire() async {
    try {
      // Wait for Firebase to initialize and set `_initialized` state to true
      await Firebase.initializeApp();
      setState(() {
        _initialized = true;
      });
    } catch(e) {
      // Set `_error` state to true if Firebase initialization fails
      setState(() {
        _error = true;
      });
    }
  }

  @override
  void initState() {
    initializeFlutterFire();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Show error message if initialization failed
    if(_error) {
      return const SomethingWentWrong();
    }

    // Show a loader until FlutterFire is initialized
    if (!_initialized) {
      return const Loading();
    }

    return const ResponsivePage(title: "");
    // return LoginScreen();
  }
}

class Loading extends StatelessWidget{
  const Loading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Text('loading', textDirection: TextDirection.ltr);
  }
}

class SomethingWentWrong extends StatelessWidget {
  const SomethingWentWrong({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Text('sorry we did bad :(', textDirection: TextDirection.ltr);
  }
}


