import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nomoni_app/utils/user_prefs.dart';
import '../models/expenses_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

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
  final typeIdController = TextEditingController();
  final categoryIdController = TextEditingController();
  final paymentMethodIdController = TextEditingController();
  final noteController = TextEditingController();

  @override
  void dispose() {    
    amountController.dispose();
    conceptController.dispose();
    super.dispose();
  }

  Future<void> _createAndPrintSpendData(String amount, String name) async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // List<String>  myList =  (prefs.getStringList('myList') ?? List<String>());
    // ExpensesModel model = ExpensesModel(null, null, null, null, null, null, null, null, null, null, null, null, null);
    // myList.add(jsonEncode(model));
    // prefs.setStringList('myList', myList);
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
                    // labelText: 'Amount: ',
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
                  controller: typeIdController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    hintText: 'Type: ',
                    icon: Icon(Icons.merge_type)
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
                TextFormField(
                  controller: paymentMethodIdController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    hintText: 'PaymentMethod: ',
                    icon: Icon(Icons.date_range)
                  ),
                ),
                TextFormField(
                  controller: noteController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    hintText: 'Note: ',
                    icon: Icon(Icons.date_range)
                  ),
                ),
                new DropdownButton<String>(
                  items: <String>['A', 'B', 'C', 'D'].map((String value) {
                    return new DropdownMenuItem<String>(
                      value: value,
                      child: new Text(value),
                    );
                  }).toList(),
                  onChanged: (_) {},
                ),
                RaisedButton(
                  onPressed: () {
                    // _createAndPrintSpendData(amountController.text, conceptController.text);
                    var createAt = dateController.text;
                    var concept = conceptController.text;
                    var amount = amountController.text;
                    ExpensesModel expense = ExpensesModel(
                      null,
                      null,
                      null,
                      null,
                      null,
                      BigInt.parse(amountController.text),
                      dateController.text,
                      conceptController.text,
                      null,
                      int.parse(typeIdController.text),
                      int.parse(categoryIdController.text),
                      int.parse(paymentMethodIdController.text),
                      UserPrefs.instance.id
                    );
                    print(expense);
                    // Navigator.pushReplacementNamed(context, '/expenses');
                    print(createAt);
                    print(concept);
                    print(amount);
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
