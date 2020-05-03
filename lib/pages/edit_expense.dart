import 'package:flutter/material.dart';
import '../models/expenses_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class EditExpense extends StatefulWidget {
  final String title;
  final int index;
  
  EditExpense({Key key, this.title, @required this.index}) : super(key: key);

  @override
  _EditExpenseState createState() => _EditExpenseState();
}

class _EditExpenseState extends State<EditExpense> {

  final List<Map> mySharedList = [];
  final amountController = TextEditingController();
  final nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadRowData(widget.index);
  }

  @override
  void dispose() {    
    amountController.dispose();
    nameController.dispose();
    super.dispose();
  }

  Future<void> _loadRowData(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> myList = (prefs.getStringList('myList') ?? List<String>());
    Map map = jsonDecode(myList[index]);
    ExpensesModel model = ExpensesModel.fromJson(map);

    setState(() {  
      amountController.text = model.amount;
      nameController.text = model.name;
    });
  }

  Future<void> _updateData(String amount, String name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> myList = (prefs.getStringList('myList') ?? List<String>());
    ExpensesModel model = ExpensesModel(amount, name, null, null, null, null, null);
    myList[widget.index] = jsonEncode(model);
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
                    hintText: "Amount",
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
                    _updateData(amountController.text, nameController.text);
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
