import 'package:flutter/services.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:convert';


//import 'package:example/screens/gallery_screen.dart';

class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Settings', style: TextStyle(color: Theme.of(context).colorScheme.onSecondary)),
        // titleTextStyle: TextStyle(color: Colors.black),
      //   actions: [
      //   // IconButton(onPressed: () => Navigator.of(context).pop(), icon: const Icon(Icons.arrow_back))
      // ],
      ),
      body: SettingsList(
        sections: [
          SettingsSection(
            title: Text('Legal'),
            tiles: <SettingsTile>[
              SettingsTile(
                leading: Icon(Icons.assignment_ind_outlined),
                title: Text('Privacy Policy'),
                onPressed: (context) {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => MyPrivPol(),
                  ));
                },
              ),
              SettingsTile(
                leading: Icon(Icons.assignment_outlined),
                title: Text('Terms of Service'),
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
            title: Text("Account"),
            tiles: <SettingsTile>[
              SettingsTile(
                leading: Icon(Icons.account_box_outlined),
                title: Text("Log Out", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),

              ),
              SettingsTile(
                leading: Icon(Icons.cancel_outlined),
                title: Text("Deactivate Account", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),

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
    return Scaffold(
      appBar: AppBar(title: Text('Terms of Service')),
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
    return MaterialApp(
        home: Scaffold(
            body: WebViewLoad(path: 'assets/legal/cambrioPrivacyPolicy.html')
        )
    );
  }
}

