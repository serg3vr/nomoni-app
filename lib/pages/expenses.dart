
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nomoni_app/pages/edit_expense.dart';
import 'package:nomoni_app/utils/user_prefs.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:nomoni_app/utils/api.dart' as api;

class Expenses extends StatefulWidget {
  final String title;

  Expenses({Key key, this.title}) : super(key: key);

  @override
  _ExpensesState createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> {

  List<dynamic> mySpendsList = [];

  @override
  void initState() {
    super.initState();
    // _loadData();
	}

  Future<void> _loadData() async {
		int id = UserPrefs.instance.id;
    await api.get('spends/by-user/$id').then((response) {
      print('Termino 0');
      Map data = jsonDecode(response.body);
      bool result = data['result'];
      if (result) {
				mySpendsList = data['spends'];
        print(mySpendsList.length);
      }
    });
  }

  Future<void> _deleteRow(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      mySpendsList.removeAt(index);
      List<String> auxList = [];
      for (var s in mySpendsList) {
        auxList.add(jsonEncode(s));
      }
      prefs.setStringList('myList', auxList);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
				child: Column(
					children: <Widget>[
						Text(
							'Hello, ${mySpendsList.length} How are you?',
							textAlign: TextAlign.center,
							overflow: TextOverflow.ellipsis
						),
						Expanded(
							child: FutureBuilder (
								future: _loadData(),
								builder: (context, snapshot) {
									print(snapshot.connectionState);
									if (snapshot.connectionState == ConnectionState.done) {
										return Container(
											child: ListView.builder(
												itemCount: mySpendsList.length,
												itemBuilder: (context, index) {
													String concept = mySpendsList[index]['concept'];
													if (concept.length >= 22) {
														concept = mySpendsList[index]['concept'].substring(0, 22) + '...';
													}
													String createdAt = mySpendsList[index]['created_at'].substring(0, 16);
													return Slidable(
														actionPane: SlidableDrawerActionPane(),
														actionExtentRatio: 0.25,
														child: ListTile(
															onTap: () {},
															title: Text(concept),
															subtitle: Text(createdAt),
															// leading: Icon(Icons.add_photo_alternate),
															leading: FlutterLogo(),
															trailing: Container(child: Column(
																children: <Widget>[
																	// FlutterLogo(),
																	Text(
																		r"$ " + mySpendsList[index]['amount'],
																		textDirection: TextDirection.ltr,
																		style: TextStyle(
																			fontSize: 24,
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
											)
										);
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
