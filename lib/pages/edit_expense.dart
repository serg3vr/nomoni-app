import 'package:flutter/material.dart';
import '../models/expenses_model.dart';
import 'dart:convert';
import 'package:nomoni_app/utils/api.dart' as api;

class EditExpense extends StatefulWidget {
  final String title = 'Edit Expense';
  final int id;
  
  EditExpense({Key key, @required this.id}) : super(key: key);

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

  Map<String, dynamic> expense;

  @override
  void initState() {
    super.initState();
    print('llego aca');
    _loadData(widget.id);
  }

  @override
  void dispose() {    
    amountController.dispose();
    conceptController.dispose();
    dateController.dispose();
    categoryIdController.dispose();
    super.dispose();
  }

  Future<void> _loadData(id) async {
    await api.get('expenses/$id').then((response) {
      Map data = jsonDecode(response.body);
      // print (response.body);
      bool result = data['result'];
      if (result) {
				expense = data['expense'];
        // print(expense);
        amountController.text = expense['amount'];
        conceptController.text = expense['concept'];
        dateController.text = expense['date'];
        categoryIdController.text = expense['category_id'].toString();

      }
    });
  }

  Future<void> _updateSpend(int id, Map params) async {
    await api.put('expenses/$id', params).then((response) {
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
                    _updateSpend(widget.id, params);
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
