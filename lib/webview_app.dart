/* FILE NAME: webview_app.dart */

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/foundation.dart';
import 'dart:async';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';

// import 'backevent_notifier.dart';

class AppUjianHome extends StatefulWidget{
  final String? initUrl;

  const AppUjianHome({Key? key, required this.initUrl}) : super(key: key);
  
  @override
  State<AppUjianHome> createState() => AppUjianState();
}

class AppUjianState extends State<AppUjianHome> {
  Completer<WebViewController> controll = Completer<WebViewController>();
  String? _judul;
  var title;
  bool isJudul = false;
  WebViewController? wvControll;
  GlobalKey globalKey = GlobalKey();

  @override
  initState() {
    disableCapture();
    super.initState();
  }

  Future<void> disableCapture() async {
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE); // tidak bisa screenshot
  }

  Future<String?> getJudul() async {
    debugPrint(await wvControll!.getTitle());
    _judul = await wvControll!.getTitle();
    debugPrint(_judul);
    debugPrint('Masuk getTitle');

    return _judul;
  }
  
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBack,
      child: Scaffold(
        key: globalKey,
        appBar: AppBar(title: isJudul ? Text(title) : const Text( 'Ujian Online')),
        body: WebView(
          // initialUrl: 'https://flutter.dev/',
          initialUrl: widget.initUrl,
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (webViewController) async {
            controll.complete(webViewController);
            wvControll = webViewController;
            var c = await getJudul();
            if (c != '') {
              setState(() {
                title = c; 
                isJudul = true;
              });
            }
            
          },
          onProgress: (int progress) async {
            debugPrint("WebView is loading (progress : $progress%)");
            debugPrint(await wvControll!.getTitle());
            var c = await getJudul();
            if (c != '') {
              setState(() {
                title = c; 
                isJudul = true;
              });
            }
            /*if (progress == 50) {
              debugPrint(await wvControll!.getTitle());
              setState(() {
                title = wvControll!.getTitle();
              });
            }
            debugPrint('============================================'); */
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

    // bool goBack;
    var value = await wvControll!.canGoBack();  // check webview can go back
    if (value) {
      // _controll.goBack(); // perform webview back operation
      wvControll!.goBack();
      return false;
    } else {
      debugPrint ('dalam else');
      return false;
    }
  }
}