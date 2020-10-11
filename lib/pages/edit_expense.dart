
import 'package:flutter/material.dart';
import 'package:nomoni_app/comm/option.dart';
import 'package:nomoni_app/widgets/OwnDropdown.dart';
import '../models/expenses_model.dart';
import 'dart:convert';
import 'package:nomoni_app/utils/api.dart' as api;
import 'package:nomoni_app/utils/helpers.dart' as helpers;

class EditExpense extends StatefulWidget {
  final String title = 'Edit Expense';
  final int id;
  
  EditExpense({Key key, @required this.id}) : super(key: key);

  @override
  _EditExpenseState createState() => _EditExpenseState();
}

class _EditExpenseState extends State<EditExpense> {
  
  Future expenseFuture;
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
    print('EDIT EXPENSE');
    _loadAll();
  }

  Future<void> _loadAll() async {
    expenseFuture = _loadOptions();
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

  Future<void> _loadData(id) async {
    return api.get('expenses/$id').then((response) {
      Map data = jsonDecode(response.body);
      bool result = data['result'];
      if (result) {
        var exp = ExpensesModel.fromJson(data['expense']);
        amountController.text = exp.amount.toString();
        conceptController.text = exp.concept;
        dateController.text = exp.date;
        typeIdController.text = exp.typeId.toString();
        categoryIdController.text = exp.categoryId.toString();
        paymentMethodIdController.text = (exp.paymentMethodId ?? '').toString();
        print('asd ${paymentMethodIdController.text}');
        for (var option in paymentMethodsOptions) {
          print(option.key);
          if (option.key == paymentMethodIdController.text) {
            print('si');
          } else {
            print('no');
          }
        }
      }
    });
  }

  Future<void> _loadOptions() async {
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

    await api.get('payment-methods/options').then((response) {
      Map data = jsonDecode(response.body);
      bool result = data['result'];
      if (result) {
        paymentMethodsOptions = Option.map(data['options']);
      }
    });

    return _loadData(widget.id);
  }

  Future<void> _updateSpend(int id, Map params) async {
    await api.put('expenses/$id', params).then((response) {
      Map data = jsonDecode(response.body);
      print(data);
      bool result = data['result'];
      if (result) {
        Navigator.pushReplacementNamed(context, '/expenses');
      } else {
        helpers.showMessage(context, data);
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
            future: expenseFuture,
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
                    // buildTypeContainer(),
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
                        // print(params);
                        _updateSpend(widget.id, params);
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
