import 'package:flutter/material.dart';
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
  final nameController = TextEditingController();

  @override
  void dispose() {    
    amountController.dispose();
    nameController.dispose();
    super.dispose();
  }

  Future<void> _createAndPrintSpendData(String amount, String name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>  myList =  (prefs.getStringList('myList') ?? List<String>());
    ExpensesModel model = ExpensesModel(amount, name);
    myList.add(jsonEncode(model));
    prefs.setStringList('myList', myList);
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
                  decoration: InputDecoration(
                    hintText: "Amount: ",
                    labelText: 'Amount: ',
                    icon: Icon(Icons.add_to_queue)
                  )
                ),
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Name: '
                  )
                ),
                RaisedButton(
                  onPressed: () {
                    _createAndPrintSpendData(amountController.text, nameController.text);
                    // Navigator.pushNamed(context, '/expenses');
                    Navigator.pushReplacementNamed(context, '/expenses');
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
