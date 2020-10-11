import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nomoni_app/comm/option.dart';
import 'dart:convert';
import 'package:nomoni_app/utils/api.dart' as api;
import 'package:nomoni_app/widgets/OwnDropdown.dart';

class AddExpense extends StatefulWidget {
  final String title;

  AddExpense({Key key, this.title}) : super(key: key);

  @override
  _AddExpenseState createState() => _AddExpenseState();
}

class _AddExpenseState extends State<AddExpense> {
  Future optionsFuture;
  final amountController = TextEditingController();
  final conceptController = TextEditingController();
  final dateController = TextEditingController();
  final typeIdController = TextEditingController();
  final categoryIdController = TextEditingController();
  final paymentMethodIdController = TextEditingController();
  // final noteController = TextEditingController();
  List<Option> typesOptions = [];
  List<Option> categoriesOptions = [];
  List<Option> paymentMethodsOptions = [];

  @override
  void initState() {
    super.initState();
    var now = new DateTime.now();
    dateController.text = now.toString();
    optionsFuture = _loadData();
	}

  Future<void> _loadData() async {
    await api.get('types/options').then((response) {
      Map data = jsonDecode(response.body);
      bool result = data['result'];
      if (result) {
        typesOptions = Option.map(data['options']);
      }
    });
    
    await api.get('categories/options').then((response) {
      Map data = jsonDecode(response.body);
      bool result = data['result'];
      if (result) {
        categoriesOptions = Option.map(data['options']);
      }
    });

    return await api.get('payment-methods/options').then((response) {
      Map data = jsonDecode(response.body);
      bool result = data['result'];
      if (result) {
        paymentMethodsOptions = Option.map(data['options']);
      }
    });
  }

  @override
  void dispose() {
    amountController.dispose();
    conceptController.dispose();
    dateController.dispose();
    typeIdController.dispose();
    categoryIdController.dispose();
    paymentMethodIdController.dispose();
    super.dispose();
  }

  Future<void> _createSpend(Map params) async {
    await api.post('expenses', params).then((response) {
      Map data = jsonDecode(response.body);
      print(data);
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
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: FutureBuilder(
            future: optionsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Column(
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
                        hintText: 'Concept: ',
                        labelText: 'Concept: ',
                      )
                    ),
                    TextFormField(
                      controller: dateController,
                      keyboardType: TextInputType.datetime,
                      decoration: InputDecoration(
                        hintText: 'Date: ',
                        labelText: 'Date: ',
                        icon: Icon(Icons.date_range)
                      ),
                    ),
                    createDropdown(
                      controller: typeIdController,
                      dropdownName: 'Type',
                      listOption: typesOptions,
                      onChanged: (_) {
                        setState(() {
                          typeIdController.text = _; // .toString();
                        });
                      }
                    ),
                    createDropdown(
                      controller: categoryIdController,
                      dropdownName: 'Category',
                      listOption: categoriesOptions,
                      onChanged: (_) {
                        setState(() {
                          categoryIdController.text = _; // .toString();
                        });
                      }
                    ),
                    createDropdown(
                      controller: paymentMethodIdController,
                      dropdownName: 'Payment method',
                      listOption: paymentMethodsOptions,
                      onChanged: (_) {
                        setState(() {
                          paymentMethodIdController.text = _; // .toString();
                        });
                      }
                    ),
                    RaisedButton(
                      onPressed: () {
                        Map params = {
                          'amount': amountController.text,
                          'date': dateController.text,
                          'concept': conceptController.text,
                          // 'note': noteController.text,
                          'type_id': typeIdController.text,
                          'category_id': categoryIdController.text,
                          'payment_method_id': paymentMethodIdController.text
                        };
                        _createSpend(params);
                        // print(params);
                      },
                      child: Text('Save'),
                    ),
                  ],
                );
              } else {
                return CircularProgressIndicator();
              }
            }
          ),
        ),
      )
    );
  }
}
