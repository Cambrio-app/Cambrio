import 'package:cambrio/services/firebase_service.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:convert';

import '../models/tutorials_state.dart';


//import 'package:example/screens/gallery_screen.dart';

class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    // log the page view
    FirebaseAnalytics.instance
        .setCurrentScreen(
        screenName: 'settings'
    );

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('Settings', style: TextStyle(color: Theme.of(context).colorScheme.onSecondary, fontSize: 18)),
        // titleTextStyle: TextStyle(color: Colors.black),
      //   actions: [
      //   // IconButton(onPressed: () => Navigator.of(context).pop(), icon: const Icon(Icons.arrow_back))
      // ],
      ),
      body: SettingsList(
        sections: [
          SettingsSection(
            title: Text('Help', style: Theme.of(context).textTheme.titleMedium),
              tiles: <SettingsTile>[
                SettingsTile(
                  leading: const Icon(Icons.help_center),
                  title: Text('Show the tutorials again.', style: Theme.of(context).textTheme.titleMedium),
                  onPressed: (context) {
                    TutorialsState.instance.resetSawTutorial();
                  }
                ),
              ],
          ),
          SettingsSection(
            title: Text('Legal', style: Theme.of(context).textTheme.titleMedium),
            tiles: <SettingsTile>[
              SettingsTile(
                leading: const Icon(Icons.assignment_ind_outlined),
                title: Text('Privacy Policy', style: Theme.of(context).textTheme.titleMedium),
                onPressed: (context) {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => MyPrivPol(),
                  ));
                },
              ),
              SettingsTile(
                leading: const Icon(Icons.assignment_outlined),
                title: Text('Terms of Service', style: Theme.of(context).textTheme.titleMedium),
                onPressed: (context) {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => MyToS(),
                  ));
                },
                //make popup tray, display html [[maybe using html editor - enhanced]]
              ),
            ],
          ),
          SettingsSection(
            title: Text("Account", style: Theme.of(context).textTheme.titleMedium),
            tiles: <SettingsTile>[
              SettingsTile(
                onPressed: (context) async {
                  FirebaseService().logOut(context);
                  },
                leading: const Icon(Icons.account_box_outlined),
                title: Text("Log Out", style: TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.bold, color: Colors.black)),

              ),
              SettingsTile(
                onPressed: (context) async {
                  FirebaseService().deleteAccount(context);
                },
                leading: const Icon(Icons.cancel_outlined),
                title: Text("Deactivate Account", style: TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.bold, color: Colors.black)),

              )
            ]
          )
        ],
      ),
    );
  }
}

class MyToS extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            body: WebViewLoad(path: 'assets/legal/cambrioTermsOfService.html')
        )
    );
  }
}

class WebViewLoad extends StatefulWidget {
  String path;


  WebViewLoad({Key? key, required this.path}) : super(key: key);

  WebViewLoadUI createState() => WebViewLoadUI();

}

class WebViewLoadUI extends State<WebViewLoad>{
  late WebViewController webViewController;
  late final String htmlFilePath = widget.path;

  loadLocalHTML() async{

    String fileHtmlContents = await rootBundle.loadString(htmlFilePath);
    webViewController.loadUrl(Uri.dataFromString(fileHtmlContents,
        mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
        .toString());
  }

  @override
  Widget build(BuildContext context) {
    // log the page view
    FirebaseAnalytics.instance
        .setCurrentScreen(
        screenName: 'terms_of_service'
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Terms of Service')),
      body: WebView(
        initialUrl: '',
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController tmp) {
          webViewController = tmp;
          loadLocalHTML();
        },
      ),
    );
  }
}

class MyPrivPol extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    // log the page view
    FirebaseAnalytics.instance
        .setCurrentScreen(
        screenName: 'privacy_policy'
    );

    return MaterialApp(
        home: Scaffold(
            body: WebViewLoad(path: 'assets/legal/cambrioPrivacyPolicy.html')
        )
    );
  }
}

