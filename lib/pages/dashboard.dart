
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nomoni_app/pages/edit_expense.dart';
import 'package:nomoni_app/utils/user_prefs.dart';
import 'dart:convert';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:nomoni_app/utils/api.dart' as api;
import 'package:nomoni_app/widgets/MyDrawer.dart';

class Dashboard extends StatefulWidget {
  final String title;

  Dashboard({Key key, this.title}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {

  List<dynamic> expensesList = [];
  Future future;
  double dailyAmount = 0;
  double monthlyAmount = 0;
  @override
  void initState() {
    super.initState();
    future = _loadData();
  }

  Future<void> _loadData() async {
    await api.get('expenses/monthly-amount').then((response) {
      Map data = jsonDecode(response.body);
      bool result = data['result'];
      if (result) {
        monthlyAmount = double.parse(data['amount']);
      }
    });
    
    return api.get('expenses/daily-amount').then((response) {
      Map data = jsonDecode(response.body);
      print(data);
      bool result = data['result'];
      if (result) {
        dailyAmount = double.parse(data['amount']);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      drawer: MyDrawer(),
      body: Container(
				child: Column(
					children: <Widget>[
            Text(
							'Expenses summary',
							textAlign: TextAlign.center,
							overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 22.0
              ),
						),
            SizedBox(height: 6,),
						Text(
							'\$ $monthlyAmount',
							textAlign: TextAlign.center,
							overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 28.0
              ),
						),
            Text(
							'Current monthly expenses',
							textAlign: TextAlign.center,
							overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 18.0,
                color: Colors.blueGrey
              ),
						),
            SizedBox(height: 6,),
            SizedBox(height: 6,),
						Text(
							'\$ $dailyAmount',
							textAlign: TextAlign.center,
							overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 28.0
              ),
						),
            Text(
							'Current daily expenses',
							textAlign: TextAlign.center,
							overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 18.0,
                color: Colors.blueGrey
              ),
						),
            SizedBox(height: 6,),
						Expanded(
							child: FutureBuilder (
								future: future,
								builder: (context, snapshot) {
									if (snapshot.connectionState == ConnectionState.done) {
										return Container();
									} else {
										return CircularProgressIndicator();
									}
								}
							),
						),
					]
				)
			),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/add_expense');
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
