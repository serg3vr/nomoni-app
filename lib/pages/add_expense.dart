import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  final dateController = TextEditingController();
  final typeIdController = TextEditingController();
  final categoryIdController = TextEditingController();
  final paymentMethodIdController = TextEditingController();
  final noteController = TextEditingController();

  @override
  void dispose() {    
    amountController.dispose();
    nameController.dispose();
    super.dispose();
  }

  Future<void> _createAndPrintSpendData(String amount, String name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>  myList =  (prefs.getStringList('myList') ?? List<String>());
    ExpensesModel model = ExpensesModel(null, null, null, null, null, null, null, null, null, null, null, null, null);
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
                  controller: nameController,
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
