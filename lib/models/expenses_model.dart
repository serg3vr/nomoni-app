// import 'dart:convert';

class ExpensesModel {
  final String amount;
  final String name;
  final String date;
  final int typeId;
  final int categoryId;
  final int paymentMethodId;
  final String note;

  ExpensesModel(this.amount, this.name, this.date, this.typeId, this.categoryId, this.paymentMethodId, this.note);

  ExpensesModel.fromJson(Map<String, dynamic> json): 
    amount = json['amount'],
    name = json['name'],
    date = json['date'],
    typeId = json['typeId'],
    categoryId = json['categoryId'],
    paymentMethodId = json['paymentMethodId'],
    note = json['note'];

  Map<String, dynamic> toJson() => {
    'amount': amount,
    'name': name,
    'date': date,
    'typeId': typeId,
    'categoryId': categoryId,
    'paymentMethodId': paymentMethodId,
    'note': note
  };
}