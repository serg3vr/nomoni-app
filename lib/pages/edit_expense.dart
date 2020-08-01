import 'package:flutter/material.dart';
import '../models/expenses_model.dart';
import 'dart:convert';

class EditExpense extends StatefulWidget {
  final String title = 'Edit Expense';
  final ExpensesModel expense;
  
  EditExpense({Key key, @required this.expense}) : super(key: key);

  @override
  _EditExpenseState createState() => _EditExpenseState();
}

class _EditExpenseState extends State<EditExpense> {

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
    print('llego aca');
    _loadExpense(widget.expense);
  }

  @override
  void dispose() {    
    amountController.dispose();
    conceptController.dispose();
    dateController.dispose();
    categoryIdController.dispose();
    super.dispose();
  }

  void _loadExpense(ExpensesModel expense) {
    // Map exp = expense.toJson();
    // print(exp['concept'].runtimeType);
    // amountController.text = exp['amount'];
    // conceptController.text = exp['concept'];
    // dateController.text = exp['date'];
    // categoryIdController.text = exp['category_id'];;

    setState(() {  
      // print(model); 
      // amountController.text = model.amount;
      // nameController.text = model.name;
    });
  }

  Future<void> _updateData(String amount, String name) async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // List<String> myList = (prefs.getStringList('myList') ?? List<String>());
    // ExpensesModel model = ExpensesModel(null, null, null, null, null, null, null, null, null, null, null, null, null);
    // myList[widget.index] = jsonEncode(model);
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
                  decoration: InputDecoration(
                    hintText: "Amount",
                    labelText: 'Amount: ',
                    icon: Icon(Icons.add_to_queue)
                  )
                ),
                TextFormField(
                  controller: conceptController,
                  decoration: InputDecoration(
                    labelText: 'Name: '
                  )
                ),
                RaisedButton(
                  onPressed: () {
                    _updateData(amountController.text, conceptController.text);
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
