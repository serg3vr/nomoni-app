import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:nomoni_app/comm/option.dart';
import 'dart:convert';
import 'package:nomoni_app/utils/api.dart' as api;

class AddExpense extends StatefulWidget {
  final String title;

  AddExpense({Key key, this.title}) : super(key: key);

  @override
  _AddExpenseState createState() => _AddExpenseState();
}

class _AddExpenseState extends State<AddExpense> {
  Future options;
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
  String typesSelectTitle;
  String categoriesSelectTitle;
  String paymentMethodSelectTitle;

  @override
  void initState() {
    super.initState();
    var now = new DateTime.now();
    dateController.text = now.toString();
    typesSelectTitle = 'Types';
    categoriesSelectTitle = 'Category';
    paymentMethodSelectTitle = 'Payment method';
    options = _loadData();
	}

  Future<void> _loadData() async {
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

    return api.get('payment-methods/options').then((response) {
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
  }

  @override
  void dispose() {
    amountController.dispose();
    conceptController.dispose();
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
            future: options,
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
                    Container(
                      child: Row(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(right: 18.0),
                            child: Icon(
                              Icons.merge_type,
                              color: Colors.redAccent,
                              size: 24.0,
                            ),
                          ),
                          Container(
                            child: new DropdownButton<Option>(
                              hint: Text(typesSelectTitle),
                              // isExpanded: true,
                              items: typesOptions.map((Option option) {
                                return new DropdownMenuItem<Option>(
                                  value: option,  
                                  child: new Text(
                                    option.value,
                                    style: new TextStyle(color: Colors.black),
                                  ),
                                );
                              }).toList(),
                              onChanged: (_) {
                                setState(() {
                                  typeIdController.text = _.key.toString();
                                  typesSelectTitle = 'Type: ' + _.value;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: Row(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(right: 18.0),
                            child: Icon(
                              Icons.person,
                              color: Colors.redAccent,
                              size: 24.0,
                            ),
                          ),
                          Container(
                            child: new DropdownButton<Option>(
                              hint: Text(categoriesSelectTitle),
                              // isExpanded: true,
                              items: categoriesOptions.map((Option option) {
                                return new DropdownMenuItem<Option>(
                                  value: option,  
                                  child: new Text(
                                    option.value,
                                    style: new TextStyle(color: Colors.black),
                                  ),
                                );
                              }).toList(),
                              onChanged: (_) {
                                setState(() {
                                  categoryIdController.text = _.key.toString();
                                  categoriesSelectTitle = 'Category: ' + _.value;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: Row(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(right: 18.0),
                            child: Icon(
                              Icons.add_a_photo,
                              color: Colors.redAccent,
                              size: 24.0,
                            ),
                          ),
                          Container(
                            child: new DropdownButton<Option>(
                              hint: Text(paymentMethodSelectTitle),
                              // isExpanded: true,
                              items: paymentMethodsOptions.map((Option option) {
                                return new DropdownMenuItem<Option>(
                                  value: option,  
                                  child: new Text(
                                    option.value,
                                    style: new TextStyle(color: Colors.black),
                                  ),
                                );
                              }).toList(),
                              onChanged: (_) {
                                setState(() {
                                  paymentMethodIdController.text = _.key.toString();
                                  paymentMethodSelectTitle = 'Payment method: ' + _.value;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
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
