import 'package:flutter/material.dart';
import 'pages/login.dart';
import 'pages/expenses.dart';
import 'pages/add_expense.dart';
// import 'pages/edit_expense.dart';

void main() {
  runApp(MaterialApp(
    initialRoute: '/login',
    routes: <String, WidgetBuilder> {
      // '/': (BuildContext context) => Login(title: 'Login'),
      '/login': (BuildContext context) => Login(title: 'Login'),
      '/expenses': (BuildContext context) => Expenses(title: 'Expenses'),
      '/add_expense': (BuildContext context) => AddExpense(title: 'Add Expense'),
      // '/edit_expense': (BuildContext context) => EditExpense(),
    },
  ));
}