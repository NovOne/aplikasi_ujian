import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const Home());
}

class Home extends StatelessWidget {
  const Home({Key? key}):super(key: key);
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: LoginPage()
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  String cachenama = '';
  bool isLoggedIn = false;
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  String? name;
  String? email;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  var x;

  @override
  void initState() {
    // checkLogin();
    super.initState();
    autoLogIn();
    // x = _login();
  }

  void autoLogIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    name = prefs.getString('cacheusername');
    email = prefs.getString('cacheemail');

    debugPrint('Nama' + name.toString());

    if (name != null && email != null) {
      setState(() {
        isLoggedIn = true;
      });
    } 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Stack(
        children: <Widget> [
          Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              iconTheme: const IconThemeData(
                color: Colors.green,
              ),
              elevation: 0,
              title: const Text('Masuk ke Akun', 
                style: TextStyle(color: Colors.green)),
              backgroundColor: Colors.transparent,
              centerTitle: true,
            ),
            body: isLoggedIn ? buildBody(context) : Container(
              color: Colors.transparent,
              child: ElevatedButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => const HomePage()));
                }
              )
            )
          )
        ]
      )
      );  
    }
  /* Future<void> createAccount() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('cacheusername', nameController.text);
    prefs.setString('cacheemail', emailController.text);

    setState(() {
      name = prefs.getString('cacheusername');
      isLoggedIn = true;
    });

    // if (isLoggedIn) Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => const HomePage()));
  }
  */
  Widget buildBody(BuildContext context) {
    return FutureBuilder(
      future: _login(),
      builder:(context, snapshot) {
        debugPrint(snapshot.data.toString());
        return const Center(child: CircularProgressIndicator());
      }
    );
  }

  Future<String> _login() async {
    await Future.delayed(const Duration(seconds: 3)).then((value) {
      debugPrint('masuk delayed');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (BuildContext context) {
          return const HomePage();
        })
      );
    });

    debugPrint('sebelum return');
    return 'not Logined';
  }

  Widget direct(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: ListView(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: nameController,
                textAlign: TextAlign.left,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(5.0),
                    ),
                  ),
                  hintText: 'Username'
                )
              ),
              Container(
                margin: const EdgeInsets.only(top:10),
                child: TextField(
                  controller: emailController,
                  textAlign: TextAlign.left,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(5.0),
                      ),
                    ),
                    hintText: 'Email'
                  )
                )
              ),
              Container(
                height: 50,
                margin: const EdgeInsets.only(top:10.0),
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary:Colors.purpleAccent,
                    textStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontStyle: FontStyle.normal
                    )
                  ),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => const HomePage()));
                    // createAccount();
                    /* final SharedPreferences prefs = await SharedPreferences.getInstance();
                    prefs.setString('cacheusername', nameController.text);
                    prefs.setString('cacheemail', emailController.text);

                    name = prefs.getString('cacheusername');
                    email = prefs.getString('cacheemail');

                    if (name != null && email != null) {
                      setState(() {
                        isLoggedIn = true;
                      });
                    }

                    if (isLoggedIn) Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => const HomePage()));   
                    */
                  }, 
                  child: const Text('Buat Akun'),
                )
              )                  ]
          )
        ]
      )
    );
  }

  /*@override
  Widget build(BuildContext context) {
    /* if (isLoggedIn) {
      // Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => const HomePage()));
      Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => const HomePage()));
    }*/

    return MaterialApp(
      home: Scaffold(
      key: _scaffoldKey,
      body: Stack(
        children: <Widget> [
          Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              iconTheme: const IconThemeData(
                color: Colors.green,
              ),
              elevation: 0,
              title: const Text('Masuk ke Akun', 
                style: TextStyle(color: Colors.green)),
              backgroundColor: Colors.transparent,
              centerTitle: true,
            ),
            body: isLoggedIn ? buildBody(context) : Container(
              child: ElevatedButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => const HomePage()));
                }
              )
            )
          )
        ]
      )
      )         
    );
  }*/
  
}