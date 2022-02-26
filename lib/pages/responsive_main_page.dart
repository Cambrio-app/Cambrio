import 'dart:math';

import 'package:adaptive_navigation/adaptive_navigation.dart';
import 'package:cambrio/pages/search_page.dart';
import 'package:cambrio/widgets/book_grid_view.dart';
import 'package:cambrio/pages/edit_chapter.dart';
import 'package:cambrio/pages/edit_book.dart';
import 'package:flutter/material.dart';
import 'package:cambrio/widgets/book_list_view.dart';
import 'package:cambrio/widgets/home_tab_view.dart';
import 'package:cambrio/widgets/profile/profile_view.dart';
import 'package:cambrio/pages/profile/personal_profile_page.dart';
import 'package:flutter/physics.dart';

class ResponsivePage extends StatefulWidget {
  const ResponsivePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _ResponsivePageState createState() => _ResponsivePageState();
}

class _ResponsivePageState extends State<ResponsivePage>
    with TickerProviderStateMixin {
  bool _fabInRail = false;
  bool _includeBaseDestinationsInMenu = false;
  int _selectedIndex = 0;
  final GlobalKey _keyBell = GlobalKey();
  final GlobalKey _keyFall = GlobalKey();

  late AnimationController controller;
  late AnimationController x_controller;
  double current_velocity = 1000;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();

    controller = AnimationController(vsync: this, upperBound: 1000)
      ..addListener(() {
        setState(() {});
      });
    x_controller = AnimationController(vsync: this, upperBound: 1000)
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

  // *these are the pages*
  Widget bodyFunction() {
    switch (_selectedIndex) {
      case 0:
        return const MyTabbedPage();
        break;
      case 1:
        return const SearchPage();
      case 2:
        return const PersonalProfilePage();
      default:
        return const Center(
            child: Text(
                "you managed to enter into the secret section of the app. prepare to fight the shadow boss"));
        break;
    }
  }

  Offset _getPositions(GlobalKey key) {
    if (key.currentContext != null) {
      final RenderBox renderBoxRed =
          key.currentContext!.findRenderObject() as RenderBox;
      final positionRed = renderBoxRed.localToGlobal(Offset.zero);
      // print("POSITION of bell: $positionRed ");
      return positionRed;
    } else {
      return const Offset(0, 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      AdaptiveNavigationScaffold(
        selectedIndex: _selectedIndex,
        destinations: _allDestinations,
        appBar: AdaptiveAppBar(
          title: Text(widget.title),
          elevation: 0,
          actions: [
            IconButton(
                onPressed: () {
                  setState(() {
                    _selectedIndex = 2;
                  });
                },
                icon: const Icon(Icons.edit)),
            IconButton(
                key: _keyBell,
                onPressed: () {
                  _getPositions(_keyBell);
                },
                icon: const Icon(
                  Icons.notifications_none_rounded,
                  color: Colors.transparent,
                )),
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
      Positioned(
        top: _getPositions(_keyBell).dy + controller.value,
        left: _getPositions(_keyBell).dx - x_controller.value,
        child: Material(
          color: Colors.transparent,
          child: IconButton(
              // alignment: Alignment.bottomCenter,
              padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
              key: _keyFall,
              onPressed: () {
                Future.delayed(const Duration(milliseconds: 30000), () {
                  debugPrint('trying to clear');
                  setState(() {
                    current_velocity = 1000;
                    controller.clearListeners();
                    debugPrint('cleared listeners!');
                    controller.stop();
                    controller.reset();
                    x_controller.reset();
                  });
                });
                fall(context, _getPositions(_keyBell).dy);

              },
              icon: const Icon(
                Icons.notifications_none_rounded,
              )),
        ),
      ),
    ]);
  }

  void fall(BuildContext context, double startingPos) {
    controller.reset();
    // x_controller.reset();
    double x_left = _getPositions(_keyBell).dx + 35;
    double y_left =
        MediaQuery.of(context).size.height - _getPositions(_keyBell).dy-40;
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
        curve: Curves.bounceOut, duration: const Duration(milliseconds: 10000));
    }
    controller.animateWith(simulation).then((nothing) {
      // debugPrint('done. $current_velocity');
      current_velocity = -0.8*current_velocity;
      // debugPrint('now: $current_velocity starting at ${controller.value}');
      fall(context, y_left-10);
      // controller;
      // controller.animateWith(GravitySimulation(
      //     300, controller.value, controller.value,
      //     -0.9 * controller.velocity));
    });
  }

  Widget _body() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // const Text('''
          // This is a custom behavior of the AdaptiveNavigationScaffold.
          // It switches between bottom navigation and a drawer.
          // Resize the window to switch between the navigation types.
          // '''),
          // const SizedBox(height: 40),

          const Text('Destination Count'),
          // const SizedBox(height: 40),
          Switch(
            value: _fabInRail,
            onChanged: (value) {
              setState(() {
                _fabInRail = value;
              });
            },
          ),
          const Text('fabInRail'),
          // const SizedBox(height: 40),
          Switch(
            value: _includeBaseDestinationsInMenu,
            onChanged: (value) {
              setState(() {
                _includeBaseDestinationsInMenu = value;
              });
            },
          ),
          const Text('includeBaseDestinationsInMenu'),
          // const SizedBox(height: 40),
          // ElevatedButton(
          //   child: const Text('BACK'),
          //   onPressed: () {
          //     Navigator.of(context).pushReplacementNamed('/');
          //   },
          // )
        ],
      ),
    );
  }
}

const _allDestinations = [
  AdaptiveScaffoldDestination(title: 'Home', icon: Icons.home),
  AdaptiveScaffoldDestination(title: 'Explore', icon: Icons.search),
  AdaptiveScaffoldDestination(title: 'Profile', icon: Icons.portrait)
];
