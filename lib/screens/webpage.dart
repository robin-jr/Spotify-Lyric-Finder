import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebScreen extends StatelessWidget {
  static String routeName = '/webScreen';

  @override
  Widget build(BuildContext context) {
    var data =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    var authorizationUrl = data['url'];
    var redirectUrl = data['redirectUrl'];
    print("Auth ${authorizationUrl.toString()}, redi: $redirectUrl");
    return Scaffold(
      appBar: AppBar(
        title: Text("Web"),
      ),
      body: WebView(
        javascriptMode: JavascriptMode.unrestricted,
        initialUrl: authorizationUrl.toString(),
        navigationDelegate: (navReq) {
          // if (navReq.url.startsWith(redirectUrl.toString())) {
          //   var responseUrl = Uri.parse(navReq.url);
          //   print("Response url is --> $responseUrl");
          //   Navigator.pop(context, responseUrl);
          //   return NavigationDecision.prevent;
          // }
          print("Atleast something happened");
          print("navreq --> ${navReq.url}");
          return NavigationDecision.navigate;
        },
      ),
    );
  }
}
