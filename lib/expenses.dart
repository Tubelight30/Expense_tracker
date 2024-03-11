import 'package:expense_tracker/widgets/chart/chart.dart';
import 'package:expense_tracker/widgets/expenses_list/expense_item.dart';
import 'package:expense_tracker/widgets/expenses_list/expenses_list.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/widgets/new_expense.dart';
import 'package:flutter/material.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});
  @override
  State<Expenses> createState() {
    return _Expenses();
  }
}

class _Expenses extends State<Expenses> {
  final List<Expense> _registeredExpenses = [
    Expense(
      title: "Groceries",
      amount: 100.0,
      date: DateTime.now(),
      category: Category.food,
    ),
    Expense(
      title: "New Shoes",
      amount: 200.0,
      date: DateTime.now(),
      category: Category.leisure,
    ),
    Expense(
      title: "New Laptop",
      amount: 1500.0,
      date: DateTime.now(),
      category: Category.work,
    ),
  ];

  void _openAddExpenseOverlay() {
    showModalBottomSheet(
        useSafeArea: true,
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return NewExpense(
            onAddExpense: _addExpense,
          );
        });
  }

  void _addExpense(Expense expense) {
    setState(() {
      _registeredExpenses.add(expense);
    });
  }

  void _removeExpense(Expense expense) {
    final expenseIndex = _registeredExpenses.indexOf(expense);
    setState(() {
      _registeredExpenses.remove(expense);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(" Expense Removed"),
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
            label: "Undo",
            onPressed: () {
              setState(() {
                _registeredExpenses.insert(expenseIndex, expense);
              });
            }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    Widget mainContent = const Center(
      child: Text("No expenses found start adding some"),
    );
    if (_registeredExpenses.isNotEmpty) {
      mainContent = ExpensesList(
        onRemoveExpense: _removeExpense,
        expenses: _registeredExpenses,
      );
    }
    return Scaffold(
      resizeToAvoidBottomInset: false,
      //!added this to avoid resizing of the screen when keyboard is open.
      //!when the modal bottom sheet is open in landscape it was resizing the chart and it was overflowing.
      //!now only the modal bottom sheet will become scrollable when keyboard is open and this scaffold will not resize.
      appBar: AppBar(
        title: Text("Flutter Expense Tracker"),
        actions: [
          IconButton(
            onPressed: _openAddExpenseOverlay,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: width < 600
          ? Column(
              children: [
                Chart(expenses: _registeredExpenses),
                Expanded(
                  child: mainContent,
                ),
              ],
            )
          : Row(
              children: [
                Expanded(child: Chart(expenses: _registeredExpenses)),
                Expanded(
                  child: mainContent,
                ),
              ],
            ),
    );
  }
}
