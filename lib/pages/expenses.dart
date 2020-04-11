import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nomoni_app/pages/edit_expense.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:flutter_slidable/flutter_slidable.dart';

class Expenses extends StatefulWidget {
  final String title;

  Expenses({Key key, this.title}) : super(key: key);

  @override
  _ExpensesState createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> {

  final List<Map> mySharedList = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> myList = (prefs.getStringList('myList') ?? List<String>());
    setState(() {
      for (var s in myList) {
        Map map = jsonDecode(s);
        mySharedList.add(map);
      }
    });
  }

  Future<void> _deleteRow(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      mySharedList.removeAt(index);
      List<String> auxList = [];
      for (var s in mySharedList) {
        auxList.add(jsonEncode(s));
      }
      prefs.setStringList('myList', auxList);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (mySharedList.length <= 0) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Loading...'),
        )
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView.builder(
        itemCount: mySharedList.length,
        itemBuilder: (context, index) {
          return Slidable(
            actionPane: SlidableDrawerActionPane(),
            actionExtentRatio: 0.25,
            child: ListTile(
                  onTap: () {},
                  title: Text(mySharedList[index]['amount']),
                  // leading: Icon(Icons.add_photo_alternate),
                  leading: FlutterLogo(),
                  trailing: Container(child: Column(
                    children: <Widget>[
                      FlutterLogo(),
                      Text(
                        r"$ " + mySharedList[index]['name'],
                        textDirection: TextDirection.ltr,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  )),
                ),
            actions: <Widget>[
              IconSlideAction(
                caption: 'Archive',
                color: Colors.blue,
                icon: Icons.archive,
                onTap: () { 
                  Scaffold.of(context).showSnackBar(SnackBar(
                    content: Text('Archive'),
                  ));
                }
              ),
              IconSlideAction(
                caption: 'Edit',
                color: Colors.indigo,
                icon: Icons.update,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditExpense(title: 'Edit Expense', index: index),
                    ),
                  );
                }
              ),
            ],
            secondaryActions: <Widget>[
              IconSlideAction(
                caption: 'More',
                color: Colors.black45,
                icon: Icons.more_horiz,
                onTap: () { 
                  Scaffold.of(context).showSnackBar(SnackBar(
                    content: Text('More'),
                  ));
                }
              ),
              IconSlideAction(
                caption: 'Delete',
                color: Colors.red,
                icon: Icons.delete,
                onTap: () {
                  _deleteRow(index);
                }
              ),
            ],
          );
        }
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
