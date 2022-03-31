import 'dart:math';

import 'package:adaptive_navigation/adaptive_navigation.dart';
import 'package:beamer/beamer.dart';
import 'package:cambrio/pages/searchPage.dart';
import 'package:cambrio/unused_rn/search_page.dart';
import 'package:cambrio/pages/settings.dart';
import 'package:cambrio/util/get_positions.dart';
import 'package:cambrio/util/get_positions.dart';
import 'package:cambrio/util/get_positions.dart';
import 'package:cambrio/util/get_positions.dart';
import 'package:cambrio/util/get_positions.dart';
import 'package:cambrio/widgets/alert.dart';
import 'package:cambrio/widgets/book_grid_view.dart';
import 'package:cambrio/pages/edit_chapter.dart';
import 'package:cambrio/pages/edit_book.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cambrio/widgets/book_list_view.dart';
import 'package:cambrio/widgets/home_tab_view.dart';
import 'package:cambrio/widgets/profile/profile_view.dart';
import 'package:cambrio/pages/profile/personal_profile_page.dart';

// only for the crazy animation
import 'package:flutter/physics.dart';
import 'package:provider/provider.dart';

import '../models/tutorials_state.dart';
import '../models/tutorials_state.dart';

class ResponsivePage extends StatefulWidget {
  ResponsivePage({Key? key, required this.title, this.selectedIndex = 0})
      : super(key: key);
  final String title;
  int selectedIndex;

  @override
  _ResponsivePageState createState() => _ResponsivePageState();
}

