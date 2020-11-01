
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
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
  List<dynamic> categoriesList = [];
  List<dynamic> typesList = [];
  List<dynamic> paymentMethodsList = [];
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
    
    await api.get('expenses/daily-amount').then((response) {
      Map data = jsonDecode(response.body);
      bool result = data['result'];
      if (result) {
        dailyAmount = double.parse(data['amount']);
      }
    });

    // Expenses by categories
    await api.get('expenses/by-categories').then((response) {
      Map data = jsonDecode(response.body);
      bool result = data['result'];
      if (result) {
        categoriesList = data['expenses'];
      }
    });

    // Expenses by types
    await api.get('expenses/by-types').then((response) {
      Map data = jsonDecode(response.body);
      bool result = data['result'];
      if (result) {
        typesList = data['expenses'];
      }
    });

    // // Expenses by payment methods
    await api.get('expenses/by-payment-methods').then((response) {
      Map data = jsonDecode(response.body);
      bool result = data['result'];
      if (result) {
        paymentMethodsList = data['expenses'];
      }
    });

    return api.get('expenses/divided-by-months?pastMonths=5').then((response) {
      Map data = jsonDecode(response.body);
      bool result = data['result'];
      if (result) {
        expensesList = data['months'];
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
      body: SingleChildScrollView(
        child: bodyWidget(),
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

  Widget bodyWidget() {
    return FutureBuilder (
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Container(
            // color: Colors.amber,
            margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 4.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  'Expenses summary',
                  // textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 22.0
                  ),
                ),
                SizedBox(height: 24,),
                Text(
                  '\$ $monthlyAmount',
                  textAlign: TextAlign.left,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 32.0
                  ),
                ),
                Text(
                  'Current monthly expenses',
                  textAlign: TextAlign.left,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 18.0,
                    color: Colors.grey[400]
                  ),
                ),
                SizedBox(height: 24,),
                Text(
                  '\$ $dailyAmount',
                  textAlign: TextAlign.left,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 28.0
                  ),
                ),
                Text(
                  'Current daily expenses',
                  textAlign: TextAlign.left,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 18.0,
                    color: Colors.grey[400]
                  ),
                ),
                SizedBox(height: 24,),
                //////////////////////////////////////////////////
                //////////////////////////////////////////////////
                lastFiveMonthsWidget(),
                SizedBox(height: 24,),
                expensesByCategoriesWidget(),
                SizedBox(height: 24,),
                expensesByTypesWidget(),
                SizedBox(height: 24,),
                expensesByPaymentMethodsWidget(),
                squareSectionWidget(),
                //////////////////////////////////////////////////
                //////////////////////////////////////////////////
              ]
            )
          );
        } else {
          return CircularProgressIndicator();
        }
      }
    );  
  }

  Widget lastFiveMonthsWidget() {
    return Container(
      child: Column(
        children: <Widget>[
          Text(
            'Expenses',
            // textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontWeight: FontWeight.w400,
              color: Colors.grey[800],
              fontSize: 22.0
            ),
          ),
          Text(
            'Overview of Last five months of Expenses',
            // textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontWeight: FontWeight.w400,
              color: Colors.grey[400],
              fontSize: 16.0
            ),
          ),
          Container(
            height: 372.0,
            child: ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              itemCount: expensesList.length,
              itemBuilder: (context, index) {
                String date = expensesList[index]['date'];
                // String amount = expensesList[index]['date'];
                if (date.length >= 22) {
                  date = expensesList[index]['date'].substring(0, 22) + '...';
                }
                return ListTile(
                  // onTap: () {},
                  title: Text(date),
                  trailing: Container(child: Column(
                    children: <Widget>[
                      // FlutterLogo(),
                      Text(
                        r"$ " + expensesList[index]['amount'].toString(),
                        textDirection: TextDirection.ltr,
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  )),
                );
              }
            )
          ),
        ],
      ),
    );
  }
  
  Widget expensesByCategoriesWidget() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Expenses by category',
            textAlign: TextAlign.left,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontWeight: FontWeight.w400,
              color: Colors.grey[800],
              fontSize: 22.0
            ),
          ),
          Text(
            'Overview of Expenses by Category',
            // textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontWeight: FontWeight.w400,
              color: Colors.grey[400],
              fontSize: 16.0
            ),
          ),
          Container(
            height: 372.0,
            child: ListView.builder(
              // physics: NeverScrollableScrollPhysics(),
              itemCount: categoriesList.length,
              itemBuilder: (context, index) {
                // String date = categoriesList[index]['date'];
                // if (date.length >= 22) {
                //   date = categoriesList[index]['date'].substring(0, 22) + '...';
                // }
                return ListTile(
                  // onTap: () {},
                  title: Text(categoriesList[index]['name']),
                  trailing: Container(child: Column(
                    children: <Widget>[
                      // FlutterLogo(),
                      Text(
                        r"$ " + categoriesList[index]['amount'].toString(),
                        textDirection: TextDirection.ltr,
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  )),
                );
              }
            )
          ),
        ],
      ),
    );
  }

  Widget expensesByTypesWidget() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Expenses by types',
            // textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontWeight: FontWeight.w400,
              color: Colors.grey[800],
              fontSize: 22.0
            ),
          ),
          Text(
            'Overview of Expenses by types',
            // textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontWeight: FontWeight.w400,
              color: Colors.grey[400],
              fontSize: 16.0
            ),
          ),
          Container(
            height: 372.0,
            child: ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              itemCount: typesList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  // onTap: () {},
                  title: Text(typesList[index]['name']),
                  trailing: Container(child: Column(
                    children: <Widget>[
                      // FlutterLogo(),
                      Text(
                        r"$ " + typesList[index]['amount'].toString(),
                        textDirection: TextDirection.ltr,
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  )),
                );
              }
            )
          ),
        ],
      ),
    );
  }

  Widget expensesByPaymentMethodsWidget() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Expenses by payment methods',
            // textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontWeight: FontWeight.w400,
              color: Colors.grey[800],
              fontSize: 22.0
            ),
          ),
          Text(
            'Overview of Expenses by payment methods',
            // textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontWeight: FontWeight.w400,
              color: Colors.grey[400],
              fontSize: 16.0
            ),
          ),
          Container(
            height: 372.0,
            child: ListView.builder(
              // physics: NeverScrollableScrollPhysics(),
              itemCount: paymentMethodsList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  // onTap: () {},
                  title: Text(paymentMethodsList[index]['name']),
                  trailing: Container(child: Column(
                    children: <Widget>[
                      // FlutterLogo(),
                      Text(
                        r"$ " + paymentMethodsList[index]['amount'].toString(),
                        textDirection: TextDirection.ltr,
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  )),
                );
              }
            )
          ),
        ],
      ),
    );
  }

  Widget squareSectionWidget() {
    return Container(
      // color: Colors.green,
      // height: 360.0,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                singleSquareWidget(),
                singleSquareWidget()
              ]
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                singleSquareWidget(),
                singleSquareWidget()
              ]
            ),
          )
        ]
      )
    );
  }

  Widget singleSquareWidget() {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, '/expenses');
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.red,
          ),
          borderRadius: BorderRadius.all(Radius.circular(8)),
          // color: Colors.red[400]
        ),
        padding: const EdgeInsets.all(16),
        margin: EdgeInsets.all(16),
        // color: Colors.teal[100],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.money_off,
              size: 34,
              ),
            Text(
              'Expenses 1',
              textAlign: TextAlign.left,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 18.0,
                // color: Colors.grey[400]
              ),
            )
          ],
        ),
      ),
    );
  }
}
