import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nomoni_app/utils/api.dart' as api;
import 'package:nomoni_app/utils/helpers.dart' as helpers;
import 'package:nomoni_app/utils/user_prefs.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  final String title;

  Login({Key key, this.title}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();

  Future<void> _loadPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String jwt = (prefs.getString('jwt') ?? '');
    bool emptyToken = ["", null, false, 0].contains(jwt);

    if (emptyToken) { return; }

    UserPrefs.instance.jwt = jwt;
    api.get('users/profile').then((response) {
      print(response.body);
      Map data = jsonDecode(response.body);
      bool result = data['result'];
      if (result) {
        UserPrefs.instance.id = data['user']['id'];
        // print('D: Este es el id ${UserPrefs.instance.id}');
        Navigator.pushReplacementNamed(context, '/expenses');
      }
    });
  }

  // _LoginState () {
  //   emailCtrl.text = 'sergioavr93@hotmail.com';
  //   passwordCtrl.text = '12345';
  //   _loadPrefs();
  // }

  @override
  void initState() {
    super.initState();
    emailCtrl.text = 'sergioavr93@hotmail.com';
    passwordCtrl.text = '12345';
    _loadPrefs();
  }

  @override
  void dispose() {
    emailCtrl.dispose();
    passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _logIn() async {
    dynamic body = <String, String> {
      'email': emailCtrl.text,
      'password': passwordCtrl.text
    };
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await api.post('auth/login', body).then((response) {
      Map data = json.decode(response.body);
      bool result = data['result'];
      prefs.setString('jwt', data['jwt']);
      if (result) {
        _loadPrefs();
      } else {
        helpers.showMessage(context, data);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Card(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Form(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  controller: emailCtrl,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    hintText: 'User: ',
                    icon: Icon(Icons.account_box)
                  ),
                  maxLength: 50,
                ),
                TextField(
                  controller: passwordCtrl,
                  keyboardType: TextInputType.visiblePassword,
                  decoration: InputDecoration(
                    hintText: 'Password: ',
                    icon: Icon(Icons.security)
                  ),
                  maxLength: 20,
                  obscureText: true
                ),
                RaisedButton(
                  onPressed: () async {
                    _logIn();
                  },
                  child: Text('Sign In'),
                ),
              ],
            ),
          )
        )
      )
    );
  }
}
