import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const LoginPage());
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
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // checkLogin();
    super.initState();
    autoLogIn();
  }

  void autoLogIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? name = prefs.getString('name');
    final String? email = prefs.getString('email');

    if (name != '') {
      setState(() {
        isLoggedIn = true;
      });
    }
  }

  Future<String> createAccount() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('username', nameController.text);
    prefs.setString('email', emailController.text);

    setState(() {
      isLoggedIn = true;
    });

    return 'Sukses';
  }


  @override
  Widget build(BuildContext context) {
    if (!isLoggedIn) {
      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => const HomePage()));
    }

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
            body: isLoggedIn ? const Text ('Harap tunggu') : Builder(
              builder: (context) => Container(
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
                    margin: EdgeInsets.only(top:10),
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
                    margin: EdgeInsets.only(top:10.0),
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
                         createAccount();   
                      },
                        child: const Text('Buat Akun'),
                    )
                  )                  ]
                    )
                  ]
              )
              )       
          )
          )
        ]
      )         
    )
    );
  }
}