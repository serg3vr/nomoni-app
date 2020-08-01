
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nomoni_app/models/expenses_model.dart';
import 'package:nomoni_app/pages/edit_expense.dart';
import 'package:nomoni_app/utils/user_prefs.dart';
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

  List<dynamic> expensesList = [];

  @override
  void initState() {
    super.initState();
    // _loadData();
	}

  Future<void> _loadData() async {
		int id = UserPrefs.instance.id;
    await api.get('spends/by-user/$id').then((response) {
      Map data = jsonDecode(response.body);
      bool result = data['result'];
      if (result) {
				expensesList = data['spends'];
      }
    });
  }

  Future<void> _deleteSpend(int id) async {
    await api.delete('spends/$id').then((response) {
      Map data = jsonDecode(response.body);
      bool result = data['result'];
      if (result) {
        expensesList = [];
        _loadData();
      }
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
							'Hello, ${expensesList.length} How are you?',
							textAlign: TextAlign.center,
							overflow: TextOverflow.ellipsis
						),
						Expanded(
							child: FutureBuilder (
								future: _loadData(),
								builder: (context, snapshot) {
									if (snapshot.connectionState == ConnectionState.done) {
										return Container(
											child: ListView.builder(
												itemCount: expensesList.length,
												itemBuilder: (context, index) {
													String concept = expensesList[index]['concept'];
													if (concept.length >= 22) {
														concept = expensesList[index]['concept'].substring(0, 22) + '...';
													}
													String createdAt = expensesList[index]['created_at'].substring(0, 16);
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
																		r"$ " + expensesList[index]['amount'],
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
                                  /* Map params = <String, dynamic>{
                                    'amount': double.parse(expensesList[index]['amount']),
                                    'date': expensesList[index]['date'],
                                    'concept': expensesList[index]['concept'],
                                    // 'note': expensesList[index]['/'],
                                    // 'type_id': expensesList[index]['/'],
                                    'category_id': int.parse(expensesList[index]['category_id']),
                                    // 'payment_method_id': paymentMethodIdController.text
                                  }; */
                                  // HERE parseand la categoria porque no jala como int
                                  // print(expensesList[index]);
                                  ExpensesModel expense = ExpensesModel.fromJson(expensesList[index]);
                                  // ExpensesModel expense = ExpensesModel.fromJson(params);
																	Navigator.push(
																		context,
																		MaterialPageRoute(
																			builder: (context) => EditExpense(expense: expense),
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
																	_deleteSpend(expensesList[index]['id']);
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