class _ResponsivePageState extends State<ResponsivePage>
    with TickerProviderStateMixin { // this line only for the animation
  bool _fabInRail = false;
  bool _includeBaseDestinationsInMenu = false;
  // int _selectedIndex = 0;

  // start bell animation stuff
  final GlobalKey _keyBell = GlobalKey();
  final GlobalKey _keyFall = GlobalKey();

  late AnimationController controller;
  late AnimationController x_controller;
  double current_velocity = 1000;

  void _onItemTapped(int index) {
    setState(() {
      widget.selectedIndex = index;
    });
  }
  @override
  void initState() {
    FirebaseRemoteConfig.instance.fetchAndActivate();
    super.initState();

    controller = AnimationController(vsync: this, upperBound: 1000)
      ..addListener(() {
        setState(() {});
      });
    x_controller = AnimationController(vsync: this, upperBound: 10000)
      ..addListener(() {
        setState(() {});
      });

    WidgetsBinding.instance?.addPostFrameCallback((_) => setState(() {}));
  }

  @override
  void dispose() {
    controller.dispose();
    x_controller.dispose();
    super.dispose();
  }
  // end bell animation stuff


  // *these are the pages*
  Widget bodyFunction() {
    switch (widget.selectedIndex) {
      case 0:
        FirebaseAnalytics.instance
            .setCurrentScreen(
            screenName: 'Home'
        );
        Beamer.of(context).update(
          configuration: const RouteInformation(
            location: '/home',
          ),
          rebuild: false,
        );
        // Router.navigate();
        return const MyTabbedPage();
        break;
      case 1:
        FirebaseAnalytics.instance
            .setCurrentScreen(
            screenName: 'Explore/Search'
        );
        Beamer.of(context).update(
          configuration: const RouteInformation(
            location: '/explore',
          ),
          rebuild: false,
        );
        return const SearchingPage();
      case 2:
        FirebaseAnalytics.instance
            .setCurrentScreen(
            screenName: 'Personal Profile'
        );
        Beamer.of(context).update(
          configuration: const RouteInformation(
            location: '/profile',
          ),
          rebuild: false,
        );
        return const PersonalProfilePage();
      default:
        return const Center(child: Text("you managed to enter into the secret section of the app. prepare to fight the shadow boss"));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {


    return Stack(children: [ // stack is only for the bell animation.
      ChangeNotifierProvider(
        create: (_) => TutorialsState.instance,
        child: AdaptiveNavigationScaffold(
        selectedIndex: widget.selectedIndex,
        destinations: _allDestinations,
        appBar: AdaptiveAppBar(
          title: Text(widget.title),
          elevation: 0,
          actions: [
            IconButton(
                onPressed: () {
                  // report to analytics that the user clicked
                  FirebaseAnalytics.instance.logEvent(
                    name: "pencil_icon",
                  );
                  setState(() {
                    TutorialsState.instance.editClicked = true;
                    widget.selectedIndex = 2;
                  });
                },
                icon: const Icon(Icons.edit)),
            IconButton(onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        Settings()
                ),
              );
            }, icon: const Icon(Icons.settings)),
            IconButton(
                key: _keyBell, // only for animation
                onPressed: () {
                  debugPrint('wrong click');
                  // report to analytics that the user clicked
                  FirebaseAnalytics.instance.logEvent(
                    name: "notifications_icon",
                  );
                },
                icon: const Icon(Icons.notifications_none_rounded)),
          ],
        ),
        body: bodyFunction(),
        navigationTypeResolver: (context) {
          if (MediaQuery.of(context).size.width > 600) {
            return NavigationType.drawer;
          } else {
            return NavigationType.bottom;
          }
        },
        fabInRail: _fabInRail,
        includeBaseDestinationsInMenu: _includeBaseDestinationsInMenu,
        onDestinationSelected: _onItemTapped,
    ),
      ),

      // only for animation
      if (FirebaseRemoteConfig.instance.getBool('fancy_bell')) Positioned(
        top: getPositions(_keyBell).dy + controller.value,
        left: getPositions(_keyBell).dx - x_controller.value,
        child: Material(
          color: Colors.transparent,
          child: IconButton(
            // alignment: Alignment.bottomCenter,
              padding: const EdgeInsets.fromLTRB(0, (kIsWeb) ? 16:8, 0, 0),
              key: _keyFall,
              onPressed: () {
                debugPrint('cliccccked');

                Future.delayed(const Duration(milliseconds: 30000), () {
                  // debugPrint('trying to clear');
                  setState(() {
                    current_velocity = 1000;
                    controller.clearListeners();
                    // debugPrint('cleared listeners!');
                    controller.stop();
                    controller.reset();
                    x_controller.reset();
                  });
                });
                fall(context, getPositions(_keyBell).dy);
                // Alert().error(context, "whoops, we haven't built notifications yet!");
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("whoops, we haven't built notifications yet!")));

              },
              icon: const Icon(
                Icons.notifications_none_rounded,
              )),
        ),
      ),
    ]);
  }

  // bell animation; controls the x and y falling and bouncing motions.
  void fall(BuildContext context, double startingPos) {
    controller.reset();
    // x_controller.reset();
    double x_left = getPositions(_keyBell).dx + 35;
    double y_left =
        MediaQuery
            .of(context)
            .size
            .height - getPositions(_keyBell).dy - 40;
    // double x_left = 300;
    // double y_left = 600;

    controller.addListener(() {
      if (controller.value > y_left - 40) {
        // debugPrint("sped: ${controller.velocity.toString()} but curr is $current_velocity");
        // debugPrint("val: ${controller.value.toString()}");
        current_velocity = max(current_velocity, controller.velocity);
        // controller.animateWith(GravitySimulation(300,controller.value,controller.value, -0.9*controller.velocity));
      }
      // if (controller.value >= y_left-30) {
      //   controller.stop();
      // }
    });
    // debugPrint("start at ${startingPos} going to $y_left at $current_velocity");
    GravitySimulation simulation = GravitySimulation(
      2000.0, // acceleration
      startingPos, // starting point
      y_left, // end point
      current_velocity, // starting velocity
    );
    // controller.animateTo(y_left,curve: Curves.bounceOut, duration: const Duration(milliseconds: 1500));
    if (!x_controller.isAnimating) {
      x_controller.animateTo(x_left,
          curve: Curves.bounceOut,
          duration: const Duration(milliseconds: 10000));
    }
    controller.animateWith(simulation).then((nothing) {
      // debugPrint('done. $current_velocity');
      current_velocity = -0.8 * current_velocity;
      // debugPrint('now: $current_velocity starting at ${controller.value}');
      fall(context, y_left - 10);
      // controller;
      // controller.animateWith(GravitySimulation(
      //     300, controller.value, controller.value,
      //     -0.9 * controller.velocity));
    });
  }
}

const _allDestinations = [
  AdaptiveScaffoldDestination(title: 'Home', icon: Icons.home),
  AdaptiveScaffoldDestination(title: 'Explore', icon: Icons.search),
  AdaptiveScaffoldDestination(title: 'Profile', icon: Icons.portrait)
];
