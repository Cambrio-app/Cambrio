

import 'package:cambrio/pages/responsive_main_page.dart';
import 'package:cambrio/services/firebase_service.dart';
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
          debugPrint('uh');
          FirebaseService service = FirebaseService.instance;
          service.addListener(() {
            debugPrint('listener triggered');
            if (service.initialized) {
              debugPrint('its initialized: ${location.toString()}');
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
          return ResponsivePage(selectedIndex: 0, title: '',);
        },
        '/explore': (context, state, data) {
          return ResponsivePage(selectedIndex: 1, title: '',);
        },
        '/personal_profile': (context, state, data) {
          return ResponsivePage(selectedIndex: 2, title: '',);
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