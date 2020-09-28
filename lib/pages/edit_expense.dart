import 'package:flutter/material.dart';
import 'package:nomoni_app/comm/option.dart';
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
    print('Termino cara cesot');
    expenseFuture = _loadOptions();
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
        paymentMethodIdController.text = exp.paymentMethodId.toString();
      }
    });
  }

  Future<void> _loadOptions() async {
    await api.get('types/options').then((response) {
      Map data = jsonDecode(response.body);
      bool result = data['result'];
      if (result) {
        List<dynamic> opt = data['options'];
        if (opt.length > 0) {
          typesOptions = opt.map((dynamic option) {
            return Option(option['value'], option['label']);
          }).toList();
        }				
      }
    });
    
    await api.get('categories/options').then((response) {
      Map data = jsonDecode(response.body);
      bool result = data['result'];
      if (result) {
        List<dynamic> opt = data['options'];
        if (opt.length > 0) {
          categoriesOptions = opt.map((dynamic option) {
            return Option(option['value'], option['label']);
          }).toList();
        }				
      }
    });

    await api.get('payment-methods/options').then((response) {
      Map data = jsonDecode(response.body);
      bool result = data['result'];
      if (result) {
        List<dynamic> opt = data['options'];
        if (opt.length > 0) {
          paymentMethodsOptions = opt.map((dynamic option) {
            return Option(option['value'], option['label']);
          }).toList();
        }				
      }
    });

    return _loadData(widget.id);
  }

  Future<void> _updateSpend(int id, Map params) async {
    await api.put('expenses/$id', params).then((response) {
      Map data = jsonDecode(response.body);
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
                    buildTypeContainer(),
                    buildCategoryList(),
                    buildPaymentMethodList(),
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

  Container buildTypeContainer() {
    return Container(
      margin: EdgeInsets.only(top: 8.0),
      child: Row(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(right: 18.0),
            child: Icon(
              Icons.add_call,
              color: Colors.redAccent,
              size: 24.0,
            ),
          ),
          Expanded(
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    child: Text(
                      'Type:',
                      style: new TextStyle(color: Colors.black54),
                    )
                  ),
                  Center(
                    child: Container(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        value: typeIdController.text,
                        items: typesOptions.map((Option option) {
                          return new DropdownMenuItem<String>(
                            value: (option.key).toString(),  
                            child: new Text(
                              option.value,
                              style: new TextStyle(color: Colors.black),
                            ),
                          );
                        }).toList(),
                        onChanged: (_) {
                          setState(() {
                            typeIdController.text = _.toString();
                          });
                        },
                      ),
                    ),
                  ),
                ],
              )
            ),
          ),
        ],
      ),
    );
  }

  Container buildCategoryList() {
    return Container(
      margin: EdgeInsets.only(top: 8.0),
      child: Row(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(right: 18.0),
            child: Icon(
              Icons.add_call,
              color: Colors.redAccent,
              size: 24.0,
            ),
          ),
          Expanded(
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    child: Text(
                      'Category:',
                      style: new TextStyle(color: Colors.black54),
                    )
                  ),
                  Center(
                    child: Container(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        value: categoryIdController.text,
                        items: categoriesOptions.map((Option option) {
                          return new DropdownMenuItem<String>(
                            value: (option.key).toString(),  
                            child: new Text(
                              option.value,
                              style: new TextStyle(color: Colors.black),
                            ),
                          );
                        }).toList(),
                        onChanged: (_) {
                          setState(() {
                            // typeIdController.text = _.toString();
                            categoryIdController.text = _.toString();
                          });
                        },
                      ),
                    ),
                  ),
                ],
              )
            ),
          ),
        ],
      ),
    );
  }

  Container buildPaymentMethodList() {
    return Container(
      margin: EdgeInsets.only(top: 8.0),
      child: Row(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(right: 18.0),
            child: Icon(
              Icons.add_call,
              color: Colors.redAccent,
              size: 24.0,
            ),
          ),
          Expanded(
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    child: Text(
                      'Payment method:',
                      style: new TextStyle(color: Colors.black54),
                    )
                  ),
                  Center(
                    child: Container(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        value: paymentMethodIdController.text,
                        items: paymentMethodsOptions.map((Option option) {
                          return new DropdownMenuItem<String>(
                            value: (option.key).toString(),  
                            child: new Text(
                              option.value,
                              style: new TextStyle(color: Colors.black),
                            ),
                          );
                        }).toList(),
                        onChanged: (_) {
                          setState(() {
                            // typeIdController.text = _.toString();
                            paymentMethodIdController.text = _.toString();
                          });
                        },
                      ),
                    ),
                  ),
                ],
              )
            ),
          ),
        ],
      ),
    );
  }
  
  List<DropdownMenuItem<dynamic>> buildList(List<Option> list) {
    return list.map((Option option) {
      return new DropdownMenuItem<Option>(
        value: option,  
        child: new Text(
          option.value,
          style: new TextStyle(color: Colors.black),
        ),
      );
    }).toList();
  }
}
