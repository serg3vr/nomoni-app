import 'package:flutter/material.dart';
// import 'package:nomoni_app/api/api.dart';

class Dashboard extends StatefulWidget {
  final String title;

  Dashboard({Key key, this.title}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  
  @override
  void initState() {
    super.initState();

    // dynamic body = <String, String>{
    //   "email": "sergioavr93@hotmail.com",
    //   "password": "12345"
    // };
    
    // api.post('auth/login', body).then((response) {
    //   print (response);
    //   print (response.body);
    // });
  }

  @override
  Widget build(BuildContext context) {
    var debug1BoxD = BoxDecoration(
        color: Colors.red[300], border: Border.all(color: Colors.red[600]));

    var debug2BoxD = BoxDecoration(
        color: Colors.green[300], border: Border.all(color: Colors.green[600]));

    var debug3BoxD = BoxDecoration(
        color: Colors.blue[300], border: Border.all(color: Colors.blue[600]));

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              // backgroundColor: Colors.blue,
              decoration: debug1BoxD,
              child: Center(
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Current month spends',
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.grey[400],
                      ),
                    ),
                    Text(
                      r'$ 900.00',
                      style: TextStyle(
                        fontSize: 52.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.pink[700],
                      ),
                    ),
                    Divider(
                      height: 14.0,
                      color: Colors.grey[800]
                    ),
                    Text(
                      'Current daily spends',
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.grey[400],
                      ),
                    ),
                    Text(
                      r'$ 45.00',
                      style: TextStyle(
                        fontSize: 52.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.purple[700],
                      ),
                    ),
                    RaisedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/expenses');
                      },
                      child: Text('Spends'),
                    ),
                    // Text(
                    //   '$_counter',
                    //   style: Theme.of(context).textTheme.display1,
                    // ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                decoration: debug2BoxD,
                child: Text('Deliver features faster',
                    textAlign: TextAlign.center),
              ),
            ),
            Container(
              decoration: debug3BoxD,
              child: Center(
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Current month spends',
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.grey[400],
                      ),
                    ),
                    Text(
                      r'Fake $ 900.00',
                      style: TextStyle(
                        fontSize: 52.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.purpleAccent[700],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/add_expense');
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
