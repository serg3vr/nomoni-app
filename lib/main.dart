import 'package:flutter/material.dart';
import 'pages/dashboard.dart';
import 'pages/expenses.dart';
import 'pages/add_expense.dart';
import 'pages/edit_expense.dart';

void main() {
  runApp(MaterialApp(
    initialRoute: '/',
    routes: <String, WidgetBuilder> {
      '/': (BuildContext context) => Dashboard(title: 'Dashboard'),
      '/expenses': (BuildContext context) => Expenses(title: 'Expenses'),
      '/add_expense': (BuildContext context) => AddExpense(title: 'Add Expense'),
      '/edit_expense': (BuildContext context) => EditExpense(title: 'Edit Expense', index: 0),
    },
  ));
}