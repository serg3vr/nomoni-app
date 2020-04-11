// import 'dart:convert';

class ExpensesModel {
  final String amount;
  final String name;

  ExpensesModel(this.amount, this.name);

  ExpensesModel.fromJson(Map<String, dynamic> json): 
    amount = json['amount'],
    name = json['name'];

  Map<String, dynamic> toJson() => {
    'amount': amount,
    'name': name
  };
}