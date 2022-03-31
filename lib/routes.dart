import 'package:cambrio/pages/profile/personal_profile_page.dart';
import 'package:cambrio/pages/responsive_main_page.dart';
import 'package:cambrio/pages/searchPage.dart';
import 'package:cambrio/services/firebase_service.dart';
import 'package:cambrio/widgets/home_tab_view.dart';
import 'package:flutter/material.dart';
import 'package:beamer/beamer.dart';

import 'main.dart';

class Routes {
  static const initial = '/';
  static Map<String, WidgetBuilder> routes = {
    '/': (context) => App(initialIndex: 0),
    '/explore': (context) => ResponsivePage(title: '', selectedIndex: 1),
    '/loading': (context) => const Loading(),
  };

  // final submenudelegate = BeamerDelegate(
  //     initialPath: '/home',
  //     locationBuilder: RoutesLocationBuilder(routes: {
  //       '/home': (context, state, data) {
  //         // state = 0;
  //         return const BeamPage(
  //           type: BeamPageType.noTransition,
  //           key: ValueKey('home'),
  //           child: MyTabbedPage(),
  //         );
  //       },
  //       '/explore': (context, state, data) {
  //         // state.
  //         context.currentBeamLocation.data = 1;
  //         return const BeamPage(
  //           type: BeamPageType.noTransition,
  //           key: ValueKey('explore'),
  //           child: SearchingPage(),
  //         );
  //       },
  //       '/personal_profile': (context, state, data) {
  //         context.currentBeamLocation.data = 2;
  //         return const BeamPage(
  //           type: BeamPageType.noTransition,
  //           key: ValueKey('personal_profile'),
  //           child: PersonalProfilePage(),
  //         );
  //       },
  //     }));

  final routerDelegate = BeamerDelegate(
    guards: [
      BeamGuard(
        // on which path patterns (from incoming routes) to perform the check
        pathPatterns: ['/loading'],
        // perform the check on all patterns that **don't** have a match in pathPatterns
        guardNonMatching: true,
        // return false to redirect
        check: (context, location) => FirebaseService.instance.initialized,
        // where to redirect on a false check
        beamToNamed: (origin, target) => '/loading',
        replaceCurrentStack: true,
        onCheckFailed: (context, location) {
          // Beamer.of(context).beamToNamed('/loading');
          debugPrint('Firebase not initialized. Loading ...');
          FirebaseService service = FirebaseService.instance;
          service.addListener(() {
            // debugPrint('listener triggered');
            if (service.initialized) {
              // debugPrint('its initialized: ${location.toString()}');
              Beamer.of(context).beamToReplacement(location);
            }
          });
          service.initializeServices();
        },
      )
    ],
    locationBuilder: RoutesLocationBuilder(
      routes: {
        '/': (context, state, data) {
          // if(FirebaseService().initialized) {
          //   return ResponsivePage(selectedIndex:0,title:'');
          // }
          // final initialIndex =
          // state.queryParameters['tab'] == 'articles' ? 1 : 0;
          return App();
          //   return ResponsivePage(selectedIndex:0,title:'');
        },
        '/loading': (context, state, data) {
          return Loading();
        },

        '/home': (context, state, data) {
          return BeamPage(
            type: BeamPageType.noTransition,
            key: const ValueKey('home'),
            child: ResponsivePage(selectedIndex:0,title:''),
          );
        },
        '/explore': (context, state, data) {
          // state.
          debugPrint('i just want to explore');
          return BeamPage(
            type: BeamPageType.noTransition,
            key: const ValueKey('explore'),
            child: ResponsivePage(selectedIndex:1,title:''),
          );
        },
        '/personal_profile': (context, state, data) {
          return BeamPage(
            type: BeamPageType.noTransition,
            key: const ValueKey('personal_profile'),
            child: ResponsivePage(selectedIndex:2,title:''),
          );
        },
        // '/books/:bookId': (context, state, data) {
        //   final bookId = state.pathParameters['bookId'];
        //   final book = books.firstWhere((book) => book['id'] == bookId);
        //   return BeamPage(
        //     key: ValueKey('book-$bookId'),
        //     title: book['title'],
        //     child: BookDetailsScreen(book: book),
        //     onPopPage: (context, delegate, _, page) {
        //       delegate.update(
        //         configuration: RouteInformation(
        //           location: '/?tab=books',
        //         ),
        //         rebuild: false,
        //       );
        //       return true;
        //     },
        //   );
        // },
        // 'articles/:articleId': (context, state, data) {
        //   final articleId = state.pathParameters['articleId'];
        //   final article =
        //   articles.firstWhere((article) => article['id'] == articleId);
        //   return BeamPage(
        //     key: ValueKey('articles-$articleId'),
        //     title: article['title'],
        //     child: ArticleDetailsScreen(article: article),
        //     onPopPage: (context, delegate, _, page) {
        //       delegate.update(
        //         configuration: RouteInformation(
        //           location: '/?tab=articles',
        //         ),
        //         rebuild: false,
        //       );
        //       return true;
        //     },
        //   );
        // },
      },
    ),
  );
}
