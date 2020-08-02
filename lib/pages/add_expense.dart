import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:nomoni_app/utils/api.dart' as api;

class AddExpense extends StatefulWidget {
  final String title;

  AddExpense({Key key, this.title}) : super(key: key);

  @override
  _AddExpenseState createState() => _AddExpenseState();
}

class _AddExpenseState extends State<AddExpense> {

  final amountController = TextEditingController();
  final conceptController = TextEditingController();
  final dateController = TextEditingController();
  // final typeIdController = TextEditingController();
  final categoryIdController = TextEditingController();
  // final paymentMethodIdController = TextEditingController();
  // final noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // _loadData();
    amountController.text = '100';
    conceptController.text = 'Algo';
    var now = new DateTime.now();
    dateController.text = now.toString();
    categoryIdController.text = '1';
	}

  @override
  void dispose() {
    amountController.dispose();
    conceptController.dispose();
    super.dispose();
  }

  Future<void> _createSpend(Map params) async {
    await api.post('spends', params).then((response) {
      // print(response.body);
      Map data = jsonDecode(response.body);
      bool result = data['result'];
      if (result) {
        Navigator.pushReplacementNamed(context, '/expenses');
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
                  controller: amountController,
                  keyboardType: TextInputType.numberWithOptions(
                    decimal: true,
                    signed: false
                  ),
                  decoration: InputDecoration(
                    hintText: "Amount: ",
                    labelText: 'Amount: ',
                    // icon: Icon(Icons.add_to_queue)
                  )
                ),
                TextFormField(
                  controller: conceptController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    hintText: 'Name: '
                  )
                ),
                TextFormField(
                  controller: dateController,
                  keyboardType: TextInputType.datetime,
                  decoration: InputDecoration(
                    hintText: 'Date: ',
                    icon: Icon(Icons.date_range)
                  ),
                ),
                TextFormField(
                  controller: categoryIdController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    hintText: 'Category: ',
                    icon: Icon(Icons.date_range)
                  ),
                ),
                /* Expanded(
                  child: new DropdownButton<String>(
                    items: <String>['A', 'B', 'C', 'D'].map((String value) {
                      return new DropdownMenuItem<String>(
                        value: value,
                        child: new Text(value),
                      );
                    }).toList(),
                    onChanged: (_) {
                      print(_);
                    },
                  ),
                ), */
                RaisedButton(
                  onPressed: () {
                    Map params = {
                      'amount': amountController.text,
                      'date': dateController.text,
                      'concept': conceptController.text,
                      // 'note': noteController.text,
                      // 'type_id': typeIdController.text,
                      'category_id': categoryIdController.text,
                      // 'payment_method_id': paymentMethodIdController.text
                    };
                    _createSpend(params);
                  },
                  child: Text('Save'),
                ),
              ],
            ),
          )
        )
      )
    );
  }
}
