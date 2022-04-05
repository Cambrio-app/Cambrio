import 'dart:math';

import 'package:adaptive_navigation/adaptive_navigation.dart';
import 'package:beamer/beamer.dart';
import 'package:cambrio/pages/searchPage.dart';
import 'package:cambrio/pages/settings.dart';
import 'package:cambrio/util/get_positions.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cambrio/widgets/home_tab_view.dart';
import 'package:cambrio/pages/profile/personal_profile_page.dart';

// only for the crazy animation
import 'package:flutter/physics.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

import '../models/tutorials_state.dart';
import '../routes.dart';

class ResponsivePage extends StatefulWidget {
  ResponsivePage({Key? key, required this.title, this.selectedIndex = 0})
      : super(key: key);
  final String title;
  int selectedIndex;

  // final _beamerKey = GlobalKey<BeamerState>();
  // final _routerDelegate = Routes().submenudelegate;

  @override
  _ResponsivePageState createState() => _ResponsivePageState();
}

class _ResponsivePageState extends State<ResponsivePage>
    with TickerProviderStateMixin {
  // this line only for the animation
  bool _fabInRail = false;
  bool _includeBaseDestinationsInMenu = false;
  // int _selectedIndex = 0;

  // start bell animation stuff
  final GlobalKey _keyBell = GlobalKey();
  final GlobalKey _keyFall = GlobalKey();

  late AnimationController controller;
  late AnimationController x_controller;
  double current_velocity = 1000;

  final List pages = ['/home', '/explore', '/personal_profile'];
  late final BeamerDelegate _beamer;

  urlListener() {
  String path = _beamer.configuration.location ?? '/home';
  // debugPrint('path: $path');
  int updatedIndex = pages.indexOf(path);
  widget.selectedIndex = (updatedIndex == -1) ? 0: updatedIndex;
  setState(() {});
  }

  void _onItemTapped(int index) {
    // setState(() {
    //   // widget.selectedIndex = index;
    // });
    String route = '/home';
    route = pages[index];
    // widget._routerDelegate.beamToNamed(route);
    // debugPrint('clicked to go to : $route');
    // setState(() {
    //   widget.selectedIndex = index;
    // });
    Beamer.of(context).beamToReplacementNamed(route, stacked: false);

    // Beamer.of(context).update(
    //   configuration: RouteInformation(
    //     location: route,
    //   ),
    //   rebuild: false,
    // );
    // setState(() {});
  }

  @override
  void initState() {
    // FirebaseRemoteConfig.instance.fetchAndActivate();
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

    SchedulerBinding.instance?.addPostFrameCallback((_) {
      _beamer = Beamer.of(context);
      _beamer.addListener(urlListener);
    });
  }


  @override
  void dispose() {
    controller.dispose();
    x_controller.dispose();
    try {
      _beamer.removeListener(urlListener);
    } catch (e) {
      debugPrint('failed to remove listener.');
    }
    super.dispose();
  }
  // end bell animation stuff

  // *these are the pages*
  Widget bodyFunction() {
    // return Beamer(
    //   key: widget._beamerKey,
    //   routerDelegate: widget._routerDelegate,
    // );
    return IndexedStack(
      index: widget.selectedIndex,
      children: const [
        MyTabbedPage(),
        SearchPage(),
        PersonalProfilePage(),
      ],
    );
    // switch (widget.selectedIndex) {
    //   case 0:
    //     // Beamer.of(context).
    //     // Beamer.of(context).update(
    //     //   configuration: const RouteInformation(
    //     //     location: '/home',
    //     //   ),
    //     //   rebuild: true,
    //     // );
    //     // Router.navigate();
    //     return const MyTabbedPage();
    //     break;
    //   case 1:
    //     // Beamer.of(context).update(
    //     //   configuration: const RouteInformation(
    //     //     location: '/explore',
    //     //   ),
    //     //   rebuild: false,
    //     // );
    //     return const SearchPage();
    //   case 2:
    //     // Beamer.of(context).update(
    //     //   configuration: const RouteInformation(
    //     //     location: '/profile',
    //     //   ),
    //     //   rebuild: false,
    //     // );
    //     return const PersonalProfilePage();
    //   default:
    //     return const Center(
    //         child: Text(
    //             "you managed to enter into the secret section of the app. prepare to fight the shadow boss"));
    //     break;
    // }
  }

  @override
  Widget build(BuildContext context) {
    // String path = Beamer.of(context).configuration.location ?? '/home';
    // int updatedIndex = pages.indexOf(path);
    // widget.selectedIndex = (updatedIndex == -1) ? 0: updatedIndex;

    return Stack(children: [
      // stack is only for the bell animation.
      ChangeNotifierProvider(
        create: (_) => TutorialsState.instance,
        child: AdaptiveNavigationScaffold(
          selectedIndex: widget.selectedIndex,
          destinations: _allDestinations,
          appBar: AdaptiveAppBar(
            title: Text(widget.title),
            elevation: 0,
            actions: [
              // IconButton(
              //     onPressed: () {
              //       // report to analytics that the user clicked
              //       FirebaseAnalytics.instance.logEvent(
              //         name: "pencil_icon",
              //       );
              //       setState(() {
              //         TutorialsState.instance.editClicked = true;
              //         // widget.selectedIndex = 2;
              //         Beamer.of(context).beamToReplacementNamed('/personal_profile', stacked: false);
              //       });
              //     },
              //     icon: const Icon(Icons.edit)),
              if (widget.selectedIndex==2) IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Settings()),
                    );
                  },
                  icon: const Icon(Icons.settings)),
              if (widget.selectedIndex==2) IconButton(
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
          body: Column(
            children: [
              Expanded(child: bodyFunction()),
              const Divider(color: Colors.black54, thickness: 0.35),
            ],
          ),
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
      if (FirebaseRemoteConfig.instance.getBool('fancy_bell') && false)
        Positioned(
          top: getPositions(_keyBell).dy + controller.value,
          left: getPositions(_keyBell).dx - x_controller.value,
          child: Material(
            color: Colors.transparent,
            child: IconButton(
                // alignment: Alignment.bottomCenter,
                padding: const EdgeInsets.fromLTRB(0, (kIsWeb) ? 16 : 8, 0, 0),
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
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content:
                          Text("whoops, we haven't built notifications yet!")));
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
        MediaQuery.of(context).size.height - getPositions(_keyBell).dy - 40;
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
  AdaptiveScaffoldDestination(title: 'Books', icon: Icons.menu_book),
  AdaptiveScaffoldDestination(title: 'Explore', icon: Icons.search),
  AdaptiveScaffoldDestination(title: 'Profile', icon: Icons.portrait)
];
