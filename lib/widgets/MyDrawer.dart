import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyDrawer extends StatefulWidget {

  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {

  Future<void> _logout () async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('jwt', null);
    Navigator.pushReplacementNamed(context, '/login');
  }

  void _goToHome () async {
    Navigator.pushReplacementNamed(context, '/expenses');
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
        DrawerHeader(
          child: Row(
            children: <Widget>[
              Icon(Icons.portrait, size: 72.0),
              Text('User name')
            ],
          ),
          decoration: BoxDecoration(
            color: Colors.blue,
          ),
        ),
        ListTile(
          leading: Icon(Icons.home),
          title: Text('Home'),
          onTap: () {
            _goToHome();
          },
        ),
        // ListTile(
        //   enabled: false,
        //   leading: Icon(Icons.pages),
        //   title: Text('Types'),
        //   onTap: () {
        //     // Update the state of the app.
        //     // ...
        //   },
        // ),
        ListTile(
          enabled: false,
          leading: Icon(Icons.category),
          title: Text('Categories'),
          onTap: () {
            // Update the state of the app.
            // ...
          },
        ),
        ListTile(
          enabled: false,
          leading: Icon(Icons.payment),
          title: Text('Payment methods'),
          onTap: () {
            // Update the state of the app.
            // ...
          },
        ),
        ListTile(
          leading: Icon(Icons.exit_to_app),
          title: Text('Logout'),
          onTap: () {
            _logout();
          },
        ),
      ],
      ),
    );
  }
}