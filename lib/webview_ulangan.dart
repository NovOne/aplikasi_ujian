import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/foundation.dart';
import 'dart:async';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:flutter/services.dart';

/* class UlanganApp extends StatelessWidget {
  // This widget is the root of your application.
  const UlanganApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return WebviewUlangan();
  }
}
*/

class WebviewUlangan extends StatefulWidget{
  final String? linkurl;

  const WebviewUlangan({Key? key, required this.linkurl}) : super(key: key);

  @override
  _WebviewUlanganState createState() => _WebviewUlanganState();
}

class _WebviewUlanganState extends State<WebviewUlangan> with WidgetsBindingObserver {

  bool isJudul = false;
  String? _judul;
  var title;
  Completer<WebViewController> controll = Completer<WebViewController>();
  WebViewController? wvControll;
  GlobalKey globalKey = GlobalKey();

  @override
  initState() {
    disableCapture();
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.inactive:
        debugPrint("Inactive");
        break;
      case AppLifecycleState.resumed:
        debugPrint("Resumed");
        break;
      case AppLifecycleState.paused:
        debugPrint("Paused");
        SystemNavigator.pop();
        break;
      case AppLifecycleState.detached:
        debugPrint("Detached");
        break;
    }
  }

  Future<void> disableCapture() async {
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE); // tidak bisa screenshot
  }
  
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBack,
      child: Scaffold(
        key: globalKey,
        appBar: AppBar(title: isJudul ? Text(title) : const Text( 'Webview Back Button ')),
        body: WebView(
          initialUrl: widget.linkurl,
          // initialUrl: 'https://flutter.dev/',
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (webViewController) async {
            controll.complete(webViewController);
            wvControll = webViewController;
            debugPrint(await webViewController.getTitle());
            _judul = await webViewController.getTitle();
            debugPrint('MASUUUUUUk onWebViewCreated');
            setState(() {
              isJudul = true;
              title = _judul;
            });
            // _controll=webViewController;
          },
          onProgress: (int progress) async {
            debugPrint("WebView is loading (progress : $progress%)");
            
            _judul = await wvControll!.getTitle();
            if (progress >= 50) {
              setState(() {
                title = _judul;
              });
              debugPrint(_judul);
            }
            debugPrint('============================================');
          },
          javascriptChannels: {
            _toasterJavascriptChannel(context),
          },
          navigationDelegate: (NavigationRequest request) {
            debugPrint('allowing navigation to $request');
            return NavigationDecision.navigate;
          },
          onPageStarted: (String url) async {
            debugPrint('Page started loading: $url');
          },
          onPageFinished: (String url) {
            debugPrint('Page finished loading: $url');
          },
          gestureNavigationEnabled: true,
        ),
      ),
    );
  }

  JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
      name: 'Toaster',
      onMessageReceived: (JavascriptMessage message) {
        // ignore: deprecated_member_use
        Scaffold.of(context).showSnackBar(
          SnackBar(content: Text(message.message)),
        );
      });
    }
  
  Future<bool> _onBack() async {
    var value = await wvControll!.canGoBack();  // check webview can go back
    if (value) {
      debugPrint ('dalaam ifffffff');
      wvControll!.goBack(); // perform webview back operation
      return false;
    } else {
      debugPrint ('dalam else');
      Navigator.pop(context,true);
      return false;
    }
  }
}