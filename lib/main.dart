import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'webview_ulangan.dart';
// import 'package:http/http.dart' as http;

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Location')),
        body: HomePage()
      )
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  var data;
  bool linkuts1 = false;
  bool linkuts2 = false;
  String? strlinkuts1;
  String? strlinkuts2;

  @override
  void initState () {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.bottom]); // Untuk menghilangkan status bar/notification bar
    // markerIcon(); // Add marker for only current location
    // getLocation();
    super.initState();
    getData();
  }

  Future<String> getData() async {
    String? response;
    const kelas = "X AK 1";
    var url = "https://raw.githubusercontent.com/NovOne/FindTambalban/master/assets/daftar.json";

    try {
      // var res = await http.get(Uri.parse(url), headers: { 'Content-Type':'application/json' });
      // data = await json.decode(res.body);

      response = await rootBundle.loadString('assets/daftar_menu.json');
      data = await json.decode(response.toString());
    }
    catch (e) {
      debugPrint('Kesalahan: ' + e.toString());
    }

    // debugPrint (data['hasil'][0]['uts1']);
    debugPrint (data['link_uts1']);

    if (kelas == "X AK 1") {
      linkuts1 = data['hasil'][0]['uts1'];
      linkuts2 = data['hasil'][0]['uts2'];
    }
    else if (kelas == "X AK 2") {
      linkuts1 = data['hasil'][1]['uts1'];
      linkuts2 = data['hasil'][1]['uts2'];
    }
    else if (kelas == "X AK 3") {
      linkuts1 = data['hasil'][2]['uts1'];
      linkuts2 = data['hasil'][2]['uts2'];
    }

    strlinkuts1 = data['link_uts1'];
    strlinkuts2 = data['link_uts2'];
    return 'Sukses';
  }
  
  @override
  void dispose() {
    super.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values); // untuk menjadikan normal kembali tampilannya
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(children: [
        ElevatedButton.icon(
          icon: Icon(Icons.book_online_rounded, size: 24.0),
          label: const Text("Ulangan Harian 1"),
          onPressed: linkuts1 ? null : () async {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => WebviewUlangan(linkurl: strlinkuts1)));
          },
          style: TextButton.styleFrom(backgroundColor: Colors.green)
        ),
        ElevatedButton.icon(
          icon: const Icon(Icons.book_online_rounded, size: 24.0),
          label: const Text("Ulangan Harian 2"),
          onPressed: linkuts2 ? null : () async {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => WebviewUlangan(linkurl: strlinkuts2)));
          },
          style: TextButton.styleFrom(backgroundColor: Colors.green)
        )
      ])
    );
  }
}