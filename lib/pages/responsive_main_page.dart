import 'package:adaptive_navigation/adaptive_navigation.dart';
import 'package:cambrio/pages/search_page.dart';
import 'package:cambrio/widgets/book_grid_view.dart';
import 'package:cambrio/pages/write.dart';
import 'package:cambrio/pages/add_book.dart';
import 'package:flutter/material.dart';
import 'package:cambrio/widgets/book_list_view.dart';
import 'package:cambrio/widgets/home_tab_view.dart';
import 'package:cambrio/widgets/profile_view.dart';
import 'package:cambrio/pages/profile/personal_profile_page.dart';

class ResponsivePage extends StatefulWidget {
  const ResponsivePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _ResponsivePageState createState() => _ResponsivePageState();
}

class _ResponsivePageState extends State<ResponsivePage> {
  bool _fabInRail = false;
  bool _includeBaseDestinationsInMenu = false;
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
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
        return const Center(child: Text("you managed to enter into the secret section of the app. prepare to fight the shadow boss"));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AdaptiveNavigationScaffold(
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
              onPressed: () {
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
    );
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
