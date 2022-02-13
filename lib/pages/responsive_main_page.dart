import 'package:adaptive_navigation/adaptive_navigation.dart';
import 'package:cambrio/widgets/book_grid_view.dart';
import 'package:cambrio/pages/write.dart';
import 'package:cambrio/pages/add_book.dart';
import 'package:flutter/material.dart';
import 'package:cambrio/widgets/book_list_view.dart';
import 'package:cambrio/widgets/home_tab_view.dart';
import 'package:cambrio/widgets/profile_view.dart';
import 'package:cambrio/pages/personal_profile_page.dart';

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

  Widget bodyFunction() {
    switch (_selectedIndex) {
      case 0:
        return const MyTabbedPage(); //BookListView(collectionToPull: "books");
        break;
      case 1:
        return const Center(child: Text("search cool stuff"));
      case 2:
        return PersonalProfilePage();
      default:
        return const Center(child: Text("other cool stuff"));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AdaptiveNavigationScaffold(
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      selectedIndex: _selectedIndex,
      destinations: _allDestinations,
      appBar: AdaptiveAppBar(
        title: Text(widget.title),
        elevation: 0,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddBook()), // When the upper right Pencil Icon is tapped, pull up the AddBook page from "add_book.dart"
                  // MaterialPageRoute(builder: (context) => Write()), // Jaden's Original Code for above line
                );
              },
              icon: const Icon(Icons.edit)),
          IconButton(
              onPressed: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => const Write()),
                // );
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
