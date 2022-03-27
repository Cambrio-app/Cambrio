import 'dart:async';
import 'dart:isolate';

import 'package:cambrio/pages/login_page.dart';
import 'package:cambrio/pages/responsive_main_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

// Import the generated file
import 'firebase_options.dart';

import 'models/tutorials_state.dart';
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
  runZonedGuarded<Future<void>>(() async {
    WidgetsFlutterBinding.ensureInitialized();

    runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: App(),
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
              top: BorderSide(width: 1.50, color: Colors.white),
              left: BorderSide(width: 1.50, color: Colors.white),
              bottom: BorderSide(width: 5.0, color: Colors.white),
              right: BorderSide(width: 5.0, color: Colors.white)
          ),
          shadowColor: Colors.transparent,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            elevation: 0),
      ),
    ));
  }, (error, stack) => FirebaseCrashlytics.instance.recordError(error, stack));
}

class App extends StatefulWidget {
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  // Set default `_initialized` and `_error` state to false
  bool _initialized = false;
  bool _error = false;
  // Stream<User?> state = FirebaseAuth.instance.authStateChanges();
  bool loggedIn = false;

  // Define an async function to initialize FlutterFire
  void initializeServices() async {
    // await Future.delayed(Duration(seconds: 20));


    // make sure that TutorialsState is _initialized
    await TutorialsState.initInstance();
    debugPrint('initialized tutorials state');
    
    try {
      // Wait for Firebase to initialize and set `_initialized` state to true
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      setState(() {
        _initialized = true;
      });

      debugPrint('goooo');

      // set up crashlytics
      FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
      if (!kIsWeb) { // only set it up on mobile; it's not available on web.
        Isolate.current.addErrorListener(RawReceivePort((pair) async {
        final List<dynamic> errorAndStacktrace = pair;
        await FirebaseCrashlytics.instance.recordError(
          errorAndStacktrace.first,
          errorAndStacktrace.last,
        );
      }).sendPort);
      }

      // set up google analytics
      // FirebaseAnalytics analytics = FirebaseAnalytics.instance;

      // set defaults for remote config values, like auto_search
      await FirebaseRemoteConfig.instance.setDefaults(<String, dynamic>{
        'welcome_message': 'default welcome message',
        'auto_search': true,
        'fancy_bell': false,
      });

      FirebaseRemoteConfig rc = FirebaseRemoteConfig.instance;
      await rc.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
        minimumFetchInterval: const Duration(seconds: 30),
        // minimumFetchInterval: const Duration(hours: 3),
      ));
      bool updated = await rc.fetchAndActivate();
      // debugPrint('updated?: $updated auto_search???: ${rc.getBool('auto_search').toString()}');
    } catch(e) {
      // Set `_error` state to true if Firebase initialization fails
      setState(() {
        debugPrint(e.toString());
        _error = true;
      });
    }
  }

  // check login state
  bool isLoggedIn() {
    // debugPrint('checking');
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user==null){
        setState(() {
          // debugPrint('officially NOT logged in');
          loggedIn = false;
        });
      }
      else {
        setState(() {
          debugPrint('officially logged in');
          loggedIn = true;
        });
      }
    });
    return FirebaseAuth.instance.currentUser != null;
  }

  @override
  void initState() {
    initializeServices();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Show error message if initialization failed
    if(_error) {
      debugPrint(_error.toString());
      return const SomethingWentWrong();
    }

    // Show a loader until FlutterFire is initialized
    else if (!_initialized) {
      return const Loading();
    }
    else if (!loggedIn && _initialized) {
      isLoggedIn();
      return LoginScreen();
    }
    else {
      return ResponsivePage(title: "");
    }
  }
}

class Loading extends StatelessWidget{
  const Loading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Material(child: Center(child: Text('loading', textDirection: TextDirection.ltr)));
  }
}

class SomethingWentWrong extends StatelessWidget {
  const SomethingWentWrong({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Text('sorry we did bad :(', textDirection: TextDirection.ltr);
  }
}


