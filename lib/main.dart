import 'dart:async';

import 'package:beamer/beamer.dart';
import 'package:cambrio/pages/login_page.dart';
import 'package:cambrio/pages/responsive_main_page.dart';
import 'package:cambrio/routes.dart';
import 'package:cambrio/services/firebase_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

// Import the generated file


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
    // usePathUrlStrategy();
    Beamer.setPathUrlStrategy();
    WidgetsFlutterBinding.ensureInitialized();
    // initializeServices();
    runApp(MaterialApp.router(
      // initialRoute: Routes.initial,
      // routes: Routes.routes,
      routerDelegate: Routes().routerDelegate,
      routeInformationParser: BeamerParser(),
      backButtonDispatcher: BeamerBackButtonDispatcher(
        delegate: Routes().routerDelegate,
      ),
      debugShowCheckedModeBanner: false,
      // home: App(),
      theme: ThemeData(

        fontFamily: 'Montserrat',
        primaryColor: colorScheme.primary,
        canvasColor: colorScheme.secondary,
        // bottomNavigationBarTheme: BottomNavigationBarThemeData(),
        // scaffoldBackgroundColor: colorScheme.background,
        // backgroundColor: colorScheme.background,
        // primaryColorBrightness: Brightness.light,
        appBarTheme: AppBarTheme(
          color: colorScheme.secondary,
          // shape: const Border(bottom: BorderSide(color: Colors.black54, width: 0.35)),
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
            // unselectedLabelStyle: TextStyle(color: Colors.black),
            unselectedItemColor: Colors.black,
            selectedIconTheme: IconThemeData(size: 30),
            elevation: 0,
        ),

        // textTheme: const TextTheme(
        //
        // ),
        primaryTextTheme: const TextTheme(

          titleMedium: TextStyle(
            fontFamily: 'Unna',
          ),
          titleLarge: TextStyle(
            fontFamily: 'Unna',
          ),
          titleSmall: TextStyle(
            fontFamily: 'Unna',
          ),
        ), colorScheme: colorScheme.copyWith(secondary: colorScheme.secondary)
        // buttonTheme: ButtonThemeData(
        //   shape:
        // ),
      ),
    ));
  }, (error, stack) {
    if (!kIsWeb) {
      FirebaseCrashlytics.instance.recordError(error, stack);

    }
    debugPrint(error.toString());
  });
}

class App extends StatefulWidget {
  final int initialIndex;

  const App({Key? key, this.initialIndex = 0}) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  FirebaseService firebaseService =  FirebaseService.instance;
  // Set default `_initialized` and `_error` state to false
  bool _initialized = false;
  final bool _error = false;
  // Stream<User?> state = FirebaseAuth.instance.authStateChanges();
  bool loggedIn = false;


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
    // initializeServices();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // debugPrint('on main');
    firebaseService.addListener(() {
      setState(() {
        // debugPrint('got the change bru');
        _initialized = firebaseService.initialized;
      });
    });
    // Show error message if initialization failed
    if(_error) {
      debugPrint(_error.toString());
      return const SomethingWentWrong();
    }

    // Show a loader until FlutterFire is initialized
    else if (!firebaseService.initialized) {
      // debugPrint('loading in main');
      return const Loading();
    }
    else if (!loggedIn) {
      isLoggedIn();
      return LoginScreen();
    }
    else {
      return ResponsivePage(title: "", selectedIndex: widget.initialIndex,);
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


